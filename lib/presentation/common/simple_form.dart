
import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/res/color_manager.dart';

import 'custom_form_field.dart';

class SimpleForm extends StatelessWidget {
  final TextEditingController controller;
  final SecurityController? securityController;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final Widget Function(bool)? suffixWidget;
  final Widget? prefixWidget;
  final bool? obscureText;
  final Widget? label;
  final int? textLength;

  final TextStyle? hintStyle;

  const SimpleForm({
    super.key,
    this.securityController,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    this.focusNode,
    this.validator,
    this.suffixWidget,
    this.obscureText,
    this.prefixWidget,
    this.textLength,
    this.hintStyle,
    this.label
  });

  @override
  Widget build(BuildContext context) {
    return NiceTextForm(
      prefixWidget: prefixWidget,
      height: desktopSize(50.w, 55),
      width: desktopSize(double.infinity, 300),
      controller: securityController,
      boxDecoration: BoxDecoration(
          color: context.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
              color: context.colorScheme.onPrimary.withOpacity(.2),
              width: .5
          )
      ),
      activeBoxDecoration:  BoxDecoration(
        color: context.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
            color: context.colorScheme.onPrimary,
            width: .5
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: desktopSize(13.w, 15)
      ),
      isPhoneForm: false,
      obscureText: obscureText,
      focusNode: focusNode,
      label: label,
      keyboardType: keyboardType,
      hintText: hintText,
      validator: validator,
      validatorStyle: context.small.copyWith(
          fontSize: 15.sp,
          color: ColorManager.red
      ),
      textStyle: context.small.copyWith(
        fontSize: desktopSize(16.sp, 14),
        color: ColorManager.black,
      ),
      hintStyle: hintStyle ??
          context.small.copyWith(
            fontSize: desktopSize(16.sp, 14),
            color: ColorManager.black.withOpacity(.4),
          ),
      textEditingController: controller,
      sufixWidget: suffixWidget,
    );
  }
}