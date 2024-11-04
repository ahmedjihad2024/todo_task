


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

class SignUpWindowsStyle extends StatelessWidget {
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
  const SignUpWindowsStyle({
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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagesManager.art2,
            width: 300,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(
            width: 80,
          ),
          SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      Translation.sign_in.tr,
                      style: context.small.copyWith(
                          fontSize: desktopSize(33.sp, 30),
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.onPrimary),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SimpleForm(
                  focusNode: nameFocus,
                  hintText: Translation.name.tr,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
                const SizedBox(
                  height: 5,
                ),
                PhoneForm(
                  focusNode: numberFocus,
                  controller: numberController,
                  countryCode: (CountryCode code) {
                    onCountryCodeChnage(code.dialCode);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: desktopSize(50.w, 50),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                            context.colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(13.r),
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
                                fontSize: desktopSize(14.sp, 14),
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.onPrimary),
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          padding:
                          EdgeInsets.symmetric(horizontal: desktopSize(13.w, 13)),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: desktopSize(40.sp, 25),
                            color: context.colorScheme.onPrimary
                                .withOpacity(.3),
                          ),
                          elevation: 16,
                          menuWidth: desktopSize(140.w, 150),
                          menuMaxHeight: .6 * deviceDetails.height,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 14),
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
                                        fontSize: desktopSize(18.sp, 14),
                                        fontWeight: FontWeight.w400,
                                        color:
                                        context.colorScheme.onPrimary),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: desktopSize(50.w, 50),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.colorScheme.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                                color: context.colorScheme.onPrimary
                                    .withOpacity(.2),
                                width: .5)),
                        child: DropdownButton<int>(
                          value: selectedYearExperience,
                          isExpanded: true,
                          hint: Text(
                            Translation.years_of_experience.tr,
                            softWrap: true,
                            style: context.small.copyWith(
                                fontSize: desktopSize(14.sp, 14),
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.onPrimary),
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                          padding: EdgeInsets.symmetric(horizontal: desktopSize(13.w, 13)),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: desktopSize(40.sp, 25),
                            color: context.colorScheme.onPrimary
                                .withOpacity(.3),
                          ),
                          elevation: 16,
                          menuWidth: desktopSize(140.w, 150),
                          menuMaxHeight: .6 * deviceDetails.height,
                          style: context.small.copyWith(
                              fontSize: desktopSize(16.sp, 14),
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
                                    fontSize: desktopSize(18.sp, 14),
                                    fontWeight: FontWeight.w400,
                                    color: context.colorScheme.onPrimary),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SimpleForm(
                  focusNode: addressFocus,
                  hintText: Translation.address.tr,
                  keyboardType: TextInputType.streetAddress,
                  controller: addressController,
                ),
                const SizedBox(
                  height: 5,
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
                        size: desktopSize(25.sp, 23),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: onClick,
                  style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(300, 50)),
                      backgroundColor: WidgetStatePropertyAll(
                          context.colorScheme.primary),
                      shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.r)))),
                  child: Text(
                    Translation.sign_up.tr,
                    style: context.small.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context
                            .theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Translation.already_have_account.tr,
                      softWrap: true,
                      style: context.small.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: context.theme.colorScheme.onPrimary
                              .withOpacity(.4)),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        Translation.sign_in.tr,
                        style: context.small.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
