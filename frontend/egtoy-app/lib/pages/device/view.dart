import 'package:egtoy/pages/device/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:egtoy/common/entities/device.dart';
// import 'package:egtoy/page/device/controller/device_controller.dart';
// import 'package:egtoy/page/device/model/device.dart';

class DeviceListView extends StatelessWidget {
  final DeviceController controller;
  const DeviceListView({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildTableHeader(context),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.devices.isEmpty) {
              return Center(
                child: Text(
                  'no_devices_found'.tr,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.devices.length,
              itemBuilder: (context, index) {
                return _buildDeviceItem(context, controller.devices[index]);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '请输入设备型号或Mac地址查询',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                // TODO: 实现搜索功能
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              // TODO: 实现搜索功能
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(width: 50, child: _headerText('选择')),
          Expanded(flex: 2, child: _headerText('设备型号')),
          Expanded(child: _headerText('固件版本')),
          Expanded(flex: 2, child: _headerText('Mac地址')),
          Expanded(flex: 2, child: _headerText('绑定时间')),
          Expanded(flex: 2, child: _headerText('最近对话')),
          Expanded(child: _headerText('备注')),
          Expanded(child: _headerText('OTA升级')),
          SizedBox(width: 80, child: _headerText('操作')),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDeviceItem(BuildContext context, Device device) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    bool isAutoUpdate =
        device.type == 'autoUpdate' && device.status == 'Connected';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Checkbox(
              value: false,
              onChanged: (value) {
                // TODO: 实现选择功能
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(device.name, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('appVersion' ?? '1.6.0', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(device.id, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatter.format(device.createdAt),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              device.lastConnectedAt != null
                  ? formatter.format(device.lastConnectedAt!)
                  : '-',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blue),
              onPressed: () {
                // TODO: 实现备注编辑功能
              },
            ),
          ),
          Expanded(
            child: Switch(
              value: isAutoUpdate,
              activeColor: Colors.green,
              onChanged: (bool value) {
                // TODO: 实现自动更新切换
              },
            ),
          ),
          SizedBox(
            width: 80,
            child: TextButton(
              child: const Text('解绑', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                _showUnbindConfirmation(context, device.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUnbindConfirmation(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('解绑确认'.tr),
          content: Text('您确定要解绑此设备吗？该操作不可撤销。'.tr),
          actions: <Widget>[
            TextButton(
              child: Text('取消'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确认解绑'.tr, style: const TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteDevice(deviceId).then((_) {
                  Get.snackbar(
                    '操作成功'.tr,
                    '设备已解绑'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}

// 设备详情视图
class DeviceDetailView extends StatelessWidget {
  final Device device;
  final DeviceController controller;

  const DeviceDetailView({
    required this.device,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('设备详情', style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  _buildInfoRow('设备型号', device.name),
                  _buildInfoRow('Mac地址', device.id),
                  _buildInfoRow('固件版本', '1.6.0'),
                  _buildInfoRow('绑定时间', formatter.format(device.createdAt)),
                  _buildInfoRow(
                    '最近对话',
                    device.lastConnectedAt != null
                        ? formatter.format(device.lastConnectedAt!)
                        : '-',
                  ),
                  _buildInfoRow(
                    'OTA自动升级',
                    device.type == 'autoUpdate' && device.status == 'Connected'
                        ? '开启'
                        : '关闭',
                  ),
                  if (device.status == 'Connected')
                    _buildInfoRow('设备状态', '在线', valueColor: Colors.green)
                  else
                    _buildInfoRow('设备状态', '离线', valueColor: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (device.id.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('操作', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('刷新设备状态'),
                          onPressed: () {
                            controller.fetchDevices();
                            Get.snackbar(
                              '操作提示',
                              '正在刷新设备状态...',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.link_off),
                          label: const Text('解除绑定'),
                          onPressed: () {
                            _showUnbindConfirmation(context, device.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: valueColor))),
        ],
      ),
    );
  }

  void _showUnbindConfirmation(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('解绑确认'),
          content: const Text('您确定要解绑此设备吗？该操作不可撤销。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认解绑', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteDevice(deviceId).then((_) {
                  Get.snackbar(
                    '操作成功',
                    '设备已解绑',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Navigator.of(context).pop(); // 返回设备列表
                });
              },
            ),
          ],
        );
      },
    );
  }
}
