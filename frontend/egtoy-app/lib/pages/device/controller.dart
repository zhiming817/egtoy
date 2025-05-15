import 'package:egtoy/common/services/device.dart';
import 'package:get/get.dart';

import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceController extends GetxController {
  final DeviceService repository = DeviceService();

  final devices = <Device>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDevices();
  }

  // 获取所有设备
  Future<void> fetchDevices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      devices.value = await repository.getDevices();
    } catch (e) {
      errorMessage.value = 'Failed to fetch devices: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // 根据ID获取设备详情
  Future<Device?> getDeviceById(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      return await repository.getDeviceById(id);
    } catch (e) {
      errorMessage.value = 'Failed to get device: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // 添加设备
  Future<bool> addDevice(Device device) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repository.addDevice(device);
      if (result) {
        await fetchDevices(); // 刷新设备列表
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to add device: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 更新设备
  Future<bool> updateDevice(Device device) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repository.updateDevice(device);
      if (result) {
        await fetchDevices(); // 刷新设备列表
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to update device: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 删除设备
  Future<bool> deleteDevice(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await repository.deleteDevice(id);
      if (result) {
        await fetchDevices(); // 刷新设备列表
      }
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to delete device: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 复制到剪贴板
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'success'.tr,
      'copied_to_clipboard'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
