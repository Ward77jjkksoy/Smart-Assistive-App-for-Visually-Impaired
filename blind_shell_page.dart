import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_nav_controller.dart';
import 'home.dart';
import 'navigation.dart';

class BlindShellPage extends StatelessWidget {
  BlindShellPage({super.key});

  final MainNavController nav = Get.put(MainNavController(), tag: "blind");

  final pages = [DashboardPage(), NavigationPage()];

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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              label: "التوجيه",
            ),
          ],
        ),
      ),
    );
  }
}
