import 'package:flutter/material.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../../entity/gesture.dart';
import '../../utils/path_util.dart';

class GestureImage extends StatelessWidget {
  final int _gestureId;

  const GestureImage(this._gestureId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(PathUtil.getImagePath(
            GestureEntity.getGestureById(_gestureId).name))
        .setSize(48, 48);
  }
}
