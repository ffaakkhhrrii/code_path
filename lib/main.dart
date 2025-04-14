import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/firebase_options.dart';
import 'package:code_path/features/presentation/page/admin_menu/add_news_page.dart';
import 'package:code_path/features/presentation/page/admin_menu/add_path_page.dart';
import 'package:code_path/features/presentation/page/detail_news_page.dart';
import 'package:code_path/features/presentation/page/detail_path_page.dart';
import 'package:code_path/features/presentation/page/home_page.dart';
import 'package:code_path/features/presentation/page/login/signin_page.dart';
import 'package:code_path/features/presentation/page/signup/signup_page.dart';
import 'package:code_path/features/presentation/page/splash_page.dart';
import 'package:code_path/injection_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDependencies();
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
        AppRoute.signin: (context)=> const SigninPage(),
        AppRoute.home: (context)=> HomePage(),
        AppRoute.detailRoles: (context)=> const DetailPathPage(),
        AppRoute.detailNews: (context)=> const DetailNewsPage(),
        AppRoute.addNews: (context)=> const AddNewsPage(),
        AppRoute.addPath: (context) => const AddPathPage()
      },
    );
  }
}