import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:egtoy/common/routers/routes.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:egtoy/common/utils/utils.dart';

class MyController extends GetxController {
  // 依赖注入
  final WalletService walletService = Get.find<WalletService>();
  final UserStore userStore = Get.find<UserStore>();
  final ConfigStore configStore = Get.find<ConfigStore>(); // 获取ConfigStore

  // 当前钱包地址
  final walletAddress = 'wallet_not_connected'.tr.obs;

  // 当前选中的语言
  final currentLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _initWalletInfo();
    _updateLanguageDisplay();

    // 监听语言变化
    ever(configStore.locale.obs, (_) {
      _updateLanguageDisplay();
    });
  }

  // 初始化钱包信息
  void _initWalletInfo() async {
    try {
      final wallet = walletService.getCurrentWallet();
      if (wallet != null) {
        final address = await wallet.publicKey.toBase58();
        walletAddress.value = address;
      } else {
        walletAddress.value = 'wallet_not_connected'.tr;
      }
    } catch (e) {
      print('获取钱包信息失败: $e');
      walletAddress.value = 'wallet_not_connected'.tr;
    }
  }

  // 更新语言显示
  void _updateLanguageDisplay() {
    if (configStore.locale.languageCode == 'zh') {
      currentLanguage.value = '中文';
    } else {
      currentLanguage.value = 'English';
    }
  }

  // 点击头像
  void onTapAvatar() {
    // 实现头像更换逻辑
    Get.toNamed(AppRoutes.PROFILE_PHOTO);
  }

  // 复制到剪贴板
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    EasyLoading.showSuccess('copied'.tr);
  }

  // 我的钱包
  void onTapWallet() {
    Get.toNamed(AppRoutes.Wallet);
  }

  // 我的NFT
  void onTapNFTs() {
    Get.toNamed(AppRoutes.MY_NFTS);
  }

  // 交易历史
  void onTapTransactionHistory() {
    Get.toNamed(AppRoutes.TRANSACTION_HISTORY);
  }

  // 账号设置
  void onTapAccountSettings() {
    Get.toNamed(AppRoutes.ACCOUNT_SETTINGS);
  }

  // 安全设置
  void onTapSecurity() {
    Get.toNamed(AppRoutes.SECURITY_SETTINGS);
  }

  // 语言设置
  void onTapLanguage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'select_language'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('English'),
                trailing:
                    configStore.locale.languageCode == 'en'
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                onTap: () {
                  print('切换到英文');
                  // 使用ConfigStore设置语言
                  configStore.onLocaleUpdate(const Locale('en', 'US'));
                  _updateLanguageDisplay();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('中文'),
                trailing:
                    configStore.locale.languageCode == 'zh'
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                onTap: () {
                  print('切换到中文');
                  // 使用ConfigStore设置语言
                  configStore.onLocaleUpdate(const Locale('zh', 'CN'));
                  _updateLanguageDisplay();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 通知设置
  void onTapNotifications() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  // 帮助中心
  void onTapHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  // 意见反馈
  void onTapFeedback() {
    Get.toNamed(AppRoutes.FEEDBACK);
  }

  // 关于我们
  void onTapAbout() {
    Get.toNamed(AppRoutes.ABOUT);
  }

  // 设置
  void onTapSettings() {
    Get.toNamed(AppRoutes.SETTINGS);
  }

  // 退出登录
  void onTapLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('logout_confirmation'.tr),
        content: Text('logout_confirmation_message'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              userStore.onLogout();
              walletService.clearWallet();
              Get.offAllNamed(AppRoutes.SIGN_IN);
            },
            child: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
