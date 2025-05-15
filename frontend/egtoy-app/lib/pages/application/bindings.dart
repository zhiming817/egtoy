import 'package:egtoy/pages/agent/index.dart';
import 'package:egtoy/pages/main/index.dart';
import 'package:egtoy/pages/wallet/home/index.dart';
import 'package:egtoy/pages/my/index.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<WalletController>(() => WalletController());
    Get.lazyPut<AgentController>(() => AgentController());
    Get.lazyPut<MyController>(() => MyController());
  }
}
