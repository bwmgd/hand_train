import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/eventbus_util.dart';
import 'package:my_flutter_app/utils/path_util.dart';
import 'package:my_flutter_app/utils/static_store.dart';
import 'package:my_flutter_app/utils/theme_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../../utils/screen_util.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = ScreenUtil.screenWidth * 0.7;
    var height = ScreenUtil.screenHeight;
    return Scaffold(
      appBar: MyAppBar("设置", isLtl: false, icon: Icons.home, onPress: () {
        Get.back();
      }),
      body: Column(
        children: [
          Image.asset(PathUtil.getImagePath("logo")).setSize(width, width),
          Text("让生活更简单\n手部锻炼\nv" + Store.appVersion,
                  textAlign: TextAlign.center)
              .setMarginLTRB(top: height * 0.04, bottom: height * 0.04),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text("深色模式"),
                  DayNightSwitcher(
                    isDarkModeEnabled: Get.isDarkMode,
                    onStateChanged: (isDarkModeEnabled) {
                      Get.changeTheme(isDarkModeEnabled
                          ? MyThemeData.darkTheme
                          : MyThemeData.lightTheme);
                    },
                  ).setSize(width * 0.3, height * 0.06),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Row(
                children: [const Text("版本号"), Text(Store.appVersion + " ")],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )
            ],
          )
              .setPaddingLTRB(left: 16, right: 16, top: 6, bottom: 16)
              .setCard(14, elevation: 15)
              .setMarginLTRB(left: 16, right: 16),
          const SizedBox.shrink().setExpand(),
          MaterialButton(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.red,
            onPressed: () {
              DataBase.clear().then((value) {
                Toast.show("历史已清空");
                eventBus.fire(HistoryEvent(null));
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("清空历史记录", style: TextStyle(fontSize: 18)),
                Icon(Icons.delete_outline)
              ],
            ),
          ).setMarginLTRB(left: 16, right: 16, top: 10, bottom: 30),
        ],
      ).setMarginLTRB(top: height * 0.03).setCenter(),
    ).setBackground();
  }
}
