import 'package:egtoy/pages/my/view.dart';
import 'package:flutter/material.dart';
import 'package:egtoy/common/values/values.dart';
import 'package:egtoy/common/widgets/widgets.dart';
import 'package:egtoy/pages/agent/index.dart';
import 'package:egtoy/pages/main/index.dart';
import 'package:egtoy/pages/my/index.dart';
import 'package:egtoy/pages/wallet/home/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationPage extends GetView<ApplicationController> {
  // 顶部导航
  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Obx(
        () => Text(
          controller.tabTitles[controller.state.page],
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: 'Montserrat',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: AppColors.primaryText),
          onPressed: () {},
        ),
      ],
    );
  }

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        AgentPage(),
        WalletHomePage(),
        Text('BookmarksPage'),
        MyPage(),
      ],
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
    );
  }

  // 底部导航
  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        items: controller.bottomTabs,
        currentIndex: controller.state.page,
        // fixedColor: AppColors.primaryElement,
        type: BottomNavigationBarType.fixed,
        onTap: controller.handleNavBarTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
