


import 'package:flutter/material.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../../../app/enums.dart';
import '../../../../common/custom_form_field.dart';
import '../../../../common/overlay_loading.dart';
import '../../../../common/phone_form.dart';
import '../../../../common/simple_form.dart';
import '../../../../res/assets_manager.dart';
import '../../../../res/translations_manager.dart';

class SignUpPhoneStyle extends StatelessWidget {
  final TextEditingController numberController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final SecurityController securityController;
  final FocusNode numberFocus;
  final FocusNode passwordFocus;
  final FocusNode nameFocus;
  final FocusNode addressFocus;
  final String? selectedExperienceLevel;
  final int? selectedYearExperience;
  final Function(String code) onCountryCodeChnage;
  final Function(String? level) onSelectingExperienceLevel;
  final Function(int? years) onSelectingExperienceYears;
  final Function() onClick;
  const SignUpPhoneStyle({
    super.key,
    required this.securityController,
    required this.passwordFocus,
    required this.passwordController,
    required this.numberController,
    required this.numberFocus,
    required this.nameController,
    required this.selectedExperienceLevel,
    required this.selectedYearExperience,
    required this.addressController,
    required this.addressFocus,
    required this.nameFocus,
    required this.onCountryCodeChnage,
    required this.onClick,
    required this.onSelectingExperienceLevel,
    required this.onSelectingExperienceYears
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImagesManager.art,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: deviceDetails.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Translation.sign_in.tr,
                    style: context.small.copyWith(
                        fontSize: 33.sp,
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onPrimary),
                  ),
                  SizedBox(
                    height: size(mobile: 20.w, tablet: 15.w),
                  ),
                  SimpleForm(
                    focusNode: nameFocus,
                    hintText: Translation.name.tr,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  SizedBox(
                    height: size(mobile: 10.w, tablet: 5.w),
                  ),
                  PhoneForm(
                    focusNode: numberFocus,
                    controller: numberController,
                    countryCode: (CountryCode code) {
                      onCountryCodeChnage(code.dialCode);
                    },
                  ),
                  SizedBox(
                    height: size(mobile: 10.w, tablet: 5.w),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: size(mobile: 50.w, tablet: 35.w),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                              context.colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(size(mobile: 13.r, tablet: 8.r)),
                              border: Border.all(
                                  color: context.colorScheme.onPrimary
                                      .withOpacity(.2),
                                  width: .5)),
                          child: DropdownButton<String>(
                            value: selectedExperienceLevel,
                            isExpanded: true,
                            hint: Text(
                              Translation.choose_experience.tr,
                              style: context.small.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.onPrimary),
                            ),
                            borderRadius: BorderRadius.circular(13.r),
                            padding:
                            EdgeInsets.symmetric(horizontal: 13.w),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: size(mobile: 40.sp, tablet: 25.sp),
                              color: context.colorScheme.onPrimary
                                  .withOpacity(.3),
                            ),
                            elevation: 16,
                            menuWidth:  size(mobile: 140.w, tablet: 100.w),
                            menuMaxHeight: .6 * deviceDetails.height,
                            style: context.small.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.onPrimary),
                            underline: Container(
                              height: 0,
                            ),
                            alignment: Alignment.centerLeft,
                            onChanged: onSelectingExperienceLevel,
                            items: ExperienceLevel.values
                                .map<DropdownMenuItem<String>>(
                                    (ExperienceLevel value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: Text(
                                      value.name,
                                      style: context.small.copyWith(
                                          fontSize: size(mobile: 18.sp, tablet: 14.sp),
                                          fontWeight: FontWeight.w400,
                                          color:
                                          context.colorScheme.onPrimary),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size(mobile: 10.w, tablet: 5.w),
                      ),
                      Container(
                        height: size(mobile: 50.w, tablet: 35.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(size(mobile: 13.r, tablet: 8.r)),
                            border: Border.all(
                                color: context.colorScheme.onPrimary
                                    .withOpacity(.2),
                                width: .5)),
                        child: DropdownButton<int>(
                          value: selectedYearExperience,
                          hint: Text(
                            Translation.years_of_experience.tr,
                            style: context.small.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.onPrimary),
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          padding: EdgeInsets.symmetric(horizontal: 13.w),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: size(mobile: 40.sp, tablet: 25.sp),
                            color: context.colorScheme.onPrimary
                                .withOpacity(.3),
                          ),
                          elevation: 16,
                          menuWidth: size(mobile: 140.w, tablet: 50.w),
                          menuMaxHeight: .6 * deviceDetails.height,
                          style: context.small.copyWith(
                              fontSize: size(mobile: 16.sp, tablet: 12.sp),
                              fontWeight: FontWeight.w400,
                              color: context.colorScheme.onPrimary),
                          underline: Container(
                            height: 0,
                          ),
                          alignment: Alignment.centerLeft,
                          onChanged: onSelectingExperienceYears,
                          items: List.generate(50, (i) => i + 1)
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: context.small.copyWith(
                                    fontSize: size(mobile: 18.sp, tablet: 14.sp),
                                    fontWeight: FontWeight.w400,
                                    color: context.colorScheme.onPrimary),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size(mobile: 10.w, tablet: 5.w),
                  ),
                  SimpleForm(
                    focusNode: addressFocus,
                    hintText: Translation.address.tr,
                    keyboardType: TextInputType.streetAddress,
                    controller: addressController,
                  ),
                  SizedBox(
                    height: size(mobile: 10.w, tablet: 5.w),
                  ),
                  SimpleForm(
                    focusNode: passwordFocus,
                    hintText: Translation.password.tr,
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    securityController: securityController,
                    suffixWidget: (isSecure) {
                      return InkWell(
                        onTap: () {
                          if (isSecure)
                            securityController.showText();
                          else
                            securityController.hideText();
                        },
                        child: Icon(
                          isSecure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: size(mobile: 25.sp, tablet: 20.sp),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: size(mobile: 10.w, tablet: 5.w),
                  ),
                  TextButton(
                    onPressed: onClick,
                    style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, size(mobile: 50.w, tablet: 35.w))),
                        backgroundColor: WidgetStatePropertyAll(
                            context.colorScheme.primary),
                        shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10.r)))),
                    child: Text(
                      Translation.sign_up.tr,
                      style: context.small.copyWith(
                          fontSize: size(mobile: 20.sp, tablet: 15.sp),
                          fontWeight: FontWeight.w700,
                          color: context
                              .theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                  SizedBox(
                    height: size(mobile: 15.w, tablet: 10.w),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Translation.already_have_account.tr,
                        softWrap: true,
                        style: context.small.copyWith(
                            fontSize: size(mobile: 17.sp, tablet: 14.sp),
                            fontWeight: FontWeight.w400,
                            color: context.theme.colorScheme.onPrimary
                                .withOpacity(.4)),
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          Translation.sign_in.tr,
                          style: context.small.copyWith(
                              fontSize: size(mobile: 17.sp, tablet: 14.sp),
                              fontWeight: FontWeight.w600,
                              color: context.theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  35.verticalSpace
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
