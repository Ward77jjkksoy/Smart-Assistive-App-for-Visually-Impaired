import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_nav_controller.dart';
import 'home.dart';
import 'history_page.dart';
import 'map_page.dart'; // سننشئها
// import 'settingspage.dart';

class FamilyShellPage extends StatelessWidget {
  FamilyShellPage({super.key});

  final MainNavController nav = Get.put(MainNavController(), tag: "family");

  final pages = [
    DashboardPage(),
    HistoryPage(),
    BlindLiveMapPage(), // ← لازم تكون هون
    // SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[nav.index.value],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.index.value,
          onTap: nav.changeTab,

          backgroundColor: const Color.fromARGB(255, 12, 51, 90),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "السجل"),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "الموقع",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings),
            //   label: "الإعدادات",
            // ),
          ],
        ),
      ),
    );
  }
}
