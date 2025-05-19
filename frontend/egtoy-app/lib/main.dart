import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:egtoy/common/services/services.dart';
import 'pages/wallet/home/controller.dart';
import 'pages/wallet/home/view.dart';
import 'common/langs/app_translations.dart';
import 'package:egtoy/common/langs/app_translations.dart';
import 'package:egtoy/common/routers/pages.dart';
import 'package:egtoy/common/store/store.dart';
import 'package:egtoy/common/style/style.dart';
import 'package:egtoy/common/utils/utils.dart';
import 'package:egtoy/global.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();
  ConfigStore.to.onInitLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'EGTOY',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          builder: EasyLoading.init(),

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
          locale: ConfigStore.to.locale,
          fallbackLocale: const Locale('en', 'US'),
          translations: AppTranslations(),
          enableLog: true,
          logWriterCallback: Logger.write,
        );
      },
    );
  }
}
