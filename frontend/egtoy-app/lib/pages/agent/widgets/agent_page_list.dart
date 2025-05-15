import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../index.dart';
import 'widgets.dart';

class AgentPageList extends StatefulWidget {
  AgentPageList({Key? key}) : super(key: key);

  @override
  _AgentPageListState createState() => _AgentPageListState();
}

class _AgentPageListState extends State<AgentPageList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final controller = Get.find<AgentController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetX<AgentController>(
      init: controller,
      builder:
          (controller) => SmartRefresher(
            enablePullUp: true,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((content, index) {
                      var item = controller.state.agentList[index];
                      return agentListItem(item);
                    }, childCount: controller.state.agentList.length),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
