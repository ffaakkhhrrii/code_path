// ignore_for_file: use_build_context_synchronously

import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_route.dart';
import 'package:code_path/controller/c_user.dart';
import 'package:code_path/source/user_source.dart';
import 'package:code_path/widget/base_button.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void login(BuildContext context){
    if(formKey.currentState!.validate()){
      UserSource.signIn(emailController.text, passwordController.text).then((response){
        if(response['success']){
          DInfo.dialogSuccess(context,response['message']);
            DInfo.closeDialog(
            context,
            actionAfterClose: (){
              Navigator.pushReplacementNamed(context, AppRoute.home);
            }
          );
        }else{
           DInfo.dialogError(context,response['message']);
           DInfo.closeDialog(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                validator: (value)=> value == '' ? 'Email harus diisi':null,
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
                validator: (value)=> value == '' ? 'Password harus diisi':null,
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
              BaseButton(label: 'Login', onTap: (){
                login(context);
              },isExpand: true,),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Tidak punya akun?',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 15,color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12,),
              BaseButton(label: 'Daftar', onTap: (){
                Navigator.pushNamed(context, AppRoute.signup);
              },isExpand: true,),
            ],
          ),
        ),
      ),
    );
  }
}