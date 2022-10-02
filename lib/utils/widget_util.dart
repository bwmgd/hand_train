import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_flutter_app/utils/path_util.dart';

extension WidgetExtension on Widget {
  Widget setSize(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget setMargin(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }

  Widget setMarginLTRB(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  Widget setPadding(double padding) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget setPaddingLTRB(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Container(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  Widget setRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  Widget setCard(double radius, {double elevation = 0, Color? color}) {
    return Card(
      // color: color,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      elevation: elevation,
      child: this,
    );
  }

  Widget setExpand() {
    return Expanded(child: this);
  }

  Widget setInkWell(void Function() f) {
    return InkWell(child: this, onTap: f);
  }

  Widget setBackground() {
    return Container(
        child: this,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PathUtil.backgroundFileName),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget setCenter() {
    return Center(child: this);
  }

  Widget setCircle() {
    return ClipOval(child: this);
  }
}

class Toast {
  static void show(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black54.withOpacity(0.7));
  }
}
