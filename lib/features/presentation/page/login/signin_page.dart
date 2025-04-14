import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/features/presentation/bloc/login/login_bloc.dart';
import 'package:code_path/features/presentation/bloc/login/login_event.dart';
import 'package:code_path/features/presentation/bloc/login/login_state.dart';
import 'package:code_path/features/presentation/widget/base_button.dart';
import 'package:code_path/features/presentation/widget/dialog.dart';
import 'package:code_path/injection_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  IconData _suffixIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(s1()),
      child: Scaffold(
        body: _bodyLogin(context),
      ),
    );
  }

  _bodyLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Code Path',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 40),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              validator: (value) => value == '' ? 'Email harus diisi' : null,
              controller: emailController,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.secondary)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              validator: (value) => value == '' ? 'Password harus diisi' : null,
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // Toggle nilai obscureText
                        _suffixIcon = _isObscure
                            ? Icons.visibility_off // Jika disembunyikan
                            : Icons.visibility; // Jika terlihat
                      });
                    },
                    icon: Icon(_suffixIcon)),
                isDense: true,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.secondary)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
              return BaseButton(
                label: 'Login',
                onTap: () {
                  context.read<LoginBloc>().add(Login(
                      email: emailController.text,
                      password: passwordController.text));
                },
                isExpand: true,
              );
            }, listener: (context, state) {

              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state is LoginLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showDialog(
                        context: context,
                        builder: (context) => const BasicDialog(
                              message: "Loading",
                              isLoading: true,
                        ));
                  }
                });
              }

              if (state is LoginSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 1), () {
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AppRoute.home, (route) => false);
                            }
                          });
                          return BasicDialog(
                            message: state.result!,
                          );
                        });
                  }
                });
              }

              if (state is LoginFailed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 1), () {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          });
                          return BasicDialog(
                            message: state.error.toString(),
                          );
                        });
                  }
                });
              }
            }),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Tidak punya akun?',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 15, color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            BaseButton(
              label: 'Daftar',
              onTap: () {
                Navigator.pushNamed(context, AppRoute.signup);
              },
              isExpand: true,
            ),
          ],
        ),
      ),
    );
  }
}
