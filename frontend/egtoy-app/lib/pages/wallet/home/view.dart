import 'package:egtoy/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/pages/wallet/import/index.dart'; // 确保 WalletController 在这里或全局注册
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:egtoy/common/routers/routes.dart';

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保 WalletController 已注册
    // 如果 WalletController 是在路由导航时注入的，或者在main.dart中全局注入，
    // 这里的 Get.put 可能需要调整或移除，以避免重复注册。
    // 假设 WalletController 应该在这里被获取或创建（如果不存在）。
    final WalletController controller = Get.find<WalletController>();
    // 或者使用 Get.put() 如果它是在此页面首次创建
    // if (!Get.isRegistered<WalletController>()) {
    //   Get.put(WalletController());
    // }
    // final controller = Get.find<WalletController>();

    final RefreshController _refreshController = RefreshController(
      initialRefresh: false,
    );

    void _onRefresh() async {
      await controller.refreshBalance();
      _refreshController.refreshCompleted();
    }

    return Scaffold(
      backgroundColor: Colors.white, // 设置页面背景为白色
      appBar: AppBar(
        title: Text(
          'My Wallet'.tr, // '我的钱包'
          style: const TextStyle(color: Colors.black), // 文本颜色改为黑色
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: Colors.black, // 图标颜色改为黑色
            ),
            onPressed: () {
              // TODO: 实现扫描二维码功能
              controller.history();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ), // 图标颜色改为黑色
            onPressed: () {
              // TODO: 跳转到设置页面
              final result = Get.toNamed(AppRoutes.Wallet);
            },
          ),
        ],
        backgroundColor: Colors.transparent, // AppBar 透明以显示页面背景
        elevation: 0,
      ),
      body: Obx(
        () =>
            controller.isLoading.value && !_refreshController.isRefresh
                ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ), // 加载指示器颜色改为黑色
                )
                : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullDown: true,
                  header: WaterDropHeader(
                    // 下拉刷新头部样式调整
                    waterDropColor: Colors.grey, // 水滴颜色调整
                    complete: Text(
                      'Refresh completed',
                      style: TextStyle(color: Colors.black54), // 文本颜色调整
                    ),
                    failed: Text(
                      'Refresh failed',
                      style: TextStyle(color: Colors.black54), // 文本颜色调整
                    ),
                  ),
                  child: SingleChildScrollView(
                    // 使用 SingleChildScrollView 允许内容超出屏幕时滚动
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Wallet Address
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
                              color: Colors.grey[200], // 地址背景色调整
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Placeholder for Solana Icon
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.deepPurpleAccent, // 图标颜色调整
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    controller.walletAddress.value.length > 10
                                        ? '${controller.walletAddress.value.substring(0, 6)}...${controller.walletAddress.value.substring(controller.walletAddress.value.length - 4)}'
                                        : controller.walletAddress.value,
                                    style: const TextStyle(
                                      color: Colors.black87, // 文本颜色改为黑色系
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.copy,
                                  size: 14,
                                  color: Colors.black54, // 图标颜色改为黑色系
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // SOL Balance
                        Text(
                          '${controller.balance.value.toStringAsFixed(4)} SOL',
                          style: const TextStyle(
                            color: Colors.black, // 文本颜色改为黑色
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // USD Value (Placeholder)
                        Text(
                          '≈ 0.00 USD', // TODO: Implement USD conversion
                          style: TextStyle(
                            color: Colors.grey[700], // 文本颜色调整
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Action Buttons (Receive, Send)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildActionButton(
                              icon: Icons.arrow_downward,
                              label: 'Receive'.tr, // '接收'
                              backgroundColor: Colors.green, // 背景色调整
                              iconColor: Colors.white, // 图标颜色保持白色以确保对比度
                              labelColor: Colors.black87, // 标签文本颜色改为黑色系
                              onTap: () {
                                // TODO: Implement Receive action
                              },
                            ),
                            const SizedBox(width: 40),
                            _buildActionButton(
                              icon: Icons.arrow_upward,
                              label: 'Send'.tr, // '发送'
                              backgroundColor: Colors.blue, // 背景色调整
                              iconColor: Colors.white, // 图标颜色保持白色以确保对比度
                              labelColor: Colors.black87, // 标签文本颜色改为黑色系
                              onTap: () {
                                // TODO: Implement Send action
                                // 跳转到代币选择页面
                                final selectedToken = Get.toNamed(
                                  AppRoutes.TokenSelection,
                                );

                                // if (selectedToken != null && selectedToken is YourTokenInfoClass) {
                                //   // 用户选择了代币，现在跳转到发送页面，并传递代币信息
                                //   Get.toNamed(AppRoutes.TokenSend, arguments: {'tokenInfo': selectedToken});
                                // } else {
                                //   // 用户可能没有选择代币就返回了
                                //   print("Token selection cancelled or no token selected.");
                                // }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Tokens Section Title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tokens'.tr, // '代币'
                            style: const TextStyle(
                              color: Colors.black, // 文本颜色改为黑色
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 20,
                        ), // 分割线颜色调整
                        // Token List (Example with EGT)
                        // TODO: Replace with a dynamic list of tokens
                        _buildTokenItem(
                          icon: Icons.token, // Placeholder icon
                          tokenName: 'EGT',
                          tokenBalance:
                              '${controller.egtBalance.value.toStringAsFixed(2)} EGT',
                          usdValue: '≈ 0.00 USD', // Placeholder
                          iconColor: Colors.deepPurpleAccent, // 图标颜色调整
                        ),
                        // Add more token items here or use ListView.builder if many tokens

                        // Conditional Create Wallet Button (if needed, adjust styling)
                        if (controller.walletAddress.value ==
                            'Wallet Not Connected')
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: controller.createWallet,
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.white, // 图标颜色保持白色
                              ),
                              label: Text(
                                'Create Wallet'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                ), // 文本颜色保持白色
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color labelColor, // 新增标签颜色参数
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 14), // 使用传入的标签颜色
        ),
      ],
    );
  }

  // Helper widget for token list items
  Widget _buildTokenItem({
    required IconData icon,
    required String tokenName,
    required String tokenBalance,
    required String usdValue,
    Color iconColor = Colors.black, // 默认图标颜色改为黑色
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200], // 背景色调整
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        tokenName,
        style: const TextStyle(
          color: Colors.black, // 文本颜色改为黑色
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        tokenBalance,
        style: const TextStyle(color: Colors.black87), // 文本颜色改为黑色系
      ),
      trailing: Text(
        usdValue,
        style: TextStyle(color: Colors.grey[700]),
      ), // 文本颜色调整
      onTap: () {
        // TODO: Navigate to token details page
      },
    );
  }
}
