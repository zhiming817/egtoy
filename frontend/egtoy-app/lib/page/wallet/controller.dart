import 'package:egtoy/common/entities/entities.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';
import 'package:flutter/services.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:egtoy/common/apis/user.dart';

class WalletController extends GetxController {
  final BlockchainManager blockchainManager;

  // 使用 Rx 变量来实现响应式状态
  final walletAddress = RxString('未连接钱包'); // 先使用固定文本
  final balance = 0.0.obs;
  final egtBalance = 0.0.obs;
  final isLoading = false.obs;

  // EGT代币Mint地址
  static const String egtTokenMint =
      'mntv4xfdYmnSs1Bof5ZXmXu7bR5EV4sJk93bCr9NVek';

  WalletController({required this.blockchainManager});

  @override
  void onInit() {
    super.onInit();
    // 初始化时检查是否已有钱包
    checkWallet();

    // 更新初始文本以匹配当前语言
    if (blockchainManager.currentWallet == null) {
      walletAddress.value = 'wallet_not_connected'.tr;
    }

    // 添加翻译更新回调
    Get.addTranslations({
      'en_US': {'wallet_not_connected': 'No Wallet Connected'},
    });
    Get.addTranslations({
      'zh_CN': {'wallet_not_connected': '未连接钱包'},
    });
  }

  // 处理语言变化的方法，可以在需要时调用
  void updateTranslations() {
    if (walletAddress.value == '未连接钱包' ||
        walletAddress.value == 'No Wallet Connected') {
      walletAddress.value = 'wallet_not_connected'.tr;
    }
  }

  Future<void> checkWallet() async {
    isLoading.value = true;

    try {
      handleSignUp("J976UsKM8efguiAojTDkESeKaNeWQ1TG3wm63AJsk3jD");
      // 检查是否已有钱包
      if (blockchainManager.currentWallet != null) {
        final address =
            await blockchainManager.currentWallet!.publicKey.toBase58();
        print(address);
        final balanceValue = await blockchainManager.solanaService.getBalance(
          address,
        );

        // 获取EGT代币余额
        final egtBalanceValue = await blockchainManager.solanaService
            .getTokenBalance(address, egtTokenMint);

        walletAddress.value = address;
        balance.value = balanceValue;
        egtBalance.value = egtBalanceValue;
      } else {
        walletAddress.value = 'wallet_not_connected'.tr;
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'get_wallet_info_error'.tr + ': ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWallet() async {
    isLoading.value = true;

    try {
      // 创建新钱包
      final wallet = await blockchainManager.walletService.createWallet();
      blockchainManager.currentWallet = wallet;

      final address = await wallet.publicKey.toBase58();
      final balanceValue = await blockchainManager.solanaService.getBalance(
        address,
      );

      walletAddress.value = address;
      balance.value = balanceValue;
      egtBalance.value = 0.0; // 新钱包没有EGT代币

      Get.snackbar('app_name'.tr, 'wallet_created'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'create_wallet_error'.tr + ': ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBalance() async {
    if (blockchainManager.currentWallet == null) {
      Get.snackbar('提示', '请先创建或导入钱包');
      return;
    }

    isLoading.value = true;

    try {
      final address =
          await blockchainManager.currentWallet!.publicKey.toBase58();
      final balanceValue = await blockchainManager.solanaService.getBalance(
        address,
      );

      // 刷新EGT代币余额
      final egtBalanceValue = await blockchainManager.solanaService
          .getTokenBalance(address, egtTokenMint);

      balance.value = balanceValue;
      egtBalance.value = egtBalanceValue;
    } catch (e) {
      Get.snackbar('错误', '刷新余额失败: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('app_name'.tr, 'copied'.tr);
  }

  void setWallet(Ed25519HDKeyPair wallet) {
    blockchainManager.currentWallet = wallet;
    checkWallet();
  }

  // 执行注册操作
  handleSignUp(String address) async {
    UserLoginWeb3RequestEntity params = UserLoginWeb3RequestEntity(
      address: address,
    );
    print(params.toJson());

    UserLoginResponseEntity userProfile = await UserAPI.web3Login(
      params: params,
    );
    print(userProfile.toJson());

    //Get.back();
  }
}
