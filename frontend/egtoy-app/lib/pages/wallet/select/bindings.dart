import 'package:get/get.dart';

import 'controller.dart';

class SelectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenSelectionController>(() => TokenSelectionController());
  }
}
