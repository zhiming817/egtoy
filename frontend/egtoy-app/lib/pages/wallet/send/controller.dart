import 'package:egtoy/common/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/pages/wallet/home/view.dart'; // 假设 YourTokenInfoClass 在这里或共享
import 'package:egtoy/pages/wallet/select/index.dart'; // 导入 YourTokenInfoClass
import 'package:egtoy/common/services/services.dart';
import 'package:solana/solana.dart';

class TokenSendController extends GetxController {
  late YourTokenInfoClass selectedToken; // 接收选择的代币信息

  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // 直接引入需要的服务
  late final SolanaService solanaService;
  late final WalletService walletService;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null &&
        Get.arguments['tokenInfo'] is YourTokenInfoClass) {
      selectedToken = Get.arguments['tokenInfo'];
    } else {
      // 处理错误，例如返回上一页或显示错误信息
      Get.snackbar('Error', 'No token selected or invalid token data.');
      Get.back(); // 返回到代币选择或钱包主页
    }
    // 直接获取或创建服务
    try {
      solanaService = Get.find<SolanaService>();
      walletService = Get.find<WalletService>();
    } catch (_) {
      solanaService = Get.put(SolanaService(devnet: true));
      walletService = Get.put(WalletService());
    }
  }

  void setMaxAmount() {
    amountController.text = selectedToken.balance.toString();
  }

  Future<void> sendTransaction() async {
    final recipientAddress = addressController.text.trim();
    final amountText = amountController.text.trim();
    final memo = memoController.text.trim();

    if (recipientAddress.isEmpty) {
      errorMessage.value = 'Recipient address is required.';
      return;
    }
    if (amountText.isEmpty) {
      errorMessage.value = 'Amount is required.';
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      errorMessage.value = 'Invalid amount.';
      return;
    }
    if (amount > selectedToken.balance) {
      errorMessage.value = 'Insufficient balance.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      // TODO: 实现发送代币的逻辑
      // 使用 selectedToken.contractAddress, recipientAddress, amount, memo
      print('Sending ${selectedToken.symbol}:');
      print('To: $recipientAddress');
      print('Amount: $amount');
      print('Memo: $memo');
      //await Future.delayed(Duration(seconds: 2)); // 模拟交易

      //Get.snackbar('Success', '${selectedToken.symbol} sent successfully!');
      //Get.offAllNamed(AppRoutes.Application); // 或者返回到钱包主页并刷新
      final senderWallet = walletService.getCurrentWallet();
      if (senderWallet == null) {
        print('No wallet found. Please create or import a wallet first.');
        errorMessage.value =
            'No wallet found. Please create or import a wallet first.';
        isLoading.value = false;
        return;
      }
      if (selectedToken.symbol.toUpperCase() == 'SOL') {
        // 2. 调用 transferSol 方法
        final signature = await solanaService.transferSol(
          wallet: senderWallet, // Wallet 类型是 Ed25519HDKeyPair 的父类或接口
          destination: recipientAddress,
          amount: amount,
          memo: memo,
        );
        print('SOL transfer successful! Signature: $signature');
      }
      if (selectedToken.symbol.toUpperCase() == 'EGT') {
        int tokenDecimals;
        String tokenMint;
        tokenMint =
            "mntv4xfdYmnSs1Bof5ZXmXu7bR5EV4sJk93bCr9NVek"; // 使用 WalletController 中的常量
        tokenDecimals = 9;

        final amountInSmallestUnit =
            (amount * BigInt.from(10).pow(tokenDecimals).toDouble()).toInt();

        final signature = await solanaService.transferSplToken(
          sourceWallet: senderWallet,
          destinationAddress: recipientAddress,
          tokenMintAddress: tokenMint,
          amount: amountInSmallestUnit,
          decimals: tokenDecimals,
          memo: memo,
        );
        print(
          '${selectedToken.symbol} transfer successful! Signature: $signature',
        );
      }
    } catch (e) {
      print('SOL transfer failed: $e');
      errorMessage.value =
          'Failed to send ${selectedToken.symbol}: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    amountController.dispose();
    memoController.dispose();
    super.onClose();
  }
}
