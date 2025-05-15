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

  /// 成员变量
  String categoryCode = '';
  int curPage = 1;
  int pageSize = 20;
  int total = 20;

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
    if (state.agentList.length < total) {
      fetchAgentList()
          .then((_) {
            refreshController.loadComplete();
          })
          .catchError((_) {
            refreshController.loadFailed();
          });
    } else {
      refreshController.loadNoData();
    }
  }

  // 方法

  // 拉取数据
  Future<void> fetchAgentList({bool isRefresh = false}) async {
    var agents = await AgentAPI.agentPageList();
    print(agents);

    // var result = await NewsAPI.newsPageList(
    //   params: NewsPageListRequestEntity(
    //     categoryCode: categoryCode,
    //     pageNum: curPage + 1,
    //     pageSize: pageSize,
    //   ),
    // );

    if (isRefresh == true) {
      //curPage = 1;
      //total = result.counts!;
      state.agentList.clear();
    } else {
      curPage++;
    }

    state.agentList.addAll(agents.data!);
  }

  /// 生命周期

  ///dispose 释放内存
  @override
  void dispose() {
    super.dispose();
    // dispose 释放对象
    refreshController.dispose();
  }
}
