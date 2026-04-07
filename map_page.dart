import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'espcontroller.dart';

class BlindLiveMapPage extends StatelessWidget {
  BlindLiveMapPage({super.key});

  final EspController esp = Get.find<EspController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "موقع الكفيف الآن",
          style: TextStyle(color: Colors.black),
        ),
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
        child: Center(
          child: Obx(() {
            if (!esp.hasFix.value) {
              return const Text(
                "📡 لا يوجد إشارة GPS حالياً",
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 80, color: Colors.red),
                const SizedBox(height: 20),
                Text("Lat: ${esp.lat.value}"),
                Text("Lng: ${esp.lng.value}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => esp.openMapToStick(),
                  child: const Text("فتح في Google Maps"),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
