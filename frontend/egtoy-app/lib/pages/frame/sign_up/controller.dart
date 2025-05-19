import 'dart:convert';

import 'package:egtoy/common/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:egtoy/common/apis/apis.dart';
import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'index.dart';

class SignUpController extends GetxController {
  /// obs 响应式变量 才写入 state
  final state = SignUpState();

  SignUpController();

  /// 业务变量

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  // 验证码的控制器
  final TextEditingController captchaController = TextEditingController();

  // 验证码UUID
  final captchaUuid = ''.obs;

  /// 业务事件

  // 返回上一页
  handleNavPop() {
    Get.back();
  }

  // 提示信息
  handleTip() {
    toastInfo(msg: '这是注册界面');
  }

  // 忘记密码
  handleFogotPassword() {
    toastInfo(msg: '忘记密码');
  }

  // 生成新的UUID并刷新验证码
  refreshCaptcha() {
    captchaUuid.value = const Uuid().v4();
  }

  // 执行注册操作
  handleSignUp() async {
    // if (!duCheckStringLength(fullnameController.value.text, 5)) {
    //   toastInfo(msg: '用户名不能小于5位');
    //   return;
    // }
    if (userNameController.value.text.isEmpty) {
      toastInfo(msg: 'Please input UserName');
      return;
    }
    if (!duCheckStringLength(passController.value.text, 6)) {
      toastInfo(msg: 'Password must be at least 6 characters');
      return;
    }
    // 验证码校验
    if (captchaController.text.isEmpty) {
      toastInfo(msg: 'Please input verification code');
      return;
    }
    UserRegisterRequestEntity regist_params = UserRegisterRequestEntity(
      username: userNameController.value.text,
      password: passController.value.text,
      captcha: captchaController.text, // 添加验证码
      captchaId: captchaUuid.value, // 添加UUID
    );
    print('注册参数: ' + jsonEncode(regist_params));
    UserLoginResponseEntity loginResponseEntity = await UserAPI.register(
      params: regist_params,
    );
    print('注册返回: ' + jsonEncode(loginResponseEntity));
    if (loginResponseEntity.code == 0) {
      //UserStore.to.saveProfile(loginResponseEntity.data!);
      toastInfo(msg: 'Regist success');
      Get.offAndToNamed(AppRoutes.SIGN_IN);
    } else {
      toastInfo(msg: loginResponseEntity.msg ?? 'Unknown error occurred');
      // 刷新验证码
      refreshCaptcha();
    }

    // Get.back();
  }

  /// 生命周期

  // 页面载入完成
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    userNameController.dispose();
    userNameController.dispose();
    passController.dispose();
    captchaController.dispose(); // 释放验证码控制器
    super.dispose();
  }
}
