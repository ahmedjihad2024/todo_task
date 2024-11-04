
import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/res/color_manager.dart';

import '../../../../common/custom_form_field.dart';

class CustomForm extends StatelessWidget {
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
  final double? height;
  final double? width;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final TextStyle? hintStyle;
  final int maxLines;
  final TextInputAction? textInputAction;

  const CustomForm({
    super.key,
    this.securityController,
    this.height,
    this.width,
    this.alignment,
    this.padding,
    this.maxLines = 1,
    this.textInputAction,
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
      height: height,
      width: width,
      controller: securityController,
      maxLines: maxLines,
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
      padding: padding,
      textInputAction: textInputAction,
      isPhoneForm: false,
      obscureText: obscureText,
      focusNode: focusNode,
      label: label,
      keyboardType: keyboardType,
      hintText: hintText,
      validator: validator,
      alignment: alignment ?? Alignment.center,
      validatorStyle: context.small.copyWith(
          fontSize: 15.sp,
          color: ColorManager.red,
        fontWeight: FontWeight.w500
      ),
      textStyle: context.small.copyWith(
        fontSize: desktopSize(size(mobile: 16.sp, tablet: 14.sp), 14),
        color: ColorManager.black,
        fontWeight: FontWeight.w500
      ),
      hintStyle: hintStyle ??
          context.small.copyWith(
            fontSize: desktopSize(size(mobile: 16.sp, tablet: 14.sp), 14),
            color: ColorManager.black.withOpacity(.4),
          ),
      textEditingController: controller,
      sufixWidget: suffixWidget,
    );
  }
}