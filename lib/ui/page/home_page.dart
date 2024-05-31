import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/gesture_video.dart';
import 'package:my_flutter_app/utils/eventbus_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';
import 'package:reorderables/reorderables.dart';

import '../../entity/gesture.dart';
import '../../utils/static_store.dart';
import '../widget/gesture_image.dart';
import '../widget/my_app_bar.dart';

class HomePage extends StatefulWidget implements AbstractAppBar {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageStata();

  @override
  MyAppBar getBar() {
    return const MyAppBar("手势列表");
  }
}

class _HomePageStata extends State<HomePage> {
  late final StreamSubscription<ChoseEvent> eventListener;
  List<int> _gestureIds = [];
  bool _isRemove = false;

  @override
  void initState() {
    super.initState();
    Storage().getGestureIds().then((value) {
      setState(() {
        _gestureIds = value;
      });
    });
    eventListener = eventBus.on<ChoseEvent>().listen((event) {
      setState(() {
        _gestureIds = event.choseIds;
      });
    });
  }

  @override
  void dispose() {
    eventListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _choseGridView()
            .setCard(13, elevation: 4)
            .setMarginLTRB(top: 12, left: 12, right: 12, bottom: 12),
        _gestureListView().setMarginLTRB(left: 12, right: 12).setExpand()
      ],
    ).setPaddingLTRB(bottom: 35);
  }

  void _addGesture(int id) {
    if (_gestureIds.length >= 20) {
      Toast.show("最多添加20个手势");
      return;
    }
    setState(() {
      _gestureIds.add(id);
    });
    Storage().setGestureIds(_gestureIds);
  }

  void _removeGesture(int index) {
    setState(() {
      _gestureIds.removeAt(index);
    });
    Storage().setGestureIds(_gestureIds);
  }

  void _swapGesture(int oldIndex, int newIndex) {
    if (_isRemove) {
      return;
    }
    setState(() {
      _gestureIds.insert(newIndex, _gestureIds.removeAt(oldIndex));
    });
    Storage().setGestureIds(_gestureIds);
  }

  void _clearGesture() {
    setState(() {
      _gestureIds.clear();
    });
    Storage().setGestureIds(_gestureIds);
  }

  Widget _choseGridView() {
    return _gestureIds.isEmpty
        ? const Text("点击手势卡片右上角+号以添加手势,长按已选手势拖动以排序或删除,最多添加20个").setPadding(12)
        : badges.Badge(
            position: badges.BadgePosition.topEnd(top: -16, end: -16),
            badgeContent: DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                return InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    onTap: _clearGesture,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(spreadRadius: 16, color: Color(0xCCFEE0E0)),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ));
              },
              onWillAcceptWithDetails: (index) {
                return true;
              },
              onAcceptWithDetails: (index) {
                _isRemove = true;
                setState(() {
                  _removeGesture(index.data);
                });
              },
            ).setPadding(5),
            child: ReorderableWrap(
              padding: const EdgeInsets.all(12),
              runSpacing: 8,
              spacing: 8,
              ignorePrimaryScrollController: true,
              onReorder: _swapGesture,
              onReorderStarted: (index) {
                _isRemove = false;
              },
              children: List.generate(_gestureIds.length, (index) {
                return GestureImage(_gestureIds[index]);
              }),
            ));
  }

  Widget _gestureListView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: GestureEntity.gestureList.length,
      itemBuilder: ((context, index) {
        GestureEntity gesture = GestureEntity.gestureList[index];
        return badges.Badge(
          badgeContent: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onTap: () => _addGesture(gesture.id),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.green,
            elevation: 5,
          ),
          child: ExpansionTileCard(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            contentPadding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            title: Text(gesture.nameStr),
            leading: GestureImage(gesture.id).setRadius(13),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(gesture.description, textAlign: TextAlign.center)
                      .setMarginLTRB(bottom: 15),
                  GestureVideo(gesture.name)
                ],
              ).setMarginLTRB(left: 15, right: 15, bottom: 35),
            ],
          ),
        ).setMarginLTRB(left: 10, right: 10, top: 8);
      }),
    );
  }
}
