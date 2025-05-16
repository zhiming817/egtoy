import 'package:egtoy/common/services/device.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/apis/apis.dart';
import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class DeviceController extends GetxController {
  final DeviceService repository = DeviceService();

  //final devices = <Device>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  String? agentId;
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );
  final state = DeviceState();

  void onRefresh() {
    fetchDevices(isRefresh: true)
        .then((_) {
          refreshController.refreshCompleted(resetFooterState: true);
        })
        .catchError((_) {
          refreshController.refreshFailed();
        });
  }

  void onLoading() {
    fetchDevices()
        .then((_) {
          refreshController.loadComplete();
        })
        .catchError((_) {
          refreshController.loadFailed();
        });
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      // 因为你传递的是一个 Map: {'agentId': item.id}
      // 所以这里也需要按 Map 的方式来取值
      agentId = Get.arguments['agentId'];
    }
    fetchDevices();
  }

  @override
  void dispose() {
    super.dispose();
    // dispose 释放对象
    refreshController.dispose();
  }

  // 获取所有设备
  Future<void> fetchDevices({bool isRefresh = false}) async {
    var devices = await DeviceAPI.deviceBindList(agentId: agentId);
    print(devices);

    if (isRefresh == true) {
      state.deviceList.clear();
    }

    state.deviceList.addAll(devices.data!);
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
}
