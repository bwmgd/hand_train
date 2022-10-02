import 'package:date_format/date_format.dart';

class TimeUtil {
  static int now(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int getStamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static String toBarDate(int stamp) {
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(stamp), [yy, '-', mm, '-', dd]);
  }

  static String toChineseDate(int stamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(stamp),
        [yy, '年', mm, '月', dd, "日"]);
  }

  static String toSecondColon(int millisecond) {
    int second = millisecond ~/ 1000;
    millisecond = millisecond % 1000 ~/ 10;
    return numToFormatStr(second) + ":" + numToFormatStr(millisecond);
  }

  static String toMinuteColon(int millisecond) {
    int minute = millisecond ~/ 60000;
    millisecond = millisecond % 60000;
    int second = millisecond ~/ 1000;
    millisecond = millisecond % 1000 ~/ 10;
    return numToFormatStr(minute) +
        ":" +
        numToFormatStr(second) +
        ":" +
        numToFormatStr(millisecond);
  }

  static String numToFormatStr(int num) {
    return num.toString().padLeft(2, '0');
  }
}
