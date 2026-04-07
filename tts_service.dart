import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService extends GetxService {
  final FlutterTts tts = FlutterTts();

  Future<TtsService> init() async {
    await tts.setLanguage("ar-SA");
    await tts.setSpeechRate(0.45);
    return this;
  }

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }
}
