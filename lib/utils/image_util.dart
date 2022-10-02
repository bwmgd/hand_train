import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

/// 图像工具类
class ImageUtils {
  /// 转换 [CameraImage]的 YUV420 或者 BGRA8888 到[image_lib.Image]的 RGB 格式
  static image_lib.Image convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    }
    return convertBGRA8888ToImage(cameraImage);
  }

  /// BGRA8888 -> RGB
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    image_lib.Image img = image_lib.Image.fromBytes(
        cameraImage.planes[0].width ?? -1,
        cameraImage.planes[0].height ?? -1,
        cameraImage.planes[0].bytes,
        format: image_lib.Format.bgra);
    return img;
  }

  /// YUV420 -> RGB
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel ?? -1;

    final image = image_lib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils.yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  /// 转换 YUV 格式的单个像素到 RGB
  static int yuv2rgb(int y, int u, int v) {
    // 将yuv像素转换为rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // 将 RGB 值剪裁到 [0,255]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }
}
