import 'package:flutter/material.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import 'custom_form_field.dart';
import '../res/color_manager.dart';

class PhoneForm extends StatelessWidget {
  final TextEditingController controller;
  final Function(CountryCode) countryCode;
  final String? Function(String)? validator;
  final FocusNode? focusNode;
  final Widget? label;
  final int? textLength;
  final bool showCountryCode;

  const PhoneForm({
    super.key,
    required this.controller,
    required this.countryCode,
    this.focusNode,
    this.validator,
    this.label,
    this.textLength,
    this.showCountryCode = true
  });

  @override
  Widget build(BuildContext context) {
    return NiceTextForm(
      height: desktopSize(50.w, 55),
      isPhoneForm: true,
      width: desktopSize(double.infinity, 300),
      showCountryCode: showCountryCode,
      textLength: textLength,
      initialSelectionFlag: "EG",
      focusNode: focusNode,
      label: label,
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
      keyboardType: TextInputType.number,
      hintText: "123 456-7890",
      validator: validator,
      validatorStyle: context.small.copyWith(
        fontSize: 15.sp,
        color: ColorManager.red,
      ),
      textStyle: context.small.copyWith(
        fontSize:  desktopSize(16.sp, 14),
        color: ColorManager.black,
      ),
      hintStyle: context.small.copyWith(
        fontSize: desktopSize(16.sp, 14),
        color: ColorManager.black.withOpacity(.4),
      ),

      textEditingController: controller,
      countryCode: countryCode,
      // sufixWidget: SvgPicture.asset(
      //   AppSvg.call,
      //   width:  25.w,
      // ),
    );
  }
}