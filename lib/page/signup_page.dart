// ignore_for_file: use_build_context_synchronously

import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_route.dart';
import 'package:code_path/controller/c_roles.dart';
import 'package:code_path/model/roles.dart';
import 'package:code_path/model/users.dart';
import 'package:code_path/source/user_source.dart';
import 'package:code_path/widget/base_button.dart';
import 'package:d_info/d_info.dart';
import 'package:code_path/model/progress_user.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final cRoles = Get.put(CRoles());


  String? selectedRole;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final instituteController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  IconData _suffixIcon = Icons.visibility_off;

  signUp(BuildContext context,Roles role){
    if(formKey.currentState!.validate()){
      var users = Users(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        username: usernameController.text,
        role: selectedRole,
        isAdmin: false,
        institute: instituteController.text
      );
      UserSource.signUp(users,role).then((response){
        if(response['success']){
          DInfo.dialogSuccess(context,response['message']);
            DInfo.closeDialog(
            context,
            actionAfterClose: (){
              Navigator.pushReplacementNamed(context, AppRoute.signin);
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
  void initState() {
    cRoles.getListRoles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: const Text(
            'Sign Up',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: GetBuilder<CRoles>(builder: (items) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      baseTextFormField('Email', emailController),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        validator: (value) =>
                            value == '' ? 'Password harus diisi' : null,
                        controller: passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure =
                                      !_isObscure; // Toggle nilai obscureText
                                  _suffixIcon = _isObscure
                                      ? Icons
                                          .visibility_off // Jika disembunyikan
                                      : Icons.visibility; // Jika terlihat
                                });
                              },
                              icon: Icon(_suffixIcon)),
                          isDense: true,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColor.secondary)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      baseTextFormField('Name', nameController),
                      const SizedBox(
                        height: 24,
                      ),
                      baseTextFormField('Username', usernameController),
                      const SizedBox(
                        height: 24,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: Text(
                            'Pilih Role',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items.listRoles
                              .map((role) => DropdownMenuItem<String>(
                                    value: role.id!,
                                    child: Text(role.name!),
                                  ))
                              .toList(),
                          value: selectedRole,
                          onSaved: (String? value) {
                            selectedRole = value;
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return "Role harus diisi";
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            items.getDataRole(value!);
                            setState(() {
                              selectedRole = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      baseTextFormField('Instansi', instituteController),
                      const SizedBox(
                        height: 24,
                      ),
                      BaseButton(
                        label: 'Signup',
                        onTap: () {
                          signUp(context,items.dataRole);
                        },
                        isExpand: true,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }

  TextFormField baseTextFormField(
      String name, TextEditingController controller) {
    return TextFormField(
      validator: (value) => value == '' ? '$name harus diisi' : null,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: name,
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
    );
  }
}
