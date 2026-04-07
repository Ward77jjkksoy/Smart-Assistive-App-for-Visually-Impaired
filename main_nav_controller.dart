import 'package:get/get.dart';

class MainNavController extends GetxController {
  var index = 0.obs;

  void changeTab(int i) {
    index.value = i;
  }
}
