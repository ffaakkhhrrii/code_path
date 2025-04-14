import 'package:code_path/core/config/app_asset.dart';
import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/features/presentation/page/home/c_home.dart';
import 'package:code_path/features/presentation/page/menu/home_menu.dart';
import 'package:code_path/features/presentation/page/menu/news_menu.dart';
import 'package:code_path/features/presentation/page/menu/path_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<Map> listNav = [
    {'icon': AppAsset.iconHome, 'label': 'Home'},
    {'icon': AppAsset.iconPath, 'label': 'Roles'},
    {'icon': AppAsset.iconNews, 'label': 'News'},
  ];

  final cHome = Get.put(CHome());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (cHome.indexPage == 0) {
          return const HomeMenu();
        } else if (cHome.indexPage == 1) {
          return PathMenu();
        }else{
          return NewsMenu();
        }
      }),
      bottomNavigationBar: Obx(
        () {
          return Material(
            elevation:
                0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: BottomNavigationBar(
                  currentIndex: cHome.indexPage,
                  onTap: (value) {
                    cHome.indexPage = value;
                  },
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.black,
                  selectedIconTheme:
                      const IconThemeData(color: AppColor.secondary),
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  selectedFontSize: 12,
                  items: listNav.map((e) {
                    return BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage(e['icon'])),
                      label: e['label'],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
