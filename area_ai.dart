import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AreaAI {
  static Map<String, int> dangerMap = {};

  static String _key(double lat, double lng) {
    return "${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}";
  }

  // ===== تحميل البيانات من الهاتف =====
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("dangerMap");

    if (data != null) {
      Map<String, dynamic> decoded = jsonDecode(data);
      dangerMap = decoded.map((k, v) => MapEntry(k, v as int));
    }
  }

  // ===== حفظ البيانات في الهاتف =====
  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(dangerMap);
    await prefs.setString("dangerMap", encoded);
  }

  // ===== تدريب =====
  static Future<void> train(double lat, double lng, bool obstacle) async {
    if (!obstacle) return;

    String key = _key(lat, lng);
    dangerMap[key] = (dangerMap[key] ?? 0) + 1;

    await save(); // 👈 نحفظ بعد كل تحديث
  }

  // ===== تحليل =====
  static String analyze(double lat, double lng) {
    String key = _key(lat, lng);
    int count = dangerMap[key] ?? 0;

    if (count > 10) return "🚨 منطقة خطرة جدًا";
    if (count > 4) return "⚠️ منطقة مليئة بالعوائق";
    return "✅ المنطقة آمنة";
  }
}
