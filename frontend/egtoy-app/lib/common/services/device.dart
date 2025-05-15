import 'package:egtoy/common/entities/entities.dart';

class DeviceService {
  // 模拟获取设备列表
  Future<List<Device>> getDevices() async {
    // 这里模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 返回模拟数据
    return [
      Device(
        id: '1',
        name: 'Smart Watch',
        type: 'Wearable',
        status: 'Connected',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastConnectedAt: DateTime.now(),
      ),
      Device(
        id: '2',
        name: 'Home Sensor',
        type: 'IoT',
        status: 'Offline',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastConnectedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Device(
        id: '3',
        name: 'Smart Display',
        type: 'Display',
        status: 'Connected',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastConnectedAt: DateTime.now(),
      ),
    ];
  }

  // 根据ID获取设备
  Future<Device> getDeviceById(String id) async {
    final devices = await getDevices();
    return devices.firstWhere((device) => device.id == id);
  }

  // 添加设备
  Future<bool> addDevice(Device device) async {
    // 模拟添加设备的API调用
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // 更新设备
  Future<bool> updateDevice(Device device) async {
    // 模拟更新设备的API调用
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // 删除设备
  Future<bool> deleteDevice(String id) async {
    // 模拟删除设备的API调用
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
