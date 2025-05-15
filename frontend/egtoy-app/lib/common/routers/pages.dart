import 'package:egtoy/pages/wallet/home/index.dart';
import 'package:egtoy/pages/wallet/import/index.dart';
import 'package:flutter/material.dart';
import 'package:egtoy/common/middlewares/middlewares.dart';
import 'package:egtoy/pages/application/index.dart';
import 'package:egtoy/pages/agent/index.dart';
import 'package:egtoy/pages/frame/sign_in/index.dart';
import 'package:egtoy/pages/frame/sign_up/index.dart';
import 'package:egtoy/pages/frame/welcome/index.dart';
import 'package:egtoy/pages/wallet/import/index.dart';
import 'package:egtoy/pages/wallet/home/index.dart';
import 'package:get/get.dart';

import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // 免登陆
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      // middlewares: [RouteWelcomeMiddleware(priority: 1)],
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      // middlewares: [RouteAuthMiddleware(priority: 1)],
    ),
    // agent列表
    GetPage(
      name: AppRoutes.Agent,
      page: () => AgentPage(),
      binding: CategoryBinding(),
    ),
    // wallet列表
    GetPage(
      name: AppRoutes.Wallet,
      page: () => ImportWalletPage(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: AppRoutes.WalletHome,
      page: () => WalletHomePage(),
      binding: WalletBinding(),
    ),
  ];
}
