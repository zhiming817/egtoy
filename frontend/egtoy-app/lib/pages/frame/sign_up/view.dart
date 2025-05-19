import 'package:flutter/material.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class SignUpPage extends GetView<SignUpController> {
  // logo
  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      child: Text(
        "Sign up",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
          height: 1,
        ),
      ),
    );
  }

  // 注册表单
  Widget _buildInputForm() {
    return Container(
      width: 295.w,
      // height: 204,
      margin: EdgeInsets.only(top: 49.h),
      child: Column(
        children: [
          // fullName input

          // email input
          inputTextEdit(
            controller: controller.userNameController,
            keyboardType: TextInputType.name,
            hintText: "User Name",
          ),
          // password input
          inputTextEdit(
            controller: controller.passController,
            keyboardType: TextInputType.visiblePassword,
            hintText: "Password",
            isPassword: true,
          ),
          // 验证码输入框
          Container(
            height: 44.h,
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              children: [
                // 验证码输入字段
                Expanded(
                  child: inputTextEdit(
                    controller: controller.captchaController,
                    keyboardType: TextInputType.text,
                    hintText: "verification_code".tr, // 使用国际化键
                    marginTop: 0,
                  ),
                ),
                // 验证码图片
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  width: 100.w,
                  height: 44.h,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () => controller.refreshCaptcha(),
                      child: Image.network(
                        "${SERVER_API_URL}/user/captcha?uuid=${controller.captchaUuid.value}",
                        fit: BoxFit.fill,
                        // 如果图片加载失败，显示刷新图标
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.refresh, color: Colors.grey),
                          );
                        },
                        // 加载中显示进度条
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 创建
          Container(
            height: 44.h,
            margin: EdgeInsets.only(top: 15.h),
            child: btnFlatButtonWidget(
              onPressed: controller.handleSignUp,
              width: 295.w,
              fontWeight: FontWeight.w600,
              title: "Create an account",
            ),
          ),
          // Spacer(),

          // Fogot password
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: controller.handleFogotPassword,
              child: Text(
                "Fogot password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryElementText,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 1, // 设置下行高，否则字体下沉
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 第三方
  Widget _buildThirdPartyLogin() {
    return Container(
      width: 295.w,
      margin: EdgeInsets.only(bottom: 40.h),
      child: Column(
        children: <Widget>[
          // title
          Text(
            "Or sign in with social networks",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
          // 按钮
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: <Widget>[
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                  iconFileName: "twitter",
                ),
                Spacer(),
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                  iconFileName: "google",
                ),
                Spacer(),
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                  iconFileName: "facebook",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 有账号
  Widget _buildHaveAccountButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: btnFlatButtonWidget(
        onPressed: controller.handleNavPop,
        width: 294,
        gbColor: AppColors.secondaryElement,
        fontColor: AppColors.primaryText,
        title: "I have an account",
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: transparentAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: controller.handleNavPop,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.primaryText),
            onPressed: controller.handleTip,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Divider(height: 1),
            _buildLogo(),
            _buildInputForm(),
            Spacer(),
            _buildThirdPartyLogin(),
            _buildHaveAccountButton(),
          ],
        ),
      ),
    );
  }
}
