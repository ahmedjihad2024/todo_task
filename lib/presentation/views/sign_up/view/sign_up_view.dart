import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/custom_form_field.dart';
import 'package:todo_task/presentation/common/simple_form.dart';
import 'package:todo_task/presentation/common/phone_form.dart';
import 'package:todo_task/presentation/views/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo_task/presentation/views/sign_up/view/widgets/sign_up_phone_style.dart';
import 'package:todo_task/presentation/views/sign_up/view/widgets/sign_up_windows_style.dart';

import '../../../../app/phone_number_validator.dart';
import '../../../common/overlay_loading.dart';
import '../../../common/state_render.dart';
import '../../../common/toast.dart';
import '../../../res/assets_manager.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../../res/routes_manager.dart';
import '../../../res/translations_manager.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late TextEditingController numberController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late SecurityController securityController;
  late FocusNode numberFocus;
  late FocusNode passwordFocus;
  late FocusNode nameFocus;
  late FocusNode addressFocus;
  String countryCode = "+20";
  String? selectedExperienceLevel;
  int? selectedYearExperience;
  late OverlayLoading overlayLoading;

  @override
  void initState() {
    securityController = SecurityController();
    numberController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    addressController = TextEditingController();
    numberFocus = FocusNode();
    passwordFocus = FocusNode();
    nameFocus = FocusNode();
    addressFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    numberController.dispose();
    passwordController.dispose();
    nameController.dispose();
    addressController.dispose();
    nameFocus.dispose();
    addressFocus.dispose();
    numberFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void onClick() {
    if (nameController.text.isEmpty)
      nameFocus.requestFocus();
    else if (numberController.text.isEmpty)
      numberFocus.requestFocus();
    else if (selectedExperienceLevel == null) {
      showToast(
          msg: Translation.choose_level.tr,
          type: ToastificationType.warning,
          context: context,
          timeInSec: 5);
    } else if (selectedYearExperience == null) {
      showToast(
          msg: Translation.choose_year.tr,
          type: ToastificationType.warning,
          context: context,
          timeInSec: 5);
    } else if (addressController.text.isEmpty)
      addressFocus.requestFocus();
    else if (passwordController.text.isEmpty)
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
      context.read<SignUpBloc>().add(SubmitSignUpEvent(
          nameController.text,
          addressController.text,
          passwordController.text,
          selectedYearExperience!,
          selectedExperienceLevel!,
          countryCode + numberController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    overlayLoading = OverlayLoading(context);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<SignUpBloc, SignUpState>(
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
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesManager.home.route, (_) => false);
          } else if (state.reqState == ReqState.loading) {
            overlayLoading.showLoading();
          }
        },
        builder: (context, state) {
          return Platform.isWindows
              ? SignUpWindowsStyle(
                  securityController: securityController,
                  passwordFocus: passwordFocus,
                  passwordController: passwordController,
                  numberController: numberController,
                  numberFocus: numberFocus,
                  nameController: nameController,
                  selectedExperienceLevel: selectedExperienceLevel,
                  selectedYearExperience: selectedYearExperience,
                  addressController: addressController,
                  addressFocus: addressFocus,
                  nameFocus: nameFocus,
                  onCountryCodeChnage: (String code) {
                    setState(() {
                      countryCode = code;
                    });
                  },
                  onClick: onClick,
                  overlayLoading: overlayLoading,
                  onSelectingExperienceLevel: (String? level) {
                    setState(() {
                      selectedExperienceLevel = level;
                    });
                  },
                  onSelectingExperienceYears: (int? years) {
                    setState(() {
                      selectedYearExperience = years;
                    });
                  },
                )
              : SignUpPhoneStyle(
                  securityController: securityController,
                  passwordFocus: passwordFocus,
                  passwordController: passwordController,
                  numberController: numberController,
                  numberFocus: numberFocus,
                  nameController: nameController,
                  selectedExperienceLevel: selectedExperienceLevel,
                  selectedYearExperience: selectedYearExperience,
                  addressController: addressController,
                  addressFocus: addressFocus,
                  nameFocus: nameFocus,
                  onCountryCodeChnage: (String code) {
                    setState(() {
                      countryCode = code;
                    });
                  },
                  onClick: onClick,
                  overlayLoading: overlayLoading,
                  onSelectingExperienceLevel: (String? level) {
                    setState(() {
                      selectedExperienceLevel = level;
                    });
                  },
                  onSelectingExperienceYears: (int? years) {
                    setState(() {
                      selectedYearExperience = years;
                    });
                  },
                );
        },
      ),
    );
  }
}
