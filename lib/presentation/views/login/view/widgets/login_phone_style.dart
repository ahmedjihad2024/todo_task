import 'package:flutter/material.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../../common/custom_form_field.dart';
import '../../../../common/phone_form.dart';
import '../../../../common/simple_form.dart';
import '../../../../res/assets_manager.dart';
import '../../../../res/routes_manager.dart';
import '../../../../res/translations_manager.dart';

class LoginPhoneStyle extends StatelessWidget {
  final Function() onClick;
  final Function(String code) onCountryCodeChange;
  final TextEditingController numberController;
  final TextEditingController passwordController;
  final SecurityController securityController;
  final FocusNode numberFocus;
  final FocusNode passwordFocus;

  const LoginPhoneStyle(
      {super.key,
      required this.onClick,
      required this.onCountryCodeChange,
      required this.numberController,
      required this.passwordController,
      required this.numberFocus,
      required this.passwordFocus,
      required this.securityController});

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
                    Translation.login.tr,
                    style: context.small.copyWith(
                        fontSize: size(mobile: 33.sp, tablet: 28.sp),
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.onPrimary),
                  ),
                  SizedBox(
                    height: size(mobile: 20.w, tablet: 15.w),
                  ),
                  PhoneForm(
                    focusNode: numberFocus,
                    controller: numberController,
                    countryCode: (CountryCode code) {
                      onCountryCodeChange(code.dialCode);
                    },
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
                    height: size(mobile: 15.w, tablet: 10.w),
                  ),
                  TextButton(
                    onPressed: onClick,
                    style: ButtonStyle(
                        minimumSize:
                            WidgetStatePropertyAll(Size(double.infinity, size(mobile: 50.w, tablet: 35.w))),
                        backgroundColor:
                            WidgetStatePropertyAll(context.colorScheme.primary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)))),
                    child: Text(
                      Translation.login.tr,
                      style: context.small.copyWith(
                          fontSize: size(mobile: 20.sp, tablet: 15.sp),
                          fontWeight: FontWeight.w700,
                          color: context.theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                  SizedBox(
                    height: size(mobile: 15.w, tablet: 10.w),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Translation.did_not_have_account.tr,
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
                          Navigator.of(context)
                              .pushNamed(RoutesManager.signUp.route);
                        },
                        child: Text(
                          Translation.sign_up_here.tr,
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
