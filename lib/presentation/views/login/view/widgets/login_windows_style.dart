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

class LoginWindowsStyle extends StatelessWidget {
  final Function() onClick;
  final Function(String code) onCountryCodeChange;
  final TextEditingController numberController;
  final TextEditingController passwordController;
  final SecurityController securityController;
  final FocusNode numberFocus;
  final FocusNode passwordFocus;

  const LoginWindowsStyle(
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
                      Translation.login.tr,
                      style: context.small.copyWith(
                          fontSize: desktopSize(33.sp, 30),
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.onPrimary),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                PhoneForm(
                  focusNode: numberFocus,
                  controller: numberController,
                  countryCode: (CountryCode code) {
                    onCountryCodeChange(code.dialCode);
                  },
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
                      minimumSize:
                          const WidgetStatePropertyAll(Size(300, 50)),
                      backgroundColor:
                          WidgetStatePropertyAll(context.colorScheme.primary),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    Translation.login.tr,
                    style: context.small.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.theme.colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Translation.did_not_have_account.tr,
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
                        Navigator.of(context)
                            .pushNamed(RoutesManager.signUp.route);
                      },
                      child: Text(
                        Translation.sign_up_here.tr,
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
