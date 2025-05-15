import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'controller.dart';

class MyPage extends GetView<MyController> {
  const MyPage({Key? key}) : super(key: key);

  // 头部用户信息
  Widget _buildUserHeader() {
    return GetX<UserStore>(
      builder: (userStore) {
        return Container(
          padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          // 添加居中布局
          child: Center(
            child: Column(
              children: [
                // 头像
                GestureDetector(
                  onTap: controller.onTapAvatar,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.w),
                      border: Border.all(
                        color: AppColors.primaryElement,
                        width: 2.w,
                      ),
                    ),
                    child:
                        userStore.profile.data?.avatar != null &&
                                userStore.profile.data!.avatar!.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(40.w),
                              child: CachedNetworkImage(
                                imageUrl: userStore.profile.data!.avatar!,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                        const CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.person, size: 40),
                              ),
                            )
                            : Icon(
                              Icons.person,
                              size: 40.sp,
                              color: AppColors.primaryText,
                            ),
                  ),
                ),
                // 用户名
                SizedBox(height: 10.h),
                Text(
                  userStore.profile.msg ?? 'user_name'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                // 钱包地址
                SizedBox(height: 5.h),
                if (controller.walletAddress.value.isNotEmpty &&
                    controller.walletAddress.value != 'wallet_not_connected'.tr)
                  GestureDetector(
                    onTap:
                        () => controller.copyToClipboard(
                          controller.walletAddress.value,
                        ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // 添加安全检查，避免字符串越界
                          controller.walletAddress.value.length >= 10
                              ? '${controller.walletAddress.value.substring(0, 6)}...${controller.walletAddress.value.substring(controller.walletAddress.value.length - 4)}'
                              : controller
                                  .walletAddress
                                  .value, // 如果地址太短，就直接显示完整地址
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        const Icon(Icons.copy, size: 14),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 菜单项构建
  Widget _buildMenuItem({
    required IconData leadingIcon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: AppColors.primaryText, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(fontSize: 16.sp, color: AppColors.primaryText),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.secondaryText,
            size: 16.sp,
          ),
      onTap: onTap,
    );
  }

  // 构建区块链账户部分
  Widget _buildWalletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'wallet_and_assets'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.account_balance_wallet,
          title: 'my_wallet'.tr,
          onTap: controller.onTapWallet,
        ),
        _buildMenuItem(
          leadingIcon: Icons.token,
          title: 'my_nfts'.tr,
          onTap: controller.onTapNFTs,
        ),
        _buildMenuItem(
          leadingIcon: Icons.history,
          title: 'transaction_history'.tr,
          onTap: controller.onTapTransactionHistory,
        ),
      ],
    );
  }

  // 构建设置部分
  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'settings'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.person_outline,
          title: 'account_settings'.tr,
          onTap: controller.onTapAccountSettings,
        ),
        _buildMenuItem(
          leadingIcon: Icons.security,
          title: 'security'.tr,
          onTap: controller.onTapSecurity,
        ),
        Obx(
          () => _buildMenuItem(
            leadingIcon: Icons.language,
            title: 'language'.tr,
            trailing: Text(
              controller.currentLanguage.value,
              style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
            ),
            onTap: controller.onTapLanguage,
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.notifications_none,
          title: 'notifications'.tr,
          onTap: controller.onTapNotifications,
        ),
      ],
    );
  }

  // 构建支持部分
  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'support'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.help_outline,
          title: 'help_center'.tr,
          onTap: controller.onTapHelpCenter,
        ),
        _buildMenuItem(
          leadingIcon: Icons.feedback_outlined,
          title: 'feedback'.tr,
          onTap: controller.onTapFeedback,
        ),
        _buildMenuItem(
          leadingIcon: Icons.info_outline,
          title: 'about'.tr,
          onTap: controller.onTapAbout,
        ),
      ],
    );
  }

  // 退出登录按钮
  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: ElevatedButton(
        onPressed: controller.onTapLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          minimumSize: Size(double.infinity, 44.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text('logout'.tr, style: TextStyle(fontSize: 16.sp)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_profile'.tr),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: controller.onTapSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(),
            SizedBox(height: 10.h),
            _buildWalletSection(),
            const Divider(),
            _buildSettingsSection(),
            const Divider(),
            _buildSupportSection(),
            _buildLogoutButton(),
            // 底部安全区域
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
