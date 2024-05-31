import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/entity/gesture.dart';
import 'package:my_flutter_app/entity/history.dart';
import 'package:my_flutter_app/entity/rating.dart';
import 'package:my_flutter_app/ui/page/complete_page.dart';
import 'package:my_flutter_app/ui/widget/gesture_image.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/eventbus_util.dart';
import 'package:my_flutter_app/utils/screen_util.dart';
import 'package:my_flutter_app/utils/static_store.dart';
import 'package:my_flutter_app/utils/time_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../entity/classifier.dart';
import '../../utils/isolate_util.dart';

class TrainPage extends StatefulWidget {
  final List<int> _gestures;

  const TrainPage(this._gestures, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrainState();
}

class _TrainState extends State<TrainPage> with WidgetsBindingObserver {
  late CameraController _controller;
  late Classifier _classifier;
  late IsolateUtil _isolateUtil;
  late HistoryEntity _history;

  final List<InfoEntity> _infoList = [];
  final StopWatchTimer _useTimer = StopWatchTimer();
  final StopWatchTimer _trainTimer = StopWatchTimer();

  int _sumTrainTime = 0;
  int _sumTotalTime = 0;
  int _index = 0;
  bool predicting = false;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    _init().then((value) => _start());
  }

  /// 初始化
  Future<void> _init() async {
    _classifier = Classifier(); //分类器
    _isolateUtil = IsolateUtil(); //线程工具类
    await _isolateUtil.start();
  }

  @override
  void dispose() {
    _useTimer.dispose();
    _trainTimer.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///开始推理
  void _start() {
    _controller =
        CameraController(Store.cameraList[0], ResolutionPreset.medium);
    _controller.initialize().then((v) {
      if (!mounted) {
        return;
      }
      _controller
          .startImageStream(_onLatestImageAvailable)
          .then((value) => setState(() {
                _isStart = true;
                _useTimer.onStartTimer();
              }));
    });
  }

  ///停止推理
  void _stop() {
    setState(() {
      _isStart = false;
      _useTimer.onStopTimer();
      _trainTimer.onStopTimer();
    });
    _controller.dispose();
  }

  ///生命周期监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        _stop();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    GestureEntity gesture =
        GestureEntity.getGestureById(widget._gestures[_index]);
    var width = ScreenUtil.screenWidth * 0.9;
    var height = ScreenUtil.screenHeight;

    return Scaffold(
      appBar: MyAppBar("训练",
          isLtl: false, icon: Icons.home, onPress: () => _onBack(context)),
      body: Column(
        children: [
          Text(
            gesture.nameStr,
            style: const TextStyle(fontSize: 28),
          ),
          _timerView(height),
          Stack(children: [
            _camera().setSize(width, width).setCircle(),
            _gestureImage(width, gesture),
          ]).setExpand(),
          _opView(context, height),
        ],
      ).setMarginLTRB(top: height * 0.03).setCenter(),
    ).setBackground();
  }

  ///操作按钮区
  Widget _opView(BuildContext context, double height) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      IconButton(
          iconSize: 48,
          onPressed: () => _onBack(context),
          icon: const Icon(Icons.stop)),
      IconButton(
          iconSize: 48,
          onPressed: () {
            if (_isStart) {
              _stop();
            } else {
              _start();
            }
          },
          icon: _isStart
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow)),
      IconButton(
          iconSize: 48,
          onPressed: () {
            _next(context);
          },
          icon: const Icon(Icons.skip_next))
    ]).setMarginLTRB(bottom: height * 0.07);
  }

  void _onBack(BuildContext context) {
    _stop();
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return _alertDialog(context, _);
        });
  }

  CupertinoAlertDialog _alertDialog(BuildContext context, BuildContext _) {
    return CupertinoAlertDialog(
      title: const Text('是否退出'),
      content: const Text('退出训练将不会保留训练记录'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();
              Navigator.pop(_);
            },
            child: const Text(
              "退出",
              style: TextStyle(fontSize: 16, color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(_);
              _start();
            },
            child: const Text(
              "继续",
              style: TextStyle(fontSize: 16),
            )),
      ],
    );
  }

  ///下一个手势
  void _next(BuildContext context) {
    var totalTime = _useTimer.rawTime.value;
    var trainTime = _trainTimer.rawTime.value;
    var gestureId = widget._gestures[_index];
    _sumTotalTime += totalTime;
    _sumTrainTime += trainTime;
    InfoEntity info = InfoEntity(null, 0, gestureId, totalTime, trainTime,
        RatingEntity.getRatingIdByTime(trainTime, totalTime));
    _infoList.add(info);
    if (_index < widget._gestures.length - 1) {
      _useTimer.onResetTimer();
      _trainTimer.onResetTimer();
      setState(() {
        _index++;
        _useTimer.onStartTimer();
      });
    } else {
      //训练完成去完成页
      _stop();
      _history = HistoryEntity(null, TimeUtil.now(), _sumTotalTime, gestureId);
      DataBase.historyDao.insertHistory(_history).then((value) {
        _history.id = value;
        for (var element in _infoList) {
          element.historyId = value;
        }
        DataBase.infoDao.insertInfo(_infoList).then((value) {
          eventBus.fire(HistoryEvent(_history)); //通知历史界面添加历史
          Get.off(CompletePage(_history, _sumTrainTime),
              transition: Transition.rightToLeft);
        });
      });
    }
  }

  ///手势图片
  Container _gestureImage(double width, GestureEntity gesture) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.3),
        boxShadow: const [
          BoxShadow(
              blurRadius: 8, color: Color(0xffFFB1B1), offset: Offset(4, 4)),
          BoxShadow(
              blurRadius: 8, color: Color(0xff95BBFF), offset: Offset(-4, -4))
        ],
      ),
      child: GestureImage(gesture.id)
          .setSize(width * 0.3, width * 0.3)
          .setCircle(),
    );
  }

  ///时间显示界面
  Widget _timerView(double height) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      StreamBuilder<int>(
        stream: _trainTimer.rawTime,
        builder: (context, snap) {
          final value = snap.data ?? 0;
          final displayTime =
              StopWatchTimer.getDisplayTime(value, hours: false, minute: false);
          return Text(displayTime,
              style: const TextStyle(color: Colors.green, fontSize: 22));
        },
      ),
      const Text("/", style: TextStyle(fontSize: 22)),
      StreamBuilder<int>(
        stream: _useTimer.rawTime,
        builder: (context, snap) {
          final value = snap.data ?? 0;
          final displayTime =
              StopWatchTimer.getDisplayTime(value, hours: false, minute: false);
          return Text(displayTime, style: const TextStyle(fontSize: 22));
        },
      ),
    ]).setMarginLTRB(top: height * 0.01, bottom: height * 0.05);
  }

  ///相机界面
  Widget _camera() {
    if (!_isStart || !_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller));
  }

  /// 接收每一帧 [CameraImage] 对其进行推理
  void _onLatestImageAvailable(CameraImage cameraImage) async {
    if (_classifier.interpreter == null || !_isStart || predicting) {
      return;
    }
    predicting = true; //开始推理
    IsolateData isolateData = IsolateData(
        cameraImage, _classifier.interpreter.address, widget._gestures[_index]);
    ReceivePort responsePort = ReceivePort(); //换线程继续推理
    _isolateUtil.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    //如果推理出来的标签是当前的id,则推理成功开始计时
    bool inference = await responsePort.first;
    if (inference && _isStart) {
      _trainTimer.onStartTimer();
    } else {
      _trainTimer.onStopTimer();
    }
    predicting = false; //推理完成
  }
}
