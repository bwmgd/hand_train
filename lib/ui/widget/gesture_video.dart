import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/utils/path_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';
import 'package:video_player/video_player.dart';

import '../../utils/screen_util.dart';

class GestureVideo extends StatefulWidget {
  final String _name;
  final GestureVideoCallBack? callBack;

  const GestureVideo(this._name, {Key? key, this.callBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends State<GestureVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset(PathUtil.getVideoPath(widget._name))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });
    _controller.setLooping(true);
    _controller.setVolume(0);
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller)
        .setSize(ScreenUtil.screenWidth * 0.7, ScreenUtil.screenWidth * 0.7)
        .setRadius(13);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

typedef GestureVideoCallBack = void Function(bool start);
