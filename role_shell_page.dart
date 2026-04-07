import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'role_nav_controller.dart';
import 'blind_shell_page.dart';
import 'family_shell_page.dart';
import 'settingspage.dart';

class RoleShellPage extends StatelessWidget {
  RoleShellPage({super.key});

  final RoleNavController nav = Get.put(RoleNavController());

  final pages = [BlindShellPage(), FamilyShellPage(), SettingsPage()];

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
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility),
              label: "الكفيف",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.family_restroom),
              label: "العائلة",
            ),
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
