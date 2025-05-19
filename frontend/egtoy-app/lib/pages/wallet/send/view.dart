import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class TokenSendPage extends GetView<TokenSendController> {
  const TokenSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(TokenSendController()); // 或通过Binding

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text('Send ${controller.selectedToken.symbol}'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  // 模拟代币图标
                  radius: 40,
                  child: Text(
                    controller.selectedToken.symbol,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  labelText: 'Recipient Solana Devnet Address'.tr,
                  // suffixIcon: IconButton(icon: Icon(Icons.alternate_email), onPressed: () { /* TODO: Open address book or QR scanner */ }),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount'.tr,
                  suffixText: controller.selectedToken.symbol,
                  suffixIcon: TextButton(
                    onPressed: controller.setMaxAmount,
                    child: Text('Max'.tr),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.memoController,
                decoration: InputDecoration(
                  labelText: 'Memo (Optional)'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Obx(() {
                if (controller.errorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              Obx(
                () =>
                    controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: Text('Cancel'.tr),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.sendTransaction,
                                child: Text('Next'.tr),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
