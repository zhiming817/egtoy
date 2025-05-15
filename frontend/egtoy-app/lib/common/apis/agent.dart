import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/common/values/values.dart';

/// ai agent
class AgentAPI {
  /// 翻页
  /// refresh 是否刷新
  static Future<AgentPageListResponseEntity> agentPageList({
    AgentListRequestEntity? params,
    bool refresh = false,
    bool cacheDisk = false,
  }) async {
    var response = await HttpUtil().get(
      '/agent/list',
      queryParameters: params?.toJson(),
      refresh: refresh,
      cacheDisk: cacheDisk,
      cacheKey: STORAGE_INDEX_AGENT_CACHE_KEY,
    );
    print(response);
    return AgentPageListResponseEntity.fromJson(response);
  }
}
