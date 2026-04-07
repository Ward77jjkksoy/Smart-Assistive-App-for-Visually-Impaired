import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mashromz/history_page.dart';
import 'main_nav_controller.dart';

import 'home.dart';
import 'settingspage.dart';
import 'navigation.dart';

class MainShellPage extends StatelessWidget {
  MainShellPage({super.key});

  final MainNavController nav = Get.put(MainNavController());

  final pages = [
    DashboardPage(),
    NavigationPage(),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // appBar: AppBar(title: const Text("العصاية الذكية")),
        body: pages[nav.index.value],
        backgroundColor: const Color.fromARGB(
          255,
          12,
          51,
          90,
        ).withOpacity(0.85),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.index.value,
          onTap: nav.changeTab,
          backgroundColor: const Color.fromARGB(
            255,
            12,
            51,
            90,
          ).withOpacity(0.85),
          selectedItemColor: Colors.cyan, // لون العنصر المختار
          unselectedItemColor: Colors.white70, // لون الباقي
          type: BottomNavigationBarType.fixed, // مهم حتى يطبق اللون
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              label: "التوجيه",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "السجل"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "الإعدادات",
            ),
          ],
        ),
      ),
    );
  }
}
