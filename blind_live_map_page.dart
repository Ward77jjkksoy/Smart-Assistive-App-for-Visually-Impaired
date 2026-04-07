import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
      body: Obx(() {
        // إذا ما في GPS
        if (!esp.hasFix.value || esp.lat.value == 0 || esp.lng.value == 0) {
          return const Center(
            child: Text(
              "📡 لا يوجد إشارة GPS حالياً",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        // إذا في GPS
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(esp.lat.value, esp.lng.value),
            initialZoom: 17,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(esp.lat.value, esp.lng.value),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
