import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:egtoy/common/routers/routes.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:solana/solana.dart';

import 'index.dart';

class MyController extends GetxController {
  // 依赖注入
  final WalletService walletService = Get.find<WalletService>();
  final UserStore userStore = Get.find<UserStore>();
  final ConfigStore configStore = Get.find<ConfigStore>(); // 获取ConfigStore

  // 当前钱包地址
  final walletAddress = 'wallet_not_connected'.tr.obs;

  // 当前选中的语言
  final currentLanguage = 'English'.obs;

  final state = MyState();

  @override
  void onInit() {
    super.onInit();
    _initWalletInfo();

    print("onInit ");
    // _updateLanguageDisplay();

    // // 监听语言变化
    // ever(configStore.locale.obs, (_) {
    //   _updateLanguageDisplay();
    // });
  }

  @override
  void onReady() {
    super.onReady();
    print("onReady ");
  }

  // 初始化钱包信息
  void _initWalletInfo() async {
    print("_initWalletInfo ");
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
  void onTapWallet() async {
    final result = Get.toNamed(AppRoutes.Wallet);
    // 检查返回的结果
    if (result != null) {
      // 假设返回的 result 是 Ed25519HDKeyPair 对象
      // 或者您在导入页面返回的是钱包地址字符串
      print("MyController: Received result from wallet page: $result");

      // 如果 WalletService 的 _currentWallet 已经被正确设置，
      // 并且 MyController 已经通过 ever 监听了 walletService.currentWalletObs,
      // _initWalletInfo() 应该会自动被调用。
      // 但如果需要显式处理返回结果，可以这样做：
      if (result is Ed25519HDKeyPair) {
        // 确保类型正确
        // walletService.setCurrentWallet(result); // 如果导入页没有设置，这里可以设置
        // _initWalletInfo(); // 然后刷新信息
        print(
          "MyController: Wallet object received, _initWalletInfo should be triggered by 'ever' listener.",
        );
      } else if (result is String) {
        // 如果返回的是地址字符串
        // walletAddress.value = result; // 直接更新地址
        // 或者，如果需要通过 WalletService 更新
        // final importedWallet = await walletService.importWalletFromPrivateKeyString(somePrivateKey); // 这不合适，因为我们已经有结果了
        // 最好是确保 WalletService.currentWallet 被更新，然后依赖 'ever' 监听器
        print(
          "MyController: Wallet address string received: $result. Relying on 'ever' listener to update UI.",
        );
      }
    } else {
      print("MyController: No result returned from wallet page.");
      // 即使没有直接返回结果，如果 WalletService.currentWallet 更新了，
      // 'ever' 监听器也应该会触发 _initWalletInfo
    }
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
