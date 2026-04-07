import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'models/waypoint.dart';
import 'espcontroller.dart';

class NavigationController extends GetxController {
  final EspController esp = Get.find();
  final FlutterTts tts = FlutterTts();

  final RxInt currentIndex = 0.obs;
  final RxBool navigating = false.obs;
  bool ttsReady = false;

  Timer? timer;
  List<WayPoint> route = [];

  @override
  void onInit() async {
    super.onInit();

    await tts.awaitSpeakCompletion(true);

    await tts.setLanguage("ar-SA");
    await tts.setSpeechRate(0.45);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);

    ttsReady = true;

    print("✅ TTS READY");
  }

  // ===== بدء التوجيه =====
  void startNavigation(List<WayPoint> newRoute) {
    route = newRoute;
    currentIndex.value = 0;
    navigating.value = true;

    speak("ابدأ المشي، سأقوم بإرشادك");

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _checkPosition();
    });
  }

  // ===== إيقاف =====
  void stopNavigation() {
    navigating.value = false;
    timer?.cancel();
    speak("تم إيقاف التوجيه");
  }

  // ===== فحص الموقع =====
  void _checkPosition() {
    if (!navigating.value) return;
    if (!esp.hasFix.value) return;
    if (currentIndex.value >= route.length) {
      speak("وصلت إلى وجهتك");
      stopNavigation();
      return;
    }

    final wp = route[currentIndex.value];

    final distance = _distanceInMeters(
      esp.lat.value,
      esp.lng.value,
      wp.lat,
      wp.lng,
    );

    if (distance < 8) {
      speak(wp.instruction);
      currentIndex.value++;
    }
  }

  // ===== تحويل لنطق =====
  Future<void> speak(String text) async {
    if (!ttsReady) {
      print("⚠️ TTS NOT READY YET");
      return;
    }

    print("🔊 Speaking: $text");

    await tts.stop();
    await tts.speak(text);
  }

  // ===== حساب المسافة =====
  double _distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
