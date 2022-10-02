import 'package:flutter/material.dart';
import 'package:my_flutter_app/utils/screen_util.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLtl;
  final String title;
  final IconData? icon;
  final TextStyle? style;
  final void Function()? onPress;

  const MyAppBar(this.title,
      {Key? key, this.isLtl = true, this.icon, this.onPress, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var direction = isLtl ? TextDirection.ltr : TextDirection.rtl;
    Widget icon = this.icon == null
        ? const SizedBox.shrink()
        : IconButton(
            onPressed: onPress,
            icon: Icon(
              this.icon,
              textDirection: direction,
            ));
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5, //宽度
              color: Colors.grey, //边框颜色
            ),
          ),
        ),
        margin:
            EdgeInsets.only(top: ScreenUtil.statusBarHeight, left: 5, right: 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: direction,
          children: [
            Text(title,
                style: style ??
                    const TextStyle(
                      fontSize: 24,
                    )),
            icon
          ],
        ));
  }

  @override
  Size get preferredSize =>
      Size(ScreenUtil.screenWidth, ScreenUtil.screenHeight * 0.06);
}

abstract class AbstractAppBar extends StatefulWidget {
  const AbstractAppBar({Key? key}) : super(key: key);

  MyAppBar getBar();
}
