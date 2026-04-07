import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'espcontroller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final EspController esp = Get.find<EspController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الأحداث", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
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
        child: Obx(() {
          if (esp.history.isEmpty) {
            return const Center(child: Text("لا يوجد أحداث بعد"));
          }

          return ListView.separated(
            itemCount: esp.history.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = esp.history[index];

              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(item),
              );
            },
          );
        }),
      ),
    );
  }
}
