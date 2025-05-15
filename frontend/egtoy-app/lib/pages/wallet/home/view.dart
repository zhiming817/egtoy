import 'package:egtoy/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/pages/wallet/import/index.dart';
import 'package:egtoy/pages/device/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // 确保添加这个包依赖

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WalletController>()) {
      Get.put(WalletController());
    }

    final controller = Get.find<WalletController>();

    // 创建RefreshController
    final RefreshController _refreshController = RefreshController(
      initialRefresh: false,
    );

    // 下拉刷新回调
    void _onRefresh() async {
      await controller.refreshBalance();
      _refreshController.refreshCompleted();
    }

    return Scaffold(
      // 移除AppBar
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),

      // left menu
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SmartRefresher(
                  // 使用SmartRefresher替换原来的直接内容展示
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  header: const WaterDropHeader(), // 可以选择不同的刷新头部样式
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'wallet_address'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap:
                                () => controller.copyToClipboard(
                                  controller.walletAddress.value,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey[400]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      controller.walletAddress.value,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'wallet_balance'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.balance.value.toStringAsFixed(6)} SOL',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'token_balance'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.egtBalance.value.toStringAsFixed(2)} EGT',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (controller.walletAddress.value ==
                              'wallet_not_connected'.tr)
                            ElevatedButton.icon(
                              onPressed: controller.createWallet,
                              icon: const Icon(Icons.add_circle_outline),
                              label: Text('create_wallet'.tr),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  // 添加语言切换方法
  void _changeLanguage() {
    // 获取当前语言
    final String currentLocale = Get.locale?.languageCode ?? 'en';

    // 切换语言
    if (currentLocale == 'en') {
      Get.updateLocale(const Locale('zh', 'CN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  // 导航到导入钱包页面
  Future<void> _navigateToImportWallet(
    BuildContext context,
    WalletController controller,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImportWalletPage()),
    );

    if (result != null) {
      controller.setWallet(result);
    }
  }

  // 导航到设备管理页面
  void _navigateToDeviceManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceListView(controller: DeviceController()),
      ),
    );
  }
}
