import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/get_navigation.dart';
// import 'statepage.dart';

// صفحات فرعية لكل بند
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        iconTheme: IconThemeData(
          color: Colors.black, // هذا يغير لون السهم
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 92, 169, 146).withOpacity(0.85),
              const Color.fromARGB(255, 12, 51, 90).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Username"),
                subtitle: const Text("John Doe"),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: const Text("john.doe@example.com"),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
                onTap: () {
                  // هنا تضع صفحة تغيير كلمة المرور
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushNotifications = true;
  bool emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",

          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        iconTheme: IconThemeData(
          color: Colors.black, // هذا يغير لون السهم
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 92, 169, 146).withOpacity(0.85),
              const Color.fromARGB(255, 12, 51, 90).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Push Notifications"),
                value: pushNotifications,
                onChanged: (val) => setState(() => pushNotifications = val),
              ),
              SwitchListTile(
                title: const Text("Email Notifications"),
                value: emailNotifications,
                onChanged: (val) => setState(() => emailNotifications = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        iconTheme: IconThemeData(
          color: Colors.black, // هذا يغير لون السهم
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 92, 169, 146).withOpacity(0.85),
              const Color.fromARGB(255, 12, 51, 90).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text("Light Theme"),
                onTap: () {
                  Get.changeThemeMode(
                    ThemeMode.light,
                  ); // هنا تغيير الثيم للفاتح
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Theme"),
                onTap: () {
                  Get.changeThemeMode(ThemeMode.dark); // هنا تغيير الثيم للداكن
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text("Custom Theme"),
                onTap: () {
                  Get.changeThemeMode(
                    ThemeMode.system,
                  ); // اتباع إعدادات النظام // صفحة اختيار ألوان مخصصة
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        iconTheme: IconThemeData(
          color: Colors.black, // هذا يغير لون السهم
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 92, 169, 146).withOpacity(0.85),
              const Color.fromARGB(255, 12, 51, 90).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Blind stick  App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Version: 1.0.0", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("Developed by:Mushroms", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(
                "Description: Blind stick  is a Blind stick  app that tracks your steps, "
                "connects to your smart Blind stick , and helps you monitor your activity.",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  int activeIndex = 3;
  // زر شريط التنقل
  Widget navItem(
    IconData icon,
    String label,
    int index,
    Widget Function()? targetPageBuilder,
  ) {
    bool active = (activeIndex == index);
    return InkWell(
      onTap: () {
        setState(() {
          activeIndex = index;
        });
        if (targetPageBuilder != null) {
          Get.to(targetPageBuilder()); // ← الانتقال باستخدام GetX
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.teal : Colors.black87),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.teal : Colors.black87,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        iconTheme: IconThemeData(
          color: Colors.black, // هذا يغير لون السهم
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 92, 169, 146).withOpacity(0.85),
              const Color.fromARGB(255, 12, 51, 90).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Account"),
              subtitle: const Text("Manage your account settings"),
              onTap: () => Get.to(() => const AccountPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              subtitle: const Text("Manage notification preferences"),
              onTap: () => Get.to(() => const NotificationsPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("Theme"),
              subtitle: const Text("Change app theme"),
              onTap: () => Get.to(() => const ThemePage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              subtitle: const Text("App information"),
              onTap: () => Get.to(() => const AboutPage()),
            ),
          ],
        ),
      ),
    );
  }
}
