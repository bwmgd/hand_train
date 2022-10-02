import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/ui/page/train_page.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/path_util.dart';
import 'package:my_flutter_app/utils/time_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../../entity/history.dart';
import '../../utils/eventbus_util.dart';
import '../../utils/screen_util.dart';
import '../../utils/static_store.dart';
import 'info_page.dart';

class CompletePage extends StatefulWidget {
  final HistoryEntity _history;
  final int _totalTime;

  const CompletePage(this._history, this._totalTime, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CompletePageStata();
}

class CompletePageStata extends State<CompletePage> {
  List<int> _gestureIds = []; //空杯用于再来一组

  @override
  void initState() {
    super.initState();
    Storage().getGestureIds().then((value) {
      _gestureIds = value;
      eventBus.fire(ChoseEvent([])); //通知首页手势选择清空
      Storage().setGestureIds([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = ScreenUtil.screenWidth * 0.9;
    var height = ScreenUtil.screenHeight;
    return Scaffold(
      appBar: MyAppBar(TimeUtil.toChineseDate(widget._history.date),
          isLtl: false, icon: Icons.home, onPress: () {
        Get.back();
      }),
      body: Column(
        children: [
          const Text(
            "训练完成",
            style: TextStyle(fontSize: 28),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(TimeUtil.toMinuteColon(widget._totalTime),
                  style: const TextStyle(color: Colors.green, fontSize: 22)),
              const Text("/", style: TextStyle(fontSize: 22)),
              Text(TimeUtil.toMinuteColon(widget._history.totalTime),
                  style: const TextStyle(fontSize: 22))
            ],
          ).setMarginLTRB(top: height * 0.01, bottom: height * 0.05),
          Image.asset(PathUtil.getImagePath("complete")).setSize(width, width),
          const SizedBox.shrink().setExpand(),
          MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Text("查看记录", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Get.off(InfoPage(widget._history.id!),
                        transition: Transition.rightToLeft);
                  })
              .setSize(width * 0.5, height * 0.065)
              .setMarginLTRB(bottom: height * 0.04),
          MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Text("再来一组", style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    eventBus.fire(ChoseEvent(_gestureIds)); //通知首页手势选择添加
                    Storage().setGestureIds(_gestureIds);
                    Get.off(TrainPage(_gestureIds),
                        transition: Transition.downToUp);
                  })
              .setSize(width * 0.5, height * 0.065)
              .setMarginLTRB(bottom: height * 0.1),
        ],
      ).setMarginLTRB(top: height * 0.03).setCenter(),
    ).setBackground();
  }
}
