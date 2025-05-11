import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/page/wallet/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取控制器
    final controller = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('app_title'.tr),
        actions: [
          // 添加语言切换按钮
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Switch Language',
            onPressed: _changeLanguage,
          ),
          // 添加刷新按钮到AppBar右侧
          Obx(
            () => IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'refresh'.tr,
              onPressed:
                  controller.isLoading.value ? null : controller.refreshBalance,
            ),
          ),
        ],
      ),
      // 添加左侧抽屉菜单
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'app_title'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.walletAddress.value !=
                              'wallet_not_connected'.tr
                          ? 'wallet_connected'.tr
                          : 'wallet_not_connected'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: Text('import_private_key'.tr),
              onTap: () {
                // 关闭抽屉
                Navigator.pop(context);
                // 然后导航到导入私钥页面
                _navigateToImportWallet(context, controller);
              },
            ),
            Obx(
              () => ListTile(
                leading: const Icon(Icons.add),
                title: Text('create_wallet'.tr),
                enabled:
                    controller.walletAddress.value == 'wallet_not_connected'.tr,
                onTap: () {
                  Navigator.pop(context);
                  controller.createWallet();
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('about'.tr),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('about'.tr),
                      content: Text('app_description'.tr),
                      actions: <Widget>[
                        TextButton(
                          child: Text('confirm'.tr),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Center(
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
}
