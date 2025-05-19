import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart'; // 确保导入

class TokenSelectionPage extends GetView<TokenSelectionController> {
  const TokenSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 确保 Controller 已通过 Binding 注册
    // Get.put(TokenSelectionController()); // 或者在 Binding 中处理

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Token'.tr),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(), // 关闭选择界面，不返回任何结果
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search...'.tr,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.filteredTokens.isEmpty) {
                return Center(child: Text('No tokens found'.tr));
              }
              return ListView.builder(
                itemCount: controller.filteredTokens.length,
                itemBuilder: (context, index) {
                  final token = controller.filteredTokens[index];
                  return ListTile(
                    // leading: token.iconUrl != null ? Image.network(token.iconUrl!, width: 40, height: 40) : CircleAvatar(child: Text(token.symbol.substring(0,1))),
                    leading: CircleAvatar(
                      child: Text(
                        token.symbol.length > 1
                            ? token.symbol.substring(0, 2)
                            : token.symbol,
                      ),
                    ), // 简易图标
                    title: Text(token.name),
                    subtitle: Text('${token.balance} ${token.symbol}'),
                    onTap: () => controller.selectToken(token),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
