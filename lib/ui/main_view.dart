import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/ui/page/history_page.dart';
import 'package:my_flutter_app/ui/page/home_page.dart';
import 'package:my_flutter_app/ui/page/train_page.dart';
import 'package:my_flutter_app/ui/widget/my_app_bar.dart';
import 'package:my_flutter_app/utils/screen_util.dart';
import 'package:my_flutter_app/utils/widget_util.dart';

import '../utils/static_store.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<AbstractAppBar> _pages = [
    const HomePage(),
    const HistoryPage(),
  ];
  final List<IconData> _icons = [Icons.home, Icons.person];
  final PageController _pageController = PageController(initialPage: 0);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenHigh = ScreenUtil.screenHeight;
    return Scaffold(
      appBar: _pages[_index].getBar(),
      body: PageView(
        allowImplicitScrolling: true,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        children: _pages,
      ),
      floatingActionButton: SizedBox(
        height: screenHigh * 0.08,
        width: screenHigh * 0.08,
        child: _buildFloatingActionButton(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(screenHigh),
    ).setBackground();
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        Storage().getGestureIds().then((value) async {
          if (value.isEmpty) {
            Toast.show("请添加手势!");
            return;
          }
          Get.to(TrainPage(value), transition: Transition.downToUp);
        });
      },
      child: const Icon(
        Icons.photo_camera,
      ),
    );
  }

  SizedBox _bottomBar(double screenHigh) {
    return SizedBox(
      height: screenHigh * 0.07,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 8.0,
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _tabBar(0)),
            Expanded(child: _tabBar(1)),
          ],
        ),
      ),
    );
  }

  Widget _tabBar(int position) {
    //构造返回的Widget
    return IconButton(
      onPressed: () {
        if (_index != position) {
          setState(() {
            _pageController.animateToPage(position,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 400));
            _index = position;
          });
        }
      },
      color: _index == position ? Colors.blue : Colors.grey,
      icon: Icon(_icons[position]),
    );
  }
}
