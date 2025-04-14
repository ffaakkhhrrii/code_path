import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/users.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_bloc.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_event.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/presentation/widget/base_button.dart';
import 'package:code_path/injection_app.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? selectedRole;
  Roles? selectedDataRole;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final instituteController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  IconData _suffixIcon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => s1()..add(const ShowRole()),
      child: Scaffold(
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
          body: _bodySignUp(context)),
    );
  }

  _bodySignUp(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _formSignUp(context),
        ),
      ],
    );
  }

  Form _formSignUp(BuildContext context) {
    return Form(
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
          baseTextFormField('Name', nameController),
          const SizedBox(
            height: 24,
          ),
          baseTextFormField('Username', usernameController),
          const SizedBox(
            height: 24,
          ),
          BlocBuilder<SignUpBloc, SignUpState>(builder: (_, state) {
            if (state.roles is DataSuccess) {
              return _dropdownRoles(context, state.roles!.data!);
            } else {
              return const SizedBox();
            }
          }),
          const SizedBox(
            height: 24,
          ),
          baseTextFormField('Instansi', instituteController),
          const SizedBox(
            height: 24,
          ),
          BlocConsumer<SignUpBloc, SignUpState>(builder: (context, state) {
            return BaseButton(
              label: 'Signup',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  var users = Users(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nameController.text,
                      username: usernameController.text,
                      role: selectedRole,
                      isAdmin: false,
                      institute: instituteController.text);

                  context
                      .read<SignUpBloc>()
                      .add(SignUp(users: users, roles: selectedDataRole!));
                }
              },
              isExpand: true,
            );
          }, listener: (context, state) {
            if (state is SignUpLoading) {
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

            if (state is SignUpSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoute.signin, (route) => false);
                          }
                        });
                        return BasicDialog(
                          message: state.result!,
                        );
                      });
                }
              });
            }

            if (state is SignUpFailed) {
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
        ],
      ),
    );
  }

  _dropdownRoles(BuildContext context, List<Roles> items) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
        items: items
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
          var role = items.firstWhere((role) => role.id == value);
          setState(() {
            selectedDataRole = role;
            selectedRole = value;
          });
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
    );
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
