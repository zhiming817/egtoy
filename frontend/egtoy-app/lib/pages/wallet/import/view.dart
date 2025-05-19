import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:egtoy/common/values/values.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({super.key});

  @override
  State<ImportWalletPage> createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final TextEditingController _privateKeyController = TextEditingController();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _obscureText = true.obs;

  // 直接获取钱包服务
  late final WalletService _walletService;

  @override
  void initState() {
    super.initState();
    // 获取或初始化 WalletService
    try {
      _walletService = Get.find<WalletService>();
    } catch (_) {
      _walletService = Get.put(WalletService());
    }
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _importWallet() async {
    final privateKeyText = _privateKeyController.text.trim();
    if (privateKeyText.isEmpty) {
      _errorMessage.value = "Private key is required";
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // 直接调用 WalletService 导入钱包
      final wallet = await _walletService.importWalletFromPrivateKeyString(
        privateKeyText,
      );
      print("Wallet imported: ${wallet.address}");
      await StorageService.to.setString(
        STORAGE_USER_WALLET_ADDRESS_KEY,
        wallet.address,
      );
      _walletService.setCurrentWallet(wallet);
      Get.back(result: wallet);
    } catch (e) {
      _errorMessage.value = 'Failed to import wallet'.tr + ': ${e.toString()}';
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Private Key'.tr),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () =>
              _isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter your private key:'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Warning: Private keys represent full access. Make sure you are in a secure environment.'
                            .tr,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => TextField(
                          controller: _privateKeyController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter your private key:'.tr,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                _obscureText.value = !_obscureText.value;
                              },
                            ),
                          ),
                          obscureText: _obscureText.value,
                          maxLines: 1,
                        ),
                      ),
                      Obx(
                        () =>
                            _errorMessage.value.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _errorMessage.value,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _importWallet,
                        child: Text('Import'.tr),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'.tr),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
