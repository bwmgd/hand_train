import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';

import '../entity/classifier.dart';
import 'image_util.dart';

/**
 * isolate可以理解为是概念上Thread线程，
 * 但是它和Thread线程唯一不一样的就是「多个isolate之间彼此隔离且不共享内存空间，
 * 每个isolate都有自己独立内存空间，从而避免了锁竞争」。
 */

/// 并发(使用[Isolate])进行推理
class IsolateUtil {
  final ReceivePort _receivePort = ReceivePort(); //接收信息的端口
  late SendPort _sendPort; //发送信息的端口

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort); //发送消息
    _sendPort = await _receivePort.first; //接收消息
  }

  /// 接入函数
  static void entryPoint(SendPort sendPort) async {
    //通过发送接收端口的"发送端口号"来串起来"线程"
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    //"多线程"分析
    await for (final IsolateData? isolateData in port) {
      if (isolateData != null) {
        //获取识别的结果
        bool results = Classifier(
                interpreter:
                    Interpreter.fromAddress(isolateData.interpreterAddress))
            .predict(ImageUtils.convertCameraImage(isolateData.cameraImage),
                isolateData.id);

        //发送结果
        isolateData.responsePort.send(results);
      }
    }
  }
}

/// 绑定数据以在[Isolate]中传递
class IsolateData {
  late CameraImage cameraImage;
  late int interpreterAddress;
  late SendPort responsePort;
  late int id;

  IsolateData(this.cameraImage, this.interpreterAddress, this.id);
}
