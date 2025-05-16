import 'package:egtoy/pages/my/index.dart';
import 'package:get/get.dart';

import 'controller.dart';

class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
    Get.lazyPut<MyController>(() => MyController());
  }
}
