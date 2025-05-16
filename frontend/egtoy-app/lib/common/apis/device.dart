import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/common/values/values.dart';

class DeviceAPI {
  /// 翻页
  /// refresh 是否刷新
  static Future<DeviceListResponseEntity> deviceBindList({
    String? agentId,
    bool refresh = false,
    bool cacheDisk = false,
  }) async {
    var response = await HttpUtil().get(
      '/device/bind/${agentId}',
      refresh: refresh,
      cacheDisk: cacheDisk,
      cacheKey: STORAGE_INDEX_AGENT_CACHE_KEY,
    );
    print(response);
    return DeviceListResponseEntity.fromJson(response);
  }
}
