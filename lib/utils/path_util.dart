class PathUtil {
  static const String _imagePath = "assets/images/";
  static const String _videoPath = "assets/videos/";
  static const String _imageAppend = ".png";
  static const String _videoAppend = ".mp4";

  static const String modelFileName = "tflite/best-fp16.tflite";

  static const String backgroundFileName = "assets/images/background.png";

  static String getImagePath(String name) {
    return _imagePath + name + _imageAppend;
  }

  static String getVideoPath(String name) {
    return _videoPath + name + _videoAppend;
  }
}
