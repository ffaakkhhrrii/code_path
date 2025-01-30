import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_route.dart';
import 'package:code_path/config/session.dart';
import 'package:code_path/firebase_options.dart';
import 'package:code_path/page/detail_news_page.dart';
import 'package:code_path/page/home_page.dart';
import 'package:code_path/page/signin_page.dart';
import 'package:code_path/page/signup_page.dart';
import 'package:code_path/page/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('en_US');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
        scaffoldBackgroundColor: AppColor.backgroundScaffold,
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary
        )
      ),
      initialRoute: AppRoute.splash,
      routes: {
        AppRoute.splash : (context) => const SplashPage(),
        AppRoute.signup: (context)=> const SignupPage(),
        AppRoute.signin: (context)=> SigninPage(),
        AppRoute.home: (context)=> HomePage(),
        AppRoute.detailRoles: (context)=> HomePage(),
        AppRoute.detailNews: (context)=> DetailNewsPage(),
      },
    );
  }
}