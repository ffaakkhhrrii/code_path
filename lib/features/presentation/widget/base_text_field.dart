import 'package:code_path/core/config/app_color.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
const BaseTextField({
  super.key,
  required this.name,
  required this.controller,
  this.type
});

final String name;
final TextEditingController controller;
final TextInputType? type;

  @override
  Widget build(BuildContext context){
    return TextFormField(
      validator: (value) => value == '' ? '$name harus diisi' : null,
      controller: controller,
      keyboardType: type,
      maxLines: type == TextInputType.multiline ? null : 1,
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