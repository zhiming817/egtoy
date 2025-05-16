import 'package:get/get.dart';
import 'controller.dart';

class DeviceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeviceController>(() => DeviceController());
  }
}
