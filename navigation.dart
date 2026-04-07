import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_controller.dart';
import 'routes.dart';

class NavigationPage extends StatelessWidget {
  NavigationPage({super.key});

  final NavigationController nav = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "التوجيه الصوتي",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            nav.stopNavigation();
            Get.back();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.record_voice_over, size: 80),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  nav.startNavigation(universityRoute);
                },
                child: const Text("الجامعة"),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  nav.startNavigation(homeRoute);
                },
                child: const Text("المنزل"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => nav.stopNavigation(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("إيقاف التوجيه"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
