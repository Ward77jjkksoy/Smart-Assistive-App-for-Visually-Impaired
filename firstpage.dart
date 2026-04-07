import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:mashromz/main_shell_page.dart';
import 'package:mashromz/role_shell_page.dart';
// import 'home.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  // ignore: unused_field
  double _logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _logoOpacity = 1.0);

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _logoOpacity = 0.0);

        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          Get.offAll(() => RoleShellPage());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية (نفسها رح نحطها بصفحة تسجيل الدخول)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // const Color(0xFF333333).withOpacity(0.5),
                  // // const Color(0xFF21F5F9).withOpacity(0.4),
                  // const Color(0xFFE0E0E0).withOpacity(0.4),
                  Color.fromARGB(255, 92, 169, 146).withOpacity(0.75),
                  Color.fromARGB(255, 12, 51, 90).withOpacity(0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.3),

            // duration: const Duration(milliseconds: 800),
            child: Image.asset("images/mush.png", width: 360, height: 300),
          ),
        ],
      ),
    );
  }
}
