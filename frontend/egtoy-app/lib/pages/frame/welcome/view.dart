import 'package:flutter/material.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class WelcomePage extends GetView<WelcomeController> {
  /// 页头标题
  Widget _buildPageHeadTitle() {
    return Container(
      margin: EdgeInsets.only(top: (60 + 44.0).h), // 顶部系统栏 44px
      child: Text(
        "app_name".tr, // 替换为国际化的应用名称
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

  /// 页头说明
  Widget _buildPageHeaderDetail() {
    return Container(
      width: 242.w,
      height: 70.h,
      margin: EdgeInsets.only(top: 14.h),
      child: Text(
        "welcome_description".tr, // 替换为国际化的描述文本
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: "Avenir",
          fontWeight: FontWeight.normal,
          fontSize: 16.sp,
          height: 1.3,
        ),
      ),
    );
  }

  /// 特性说明
  /// 宽度 80 + 20 + 195 = 295
  Widget _buildFeatureItem(
    String imageName,
    String translationKey,
    double marginTop,
  ) {
    return Container(
      width: 295.w,
      height: 80.h,
      margin: EdgeInsets.only(top: marginTop.h),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            child: Image.asset(
              "assets/images/$imageName.png",
              fit: BoxFit.none,
            ),
          ),
          Spacer(),
          Container(
            width: 195.w,
            child: Text(
              translationKey.tr, // 使用翻译键
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.primaryText,
                fontFamily: "Avenir",
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 开始按钮
  Widget _buildStartButton(BuildContext context) {
    return Container(
      width: 295.w,
      height: 44.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: TextButton(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16.sp)),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              return Colors.blue;
            } else if (states.contains(MaterialState.pressed)) {
              return Colors.deepPurple;
            }
            return AppColors.primaryElementText;
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue[200];
            }
            return AppColors.primaryElement;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: Radii.k6pxRadius),
          ),
        ),
        child: Text("get_started".tr),
        onPressed: controller.handleNavSignIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            _buildPageHeadTitle(),
            _buildPageHeaderDetail(),
            _buildFeatureItem("feature-1", "feature_1_text".tr, 86),
            _buildFeatureItem("feature-2", "feature_2_text".tr, 40),
            _buildFeatureItem("feature-3", "feature_3_text".tr, 40),
            Spacer(),
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }
}
