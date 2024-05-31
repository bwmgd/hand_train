import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_flutter_app/ui/main_view.dart';
import 'package:my_flutter_app/utils/path_util.dart';
import 'package:my_flutter_app/utils/static_store.dart';
import 'package:my_flutter_app/utils/theme_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding); // 闪屏页
  Storage(); // SharedPreferences构建实例
  // 等待数据库加载完成加载页面
  await DataBase.init().then((value) => binding.deferFirstFrame());
  binding.addPostFrameCallback((_) async {
    final BuildContext? context = binding.rootElement;
    PackageInfo.fromPlatform() // 软件版本号
        .then((value) => Store.appVersion = value.version);
    availableCameras().then((value) => Store.cameraList = value); // 可用相机列表
    if (context != null) {
      // 预加载背景图
      precacheImage(const AssetImage(PathUtil.backgroundFileName), context);
    }
    binding.allowFirstFrame(); //开始界面加载
    FlutterNativeSplash.remove(); // 关闭闪屏页
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '手部训练app',
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      home: const MainView(),
    );
  }
}
