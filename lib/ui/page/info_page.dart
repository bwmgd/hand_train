import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/entity/gesture.dart';
import 'package:my_flutter_app/ui/page/train_page.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../../entity/history.dart';
import '../../utils/eventbus_util.dart';
import '../../utils/static_store.dart';
import '../../utils/time_util.dart';
import '../widget/gesture_image.dart';
import '../widget/rating_image.dart';

class InfoPage extends StatefulWidget {
  final int _historyId;

  const InfoPage(this._historyId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoPageStata();
}

class _InfoPageStata extends State<InfoPage> {
  List<InfoEntity> _entityList = [];
  int stamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    DataBase.infoDao
        .getAllInfoById(widget._historyId)
        .then((value) => setState(() {
              _entityList = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        TimeUtil.toChineseDate(stamp),
        icon: Icons.logout,
        isLtl: false,
        onPress: () {
          Get.back();
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InfoItem(_entityList[index]);
              },
              childCount: _entityList.length,
            ),
          ),
          SliverToBoxAdapter(
            child: MaterialButton(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.green,
              onPressed: () {
                List<int> gestureIds =
                    _entityList.map((e) => e.gestureId).toList();
                Storage().setGestureIds(gestureIds);
                eventBus.fire(ChoseEvent(gestureIds));
                Get.off(TrainPage(gestureIds), transition: Transition.downToUp);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("再来一组", style: TextStyle(fontSize: 18)),
                  Icon(Icons.refresh)
                ],
              ),
            ).setMarginLTRB(left: 4, right: 4, top: 10, bottom: 10),
          )
        ],
      ).setMargin(10),
    ).setBackground();
  }
}

class InfoItem extends StatelessWidget {
  final InfoEntity _infoEntity;

  const InfoItem(this._infoEntity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureImage(_infoEntity.gestureId).setRadius(13),
      title: Text(GestureEntity.getGestureById(_infoEntity.gestureId).nameStr),
      subtitle: Row(
        children: [
          Text(TimeUtil.toSecondColon(_infoEntity.trainTime),
              style: const TextStyle(color: Colors.green)),
          const Text("/"),
          Text(TimeUtil.toSecondColon(_infoEntity.totalTime)),
        ],
      ),
      trailing: RatingImage(_infoEntity.ratingId),
    ).setCard(14);
  }
}
