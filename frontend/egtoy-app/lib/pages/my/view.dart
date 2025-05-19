import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'controller.dart';

class MyPage extends GetView<MyController> {
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
          child: Center(
            child: Column(
              children: [
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
                SizedBox(height: 10.h),
                Text(
                  userStore.profile.msg ?? 'User Name', // 直接使用英文
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 5.h),
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
    required String title, // title 现在是直接的英文字符串
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: AppColors.primaryText, size: 24.sp),
      title: Text(
        title, // 直接使用传入的 title
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
            'Wallet & Assets', // 直接使用英文
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.account_balance_wallet,
          title: 'My Wallet', // 直接使用英文
          onTap: controller.onTapWallet,
        ),
        _buildMenuItem(
          leadingIcon: Icons.token,
          title: 'My NFTs', // 直接使用英文
          onTap: controller.onTapNFTs,
        ),
        _buildMenuItem(
          leadingIcon: Icons.history,
          title: 'Transaction History', // 直接使用英文
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
            'Settings', // 直接使用英文
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.person_outline,
          title: 'Account Settings', // 直接使用英文
          onTap: controller.onTapAccountSettings,
        ),
        _buildMenuItem(
          leadingIcon: Icons.security,
          title: 'Security', // 直接使用英文
          onTap: controller.onTapSecurity,
        ),
        // 语言切换部分，trailing 的文本也直接用英文
        Obx(
          // Obx 仍然需要，因为 controller.currentLanguage.value 是响应式的
          () => _buildMenuItem(
            leadingIcon: Icons.language,
            title: 'Language', // 直接使用英文
            trailing: Text(
              // controller.currentLanguage.value 仍然会是 "English" 或 "中文"
              // 如果希望这里也固定为英文，需要修改 controller 的 _updateLanguageDisplay
              // 或者直接显示一个固定的英文文本，例如 "English"
              controller.currentLanguage.value, // 或者直接写 "English"
              style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
            ),
            onTap: controller.onTapLanguage,
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.notifications_none,
          title: 'Notifications', // 直接使用英文
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
            'Support', // 直接使用英文
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        _buildMenuItem(
          leadingIcon: Icons.help_outline,
          title: 'Help Center', // 直接使用英文
          onTap: controller.onTapHelpCenter,
        ),
        _buildMenuItem(
          leadingIcon: Icons.feedback_outlined,
          title: 'Feedback', // 直接使用英文
          onTap: controller.onTapFeedback,
        ),
        _buildMenuItem(
          leadingIcon: Icons.info_outline,
          title: 'About', // 直接使用英文
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
        child: Text('Logout', style: TextStyle(fontSize: 16.sp)), // 直接使用英文
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 不再需要 GetBuilder<ConfigStore> 来监听语言变化，因为文本是硬编码的
    // 但如果 controller 内部有依赖 ConfigStore 的逻辑，或者其他原因需要重建，可以保留
    // 为了完全移除国际化影响，可以暂时去掉 GetBuilder<ConfigStore>
    // return GetBuilder<ConfigStore>(
    //   builder: (_) {
    // print("'my_profile' 翻译为: ${'my_profile'.tr}"); // 这行会报错，因为我们不再期望 .tr 工作

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'), // 直接使用英文
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: controller.onTapSettings, // onTapSettings 可能仍然会触发语言相关的逻辑
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(),
            //_buildWalletSection(),
            _buildSettingsSection(),
            _buildSupportSection(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
    //   },
    // );
  }
}
