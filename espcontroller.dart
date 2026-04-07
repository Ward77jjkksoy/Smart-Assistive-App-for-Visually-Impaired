import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'area_ai.dart';
import 'tts_service.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'history_page.dart';

class EspController extends GetxController {
  final String espUrl = "http://esp32.local";

  // ===== Observable values =====
  var wifi = false.obs;
  var gps = false.obs;
  var battery = 0.obs;
  // ===== History =====
  final RxList<String> history = <String>[].obs;
  var lastEvent = "NONE".obs;
  var lastEventAge = 0.obs;

  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var mapUrl = "".obs;

  var aiDecision = "—".obs;
  final RxBool hasFix = false.obs;
  Timer? _statusTimer;
  Timer? _eventTimer;

  // لمنع تكرار نفس التحذير بسرعة
  String _lastSpokenEvent = "";

  // قفل بسيط لمنع تداخل نطقين
  bool _speaking = false;

  // استخدم خدمة الصوت (بدل FlutterTts داخل الكونترولر)
  final TtsService tts = Get.find<TtsService>();

  @override
  void onInit() {
    super.onInit();

    AreaAI.load();

    // أول تحديث
    fetchStatus();
    fetchEvent();
    // handleSOSFromApp();

    _statusTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      fetchStatus();
    });

    _eventTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchEvent();
    });
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    _eventTimer?.cancel();
    super.onClose();
  }

  Future<void> requestLiveLocationFromFamily() async {
    Get.snackbar("📡", "جارٍ طلب الموقع من العصاية...");

    await fetchStatus(); // يطلب آخر حالة من ESP

    if (!hasFix.value || lat.value == 0 || lng.value == 0) {
      Get.snackbar(
        "❌ GPS",
        "الموقع غير متوفر حالياً، تأكد أن GPS يعمل على العصاية",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // إذا في موقع → افتح الخريطة
    openMapToStick();
  }

  // ===== Fetch /status =====
  Future<void> fetchStatus() async {
    print("TRY CONNECT TO ESP...");
    try {
      final response = await http.get(Uri.parse("$espUrl/status"));
      print("STATUS CODE = ${response.statusCode}");
      print("BODY = ${response.body}");

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);

      // 1) حدّث القيم أولاً
      wifi.value = data["wifi"] ?? false;
      gps.value = data["hasFix"] ?? false;
      hasFix.value = gps.value;
      battery.value = data["battery"] ?? 0;

      lat.value = (data["lat"] ?? 0.0).toDouble();
      lng.value = (data["lng"] ?? 0.0).toDouble();
      mapUrl.value = data["map"] ?? "";

      lastEventAge.value = data["lastEventAgeSec"] ?? -1;

      final newEvent = (data["lastEvent"] ?? "NONE").toString();
      // 🚨 التقط SOS من /status
      if (newEvent == "SOS" && lastEvent.value != "SOS") {
        print("🚨 SOS FROM STATUS");
        lastEvent.value = "SOS";
        addToHistory("SOS"); // ✅ أضف للسجل
        handleSOSFromApp();
        return; // مهم: نوقف هون حتى ما نكرر معالجة الحدث
      }

      // 2) حدّث آخر حدث للعرض فقط
      // 2) أي حدث جديد ثاني
      if (newEvent != "NONE" && newEvent != lastEvent.value) {
        lastEvent.value = newEvent;

        addToHistory(newEvent); // ✅ أضف للسجل
      }

      // 3) حدّث AI للعرض فقط
      aiDecision.value = AreaAI.analyze(lat.value, lng.value);
    } catch (e) {
      print("❌ ERROR fetchStatus: $e");
      wifi.value = false;
      gps.value = false;
      lastEvent.value = "OFFLINE";
    }
  }

  void addToHistory(String event) {
    final now = DateTime.now();
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    history.insert(0, "[$time] $event");

    // خليه آخر 10 فقط
    if (history.length > 10) {
      history.removeLast();
    }
  }

  // ===== Fetch /event (المصدر الوحيد للنطق والتدريب) =====
  Future<void> fetchEvent() async {
    try {
      final res = await http
          .get(Uri.parse("$espUrl/event"))
          .timeout(const Duration(seconds: 2));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final event = (data["lastEvent"] ?? "NONE").toString();
        if (event == "SOS") {
          print("🚨 SOS EVENT RECEIVED");
          handleSOSFromApp();
          return;
        }

        // جديد؟
        if (event.isEmpty || event == "NONE") return;
        if (event == lastEvent.value) return;

        lastEvent.value = event;

        // ✅ تدريب AI فقط إذا الحدث obstacle
        final isObstacle = event.contains("OBSTACLE");
        if (isObstacle) {
          await AreaAI.train(lat.value, lng.value, true);
          aiDecision.value = AreaAI.analyze(lat.value, lng.value);
        }

        // ✅ نطق مرة واحدة لكل حدث (بدون تكرار سريع)
        if (event != _lastSpokenEvent) {
          _lastSpokenEvent = event;

          if (event == "SOS") {
            handleSOSFromApp();
            return;
          }

          await _handleVoiceEvent(event);
        }
      }
    } catch (_) {}
  }

  void handleSOSFromApp() {
    print("🆘 SOS من التطبيق");
    bool canOpenMap = true;

    if (!hasFix.value || lat.value == 0 || lng.value == 0) {
      print("❌ ما في GPS");

      Get.snackbar(
        "استغاثة",
        "تم إرسال SOS ولكن الموقع غير متوفر (GPS غير جاهز)",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      canOpenMap = false;
    }

    // ابعت SOS دائماً
    sendSOS();

    // إذا في GPS افتح الخريطة
    if (canOpenMap) {
      Get.defaultDialog(
        title: "🚨 استغاثة",
        middleText: "تم إرسال استغاثة. هل تريد فتح موقع العصاية على الخريطة؟",
        textConfirm: "فتح الخريطة",
        textCancel: "إلغاء",
        onConfirm: () {
          Get.back();
          openMapToStick();
        },
      );
    }
  }

  void openMapToStick() async {
    if (!hasFix.value || lat.value == 0 || lng.value == 0) {
      Get.snackbar(
        "الخريطة",
        "الموقع غير متوفر حالياً",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final url = "https://maps.google.com/?q=${lat.value},${lng.value}";
    final uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      Get.snackbar(
        "خطأ",
        "لا يمكن فتح الخريطة",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleVoiceEvent(String event) async {
    if (_speaking) return;
    _speaking = true;

    // ✅ خزّن الحدث فورًا
    addToHistory(event);

    HapticFeedback.heavyImpact();

    // 1) احكي التحذير/التوجيه أولاً
    String? msg;
    if (event == "OBSTACLE:FRONT" || event == "OBSTACLE") {
      msg = "انتبه، يوجد عائق أمامك";
    } else if (event == "OBSTACLE:LEFT") {
      msg = "يوجد عائق على اليسار";
    } else if (event == "OBSTACLE:RIGHT") {
      msg = "يوجد عائق على اليمين";
    } else if (event == "TURN:LEFT") {
      msg = "انعطف يسار الآن";
    } else if (event == "TURN:RIGHT") {
      msg = "انعطف يمين الآن";
    } else if (event == "GO:STRAIGHT") {
      msg = "تابع السير للأمام";
    } else if (event == "STOP") {
      msg = "توقف فورًا";
    }

    if (msg != null) {
      tts.speak(msg);
    }

    // 2) بعده بشوي احكي الـ AI (اختياري)
    await Future.delayed(const Duration(milliseconds: 900));
    final aiText = AreaAI.analyze(lat.value, lng.value);
    aiDecision.value = aiText;
    tts.speak(aiText);

    _speaking = false;
  }

  // ===== Send SOS =====
  Future<void> sendSOS() async {
    try {
      await GetConnect().get("$espUrl/sos");
    } catch (_) {}
  }

  // ===== Send Command =====
  Future<void> sendCommand(String command) async {
    try {
      await http.post(
        Uri.parse("$espUrl/command"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"cmd": command}),
      );
    } catch (_) {}
  }
}
