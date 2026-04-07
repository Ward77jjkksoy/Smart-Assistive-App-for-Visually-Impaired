import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'espcontroller.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final EspController esp = Get.find<EspController>();

  Widget _gridItem(Widget child) {
    return SizedBox(
      width: (Get.width - 48) / 2, // نص الشاشة مع الهوامش
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "العصاية الذكية",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          92,
          169,
          146,
        ).withOpacity(0.85),
      ),
      bottomNavigationBar: _buildBottomBar(esp),
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
        child: RefreshIndicator(
          onRefresh: esp.fetchStatus,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== STATUS BAR =====
                Obx(() => _buildStatusBar()),

                const SizedBox(height: 20),

                // ===== INFO CARDS =====
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: double.infinity, // بعرض الشاشة
                            child: _locationCard(),
                          ),
                        ),

                        Obx(
                          () => _gridItem(
                            _infoCard(
                              "البطارية",
                              "${esp.battery.value}%",
                              Icons.battery_full,
                            ),
                          ),
                        ),

                        Obx(
                          () => _gridItem(
                            _infoCard(
                              "آخر حدث",
                              esp.lastEvent.value,
                              Icons.warning,
                            ),
                          ),
                        ),

                        // 🤖 AI بعرض الشاشة
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: _infoCard(
                              "🤖 AI",
                              esp.aiDecision.value,
                              Icons.psychology,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== BUTTONS =====
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.location_on, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          const Text(
            "الموقع الحالي",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("Lat", style: TextStyle(color: Colors.white70)),
                  Text(
                    esp.lat.value.toStringAsFixed(6),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Lng", style: TextStyle(color: Colors.white70)),
                  Text(
                    esp.lng.value.toStringAsFixed(6),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statusItem(Icons.wifi, esp.wifi.value ? "متصل" : "غير متصل"),
          _statusItem(Icons.gps_fixed, esp.gps.value ? "GPS" : "غير متاح"),
          _statusItem(Icons.warning, esp.lastEvent.value),
        ],
      ),
    );
  }

  Widget _statusItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBottomBar(EspController esp) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 12, 51, 90),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          // 🔄 تحديث
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => esp.fetchStatus(),
              icon: const Icon(Icons.refresh),
              label: const Text("تحديث"),
            ),
          ),

          const SizedBox(width: 10),

          // 🆘 SOS
          Expanded(
            child: Semantics(
              label: "زر استغاثة، اضغط مرتين للإرسال",
              child: ElevatedButton.icon(
                onPressed: () => esp.handleSOSFromApp(),
                icon: const Icon(Icons.sos, size: 28),
                label: const Text("SOS"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
