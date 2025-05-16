import 'package:egtoy/common/apis/apis.dart';
import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class AgentController extends GetxController {
  AgentController();

  /// UI 组件
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  /// 响应式成员变量
  final state = AgentState();

  /// 事件

  void onRefresh() {
    fetchAgentList(isRefresh: true)
        .then((_) {
          refreshController.refreshCompleted(resetFooterState: true);
        })
        .catchError((_) {
          refreshController.refreshFailed();
        });
  }

  void onLoading() {
    fetchAgentList()
        .then((_) {
          refreshController.loadComplete();
        })
        .catchError((_) {
          refreshController.loadFailed();
        });
  }

  // 方法

  // 拉取数据
  Future<void> fetchAgentList({bool isRefresh = false}) async {
    var agents = await AgentAPI.agentPageList();
    print(agents);

    if (isRefresh == true) {
      state.agentList.clear();
    }

    state.agentList.addAll(agents.data!);
  }

  ///dispose 释放内存
  @override
  void dispose() {
    super.dispose();
    // dispose 释放对象
    refreshController.dispose();
  }
}
