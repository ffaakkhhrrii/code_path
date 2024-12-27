import 'package:code_path/config/app_route.dart';
import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/session.dart';
import 'package:code_path/model/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final user = await Session.getUser();
      if (user == null || user.id == null) {
        Navigator.pushReplacementNamed(context, AppRoute.signin);
      } else {
        Navigator.pushReplacementNamed(context, AppRoute.home);
      }
    }
    );


    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Code Path',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 40),
            ),
            const Spacer(),
            const CircularProgressIndicator(
              color: AppColor.secondary,
            ),
            const SizedBox(
              height: 46,
            ),
          ],
        ),
      ),
    );
  }
}
