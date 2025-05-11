import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/services/services.dart';
import 'page/wallet/controller.dart';
import 'page/home_page.dart';
import 'common/langs/app_translations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化服务
  final blockchainManager = BlockchainManager(devnet: true);
  Get.put(blockchainManager);

  // 初始化控制器
  Get.put(WalletController(blockchainManager: blockchainManager));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EGTOY',

      // 添加翻译
      translations: AppTranslations(),

      // 默认语言为英文
      locale: const Locale('en', 'US'),

      // 备用语言
      fallbackLocale: const Locale('en', 'US'),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      defaultTransition: Transition.fade,
      builder: EasyLoading.init(),
    );
  }
}
