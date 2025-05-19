import 'package:get/get.dart';

import 'controller.dart';

class SendBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenSendController>(() => TokenSendController());
  }
}
