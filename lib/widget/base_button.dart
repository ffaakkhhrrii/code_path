import 'package:code_path/config/app_color.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.isExpand,
      this.bg,
      this.txt,
      this.height,
      this.fontSize});

  final String label;
  final Function onTap;
  final bool? isExpand;
  final Color? bg;
  final Color? txt;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      child: Material(
        color: bg ?? AppColor.secondary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Container(
            width: isExpand == null
                ? null
                : isExpand!
                    ? double.infinity
                    : null,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize?? 18,
                  color: txt ?? AppColor.backgroundScaffold),
            ),
          ),
        ),
      ),
    );
  }
}
