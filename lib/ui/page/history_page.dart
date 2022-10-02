import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/entity/history.dart';
import 'package:my_flutter_app/ui/page/info_page.dart';
import 'package:my_flutter_app/ui/page/setting_page.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/eventbus_util.dart';
import 'package:my_flutter_app/utils/static_store.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../../utils/time_util.dart';
import '../widget/gesture_image.dart';

class HistoryPage extends StatefulWidget implements AbstractAppBar {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryPageStata();

  @override
  MyAppBar getBar() {
    return MyAppBar("我的历史", icon: Icons.settings, onPress: onPress);
  }

  void onPress() {
    Get.to(const SettingPage(), transition: Transition.rightToLeft);
  }
}

class _HistoryPageStata extends State<HistoryPage> {
  late final StreamSubscription<HistoryEvent> _eventListener;
  List<HistoryEntity> _entityList = [];

  @override
  void initState() {
    super.initState();
    DataBase.historyDao.getAllHistory().then((value) {
      _entityList = value;
      setState(() {});
    });
    _eventListener = eventBus.on<HistoryEvent>().listen((event) {
      setState(() {
        if (event.history != null) {
          _entityList.add(event.history!);
        } else {
          _entityList.clear();
        }
      });
    });
  }

  @override
  void dispose() {
    _eventListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _entityList.isEmpty
        ? const Center(
            child: Text(
            "还没有记录，快去训练吧\n> A <",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ))
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _entityList.length,
            itemBuilder: (context, index) {
              return _listTile(_entityList[index], index);
            }).setMargin(10);
  }

  Widget _listTile(HistoryEntity _history, int index) {
    return ListTile(
      leading: GestureImage(_history.gestureId).setRadius(13),
      title: Text(TimeUtil.toBarDate(_history.date)),
      subtitle: Text(TimeUtil.toMinuteColon(_history.totalTime)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        Get.to(InfoPage(_history.id!), transition: Transition.rightToLeft);
      },
      onLongPress: () {
        setState(() {
          _entityList.removeAt(index);
        });
        DataBase.deleteAllInfoById(_history);
      },
    ).setCard(13);
  }
}
