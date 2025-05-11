import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';
import 'package:egtoy/common/services/services.dart';

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

  // 获取全局变量
  final blockchainManager = Get.find<BlockchainManager>();

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _importWallet() async {
    final privateKeyText = _privateKeyController.text.trim();
    if (privateKeyText.isEmpty) {
      _errorMessage.value = 'private_key_required'.tr;
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // 尝试从私钥字符串导入钱包
      final wallet = await blockchainManager.walletService
          .importWalletFromPrivateKeyString(privateKeyText);

      Get.back(result: wallet);
    } catch (e) {
      _errorMessage.value = 'import_wallet_error'.tr + ': ${e.toString()}';
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('import_private_key'.tr),
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
                        'enter_private_key'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'private_key_warning'.tr,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => TextField(
                          controller: _privateKeyController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'enter_private_key'.tr,
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
                        child: Text('import'.tr),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('cancel'.tr),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
