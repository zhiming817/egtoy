import 'package:egtoy/common/routers/routes.dart';
import 'package:egtoy/common/store/store.dart'; // 确保 UserStore 可以通过这里访问，或者单独导入
import 'package:get/get.dart';

import 'index.dart';

class WelcomeController extends GetxController {
  final state = WelcomeState();

  WelcomeController();

  @override
  void onInit() {
    super.onInit();
    _checkUserLoginStatus();
  }

  void _checkUserLoginStatus() {
    // 假设 UserStore.to.isLogin 是一个布尔值 (或 UserStore.to.isLogin.value 如果是 RxBool)
    // 用来判断用户登录状态。
    // 请确保 UserStore 已经初始化。
    if (UserStore.to.isLogin == true) {
      // 如果用户已登录，则直接跳转到应用主界面
      Get.offAndToNamed(
        AppRoutes.Application,
      ); // 请替换 AppRoutes.Application 为你的主界面路由
    }
    // 如果未登录，则 WelcomePage 会正常显示，用户可以通过页面上的操作触发 handleNavSignIn
  }

  // 跳转 注册界面
  handleNavSignIn() async {
    await ConfigStore.to.saveAlreadyOpen(); // 标记用户已通过欢迎页
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }

  @override
  void onReady() {
    super.onReady();
    // 如果在 onInit 中发生了导航，此处的代码可能不会完全执行，
    // 或者 WelcomePage 可能在 onReady 完成前就被销毁了。
  }
}
