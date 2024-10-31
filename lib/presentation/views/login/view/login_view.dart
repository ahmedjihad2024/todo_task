import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/custom_form_field.dart';
import 'package:todo_task/presentation/common/simple_form.dart';
import 'package:todo_task/presentation/common/phone_form.dart';
import 'package:todo_task/presentation/views/login/bloc/login_bloc.dart';
import 'package:todo_task/presentation/views/login/view/widgets/login_phone_style.dart';
import 'package:todo_task/presentation/views/login/view/widgets/login_windows_style.dart';

import '../../../../app/phone_number_validator.dart';
import '../../../common/overlay_loading.dart';
import '../../../common/state_render.dart';
import '../../../common/toast.dart';
import '../../../res/assets_manager.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../res/routes_manager.dart';
import '../../../res/translations_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController numberController;
  late TextEditingController passwordController;
  late SecurityController securityController;
  late FocusNode numberFocus;
  late FocusNode passwordFocus;
  String countryCode = "+20";
  late OverlayLoading overlayLoading;

  @override
  void initState() {
    securityController = SecurityController();
    numberController = TextEditingController();
    passwordController = TextEditingController();
    numberFocus = FocusNode();
    passwordFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    numberController.dispose();
    passwordController.dispose();
    numberFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void onClick() {
    if (numberController.text.isEmpty)
      numberFocus.requestFocus();
    else if (numberController.text.isEmpty)
      passwordFocus.requestFocus();
    else if (passwordController.text.isEmpty)
      passwordFocus.requestFocus();
    else if (numberController.text.trim().isNotEmpty &&
        !CountryUtils.validatePhoneNumber(numberController.text, countryCode)) {
      showToast(
          msg: Translation.enter_valid_phone.tr,
          type: ToastificationType.warning,
          context: context,
          timeInSec: 5);
    } else {
      context.read<LoginBloc>().add(SubmitLoginEvent(
          countryCode + numberController.text, passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    overlayLoading = OverlayLoading(context);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<LoginBloc, LoginState>(
        buildWhen: (_, __) => false,
        listener: (context, state) {
          if (state.errorMessage != null && state.reqState == ReqState.error) {
            overlayLoading.hideLoading();
            showToast(
                msg: state.errorMessage!,
                type: ToastificationType.warning,
                context: context,
                timeInSec: 5);
          } else if (state.reqState == ReqState.success) {
            overlayLoading.hideLoading();
            // TODO: nav to home
          } else if (state.reqState == ReqState.loading) {
            overlayLoading.showLoading();
          }
        },
        builder: (context, state) {
          return Platform.isWindows
              ? LoginWindowsStyle(
                  numberFocus: numberFocus,
                  numberController: numberController,
                  passwordController: passwordController,
                  passwordFocus: passwordFocus,
                  securityController: securityController,
                  onClick: onClick,
                  onCountryCodeChange: (String code) {
                    countryCode = code;
                  },
                )
              : LoginPhoneStyle(
                  numberFocus: numberFocus,
                  numberController: numberController,
                  passwordController: passwordController,
                  passwordFocus: passwordFocus,
                  securityController: securityController,
                  onClick: onClick,
                  onCountryCodeChange: (String code) {
                    countryCode = code;
                  },
                );
        },
      ),
    );
  }
}
