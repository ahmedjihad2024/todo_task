import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_ui/responsive_ui.dart';

// import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/res/assets_manager.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';
import 'package:todo_task/presentation/views/on_boarding/view/widgets/on_boarding_phone_style.dart';
import 'package:todo_task/presentation/views/on_boarding/view/widgets/on_boarding_windows_style.dart';
import 'package:window_manager/window_manager.dart';

import '../../../res/routes_manager.dart';

class OnBoardingView extends StatefulWidget {

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> with AfterLayout {

  late Function() onClick;

  @override
  void initState() {
    super.initState();
    onClick = (){
      // await instance<AppPreferences>().setSkippedOnBoarding();
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesManager.login.route, (_) => false);
    };
  }

  @override
  Widget build(BuildContext context) => Platform.isAndroid || Platform.isIOS
      ? OnBoardingPhoneStyle(onClick)
      : OnBoardingWindowsStyle(onClick);

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (Platform.isWindows) await windowManager.show();
  }

}
