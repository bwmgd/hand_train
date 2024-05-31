import 'dart:math' hide log;

import 'package:image/image.dart' as img;
import 'package:my_flutter_app/utils/path_util.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';

class Classifier {
  Interpreter? _interpreter; //解析器
  late TensorBuffer _outputBuffer; //输出流

  static const int _inputSize = 640; //输入图片大小

  ImageProcessor? _imageProcessor; //图像预处理器

  static const double clsConfTh = 0.70;
  static const int clsNum = 8;

  Classifier({
    Interpreter? interpreter,
  }) {
    loadModel(interpreter: interpreter);
  }

  /// 加载模型
  void loadModel({Interpreter? interpreter}) async {
    _interpreter = interpreter ??
        await Interpreter.fromAsset(
          PathUtil.modelFileName,
          options: InterpreterOptions()..threads = 4, //4线程
        );

    _outputBuffer = TensorBuffer.createFixedSize(
        _interpreter!.getOutputTensor(0).shape,
        _interpreter!.getOutputTensor(0).type);
  }

  /// 预处理图像
  TensorImage getProcessedImage(TensorImage inputImage) {
    int padSize = max(inputImage.height, inputImage.width);
    _imageProcessor ??= ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize, padSize))
        .add(ResizeOp(_inputSize, _inputSize, ResizeMethod.bilinear))
        .build();
    return _imageProcessor!.process(inputImage);
  }

  /// 对象检测函数
  bool predict(img.Image image, int id) {
    if (_interpreter == null) {
      return false;
    }
    // 从相机获得的转换后的图像,转化为 TensorImage 并进行预处理
    TensorImage inputImage = TensorImage.fromImage(image);
    inputImage = getProcessedImage(inputImage);
    List<double> l = inputImage.tensorBuffer
        .getDoubleList()
        .map((e) => e / 255.0)
        .toList(); // 量化输入流
    TensorBuffer normalizedTensorBuffer =
        TensorBuffer.createDynamic(TfLiteType.float32); // 转为浮点精度输入
    normalizedTensorBuffer.loadList(l, shape: [_inputSize, _inputSize, 3]);
    _interpreter!.run(normalizedTensorBuffer.buffer, _outputBuffer.buffer);
    List<double> results = _outputBuffer.getDoubleList(); //输出数据
    Set<int> ids = {};
    for (var i = 0; i < results.length; i += (5 + clsNum)) {
      // 置信度高则加入到所识别到的集合中
      double maxClsConf =
          results.sublist(i + 5, i + 5 + clsNum - 1).reduce(max);
      if (maxClsConf < clsConfTh) continue;
      int cls = results.sublist(i + 5, i + 5 + clsNum - 1).indexOf(maxClsConf) %
          clsNum; // 获取类别id
      ids.add(cls);
    }
    return ids.contains(id); // 判断手势集合中是否包含当前手势id
  }

  get interpreter => _interpreter;
}
