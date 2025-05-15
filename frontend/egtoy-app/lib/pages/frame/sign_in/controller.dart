import 'package:flutter/material.dart';
import 'package:egtoy/common/apis/apis.dart';
import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/routers/routes.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'index.dart';

class SignInController extends GetxController {
  final state = SignInState();

  SignInController();

  // email的控制器
  final TextEditingController emailController = TextEditingController();
  // 密码的控制器
  final TextEditingController passController = TextEditingController();
  // 验证码的控制器
  final TextEditingController captchaController = TextEditingController();

  // 验证码UUID
  final captchaUuid = ''.obs;
  // final MyRepository repository;
  // SignInController({@required this.repository}) : assert(repository != null);

  // 跳转 注册界面
  handleNavSignUp() {
    Get.toNamed(AppRoutes.SIGN_UP);
  }

  // 忘记密码
  handleFogotPassword() {
    toastInfo(msg: '忘记密码');
  }

  // 生成新的UUID并刷新验证码
  refreshCaptcha() {
    captchaUuid.value = const Uuid().v4();
  }

  // 执行登录操作
  handleSignIn() async {
    // 验证邮箱和密码
    // if (!duIsEmail(_emailController.value.text)) {
    //   toastInfo(msg: '请正确输入邮件');
    //   return;
    // }
    // if (!duCheckStringLength(_passController.value.text, 6)) {
    //   toastInfo(msg: '密码不能小于6位');
    //   return;
    // }

    // 验证码校验
    if (captchaController.text.isEmpty) {
      toastInfo(msg: '请输入验证码');
      return;
    }

    UserLoginRequestEntity params = UserLoginRequestEntity(
      username: emailController.value.text,
      password: passController.value.text,
      captcha: captchaController.text, // 添加验证码
      captchaId: captchaUuid.value, // 添加UUID
    );

    try {
      print(params.toJson());
      UserLoginResponseEntity loginResponseEntity = await UserAPI.login(
        params: params,
      );
      print(loginResponseEntity.toJson());
      // code ==500 弹出对话框
      if (loginResponseEntity.code == 500) {
        toastInfo(msg: loginResponseEntity.msg ?? 'Unknown error occurred');
        // 刷新验证码
        refreshCaptcha();
        return;
      }
      if (loginResponseEntity.code == 401) {
        UserStore.to.onLogout();
        print("logout");
        return;
      }
      //
      if (loginResponseEntity.code == 0) {
        UserStore.to.saveProfile(loginResponseEntity.data!);
        toastInfo(msg: '登录成功');
        Get.offAndToNamed(AppRoutes.Application);
      }
    } catch (e) {
      e.printError();
      toastInfo(msg: '登录失败，请检查用户名、密码和验证码');
      // 刷新验证码
      refreshCaptcha();
    }
  }

  // 执行登录操作
  handleSignInWallet() async {
    // if (!duIsEmail(_emailController.value.text)) {
    //   toastInfo(msg: '请正确输入邮件');
    //   return;
    // }
    // if (!duCheckStringLength(_passController.value.text, 6)) {
    //   toastInfo(msg: '密码不能小于6位');
    //   return;
    // }

    UserLoginRequestEntity params = UserLoginRequestEntity(
      username: emailController.value.text,
      password: passController.value.text,
      captcha: captchaController.text, // 添加验证码
      captchaId: captchaUuid.value, // 添加UUID
    );
    UserLoginWeb3RequestEntity paramsWeb3 = UserLoginWeb3RequestEntity(
      address: 'J976UsKM8efguiAojTDkESeKaNeWQ1TG3wm63AJsk3jD',
    );
    UserLoginResponseEntity userProfile = await UserAPI.web3Login(
      params: paramsWeb3,
    );
    UserStore.to.saveProfile(userProfile.data!);

    Get.offAndToNamed(AppRoutes.Application);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    captchaController.dispose(); // 释放验证码控制器
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化时生成验证码UUID
    refreshCaptcha();
  }
}
