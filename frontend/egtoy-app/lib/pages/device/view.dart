import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/entities/entities.dart'; // 确保导入Device实体
import 'package:intl/intl.dart'; // 如果您使用了DateFormat
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'controller.dart'; // 导入您的DeviceController

class DeviceListView extends GetView<DeviceController> {
  const DeviceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 添加 Scaffold
      appBar: AppBar(
        // 添加 AppBar
        leading: IconButton(
          // 添加返回按钮
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ), // 您可以自定义图标和颜色
          onPressed: () => Get.back(), // 点击时返回上一页
        ),
        title: const Text(
          'Devices', // AppBar 标题
          style: TextStyle(color: Colors.black), // 您可以自定义样式
        ),
        backgroundColor: Colors.white, // AppBar 背景色
        elevation: 0.5, // AppBar 阴影
        scrolledUnderElevation: 1, // 滑动时 AppBar 的阴影
      ),
      body: SafeArea(
        // SafeArea 保持在AppBar下方
        child: Column(
          children: [
            // _buildSearchBar(), // 如果您有搜索栏
            _buildTableHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.state.deviceList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.state.deviceList.isEmpty) {
                  return const Center(child: Text('没有找到设备'));
                }
                // return ListView.builder(
                //   itemCount: controller.state.deviceList.length,
                //   itemBuilder: (context, index) {
                //     final device = controller.state.deviceList[index];
                //     return _buildDeviceItem(context, device);
                //   },
                // );
                // 如果您使用 SmartRefresher，请确保它在这里
                return SmartRefresher(
                  controller: controller.refreshController,
                  enablePullUp: true, // 根据需要启用上拉加载
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading, // 如果实现了分页加载
                  header: const WaterDropHeader(), // 或其他刷新头部
                  // footer: ClassicFooter(), // 或其他加载更多尾部
                  child: ListView.builder(
                    itemCount: controller.state.deviceList.length,
                    itemBuilder: (context, index) {
                      final device = controller.state.deviceList[index];
                      return _buildDeviceItem(context, device);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ... _buildSearchBar, _buildTableHeader, _headerText, _buildDeviceItem 方法保持不变 ...
  // 确保这些辅助方法存在于您的视图文件中

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100], // 表头背景色
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _headerText('Name')),
          Expanded(flex: 2, child: _headerText('Version')),
          Expanded(flex: 2, child: _headerText('MAC')),

          SizedBox(
            width: 100,
            child: _headerText('Action', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text, {TextAlign textAlign = TextAlign.left}) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      ),
      textAlign: textAlign,
    );
  }

  Widget _buildDeviceItem(BuildContext context, Device device) {
    final DateFormat formatter = DateFormat('yy-MM-dd HH:mm');
    // int isAutoUpdate = device.autoUpdate;

    return InkWell(
      onTap: () {
        // Get.toNamed(AppRoutes.DeviceDetail, arguments: {'deviceId': device.id});
        print("Tapped on device: ${device.id}");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(device.board, style: const TextStyle(fontSize: 13)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                device.appVersion,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(device.id, style: const TextStyle(fontSize: 13)),
            ), // Assuming id is macAddress for now
            // Placeholder for alias
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // controller.showUnbindConfirmation(context, device.id);
                      print("Unbind device: ${device.id}");
                    },
                    child: const Text(
                      'Unbind',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
