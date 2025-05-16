import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:egtoy/common/values/values.dart';
import 'index.dart';
import 'widgets/widgets.dart';

class AgentPage extends GetView<AgentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent'.tr), //国际化
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: AgentPageList(),
    );
  }
}
