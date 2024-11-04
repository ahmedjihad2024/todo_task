import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/res/color_manager.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/presentation/res/assets_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';

import '../../../../app/constants.dart';
import '../../../res/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with AfterLayout {
  @override
  void initState() {
    if (Platform.isWindows) windowsInitialization();
    super.initState();
  }

  Future<void> windowsInitialization() async {
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.royalPurple,
      body: Center(
          child: SvgPicture.asset(
        SvgManager.appName,
        width: desktopSize(
            size(
              mobile: 200.w,
              tablet: 100.w
            ),
            150),
      )),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    Timer(Duration(seconds: Platform.isWindows ? Constants.splashTimer * 2 : Constants.splashTimer), () async {
      if (Platform.isWindows) {
        Display display = await screenRetriever.getPrimaryDisplay();
        // hide the window until navigate to next screen
        await windowManager.hide();
        await windowManager.setAlwaysOnTop(false);
        await windowManager.setTitleBarStyle(TitleBarStyle.normal);
        await windowManager.setResizable(true);
        await windowManager.setSkipTaskbar(false);
        await windowManager.setSize(display.visibleSize! * .7);
        await windowManager.setMinimumSize(display.visibleSize! * .5);
        await windowManager.setAlignment(Alignment.center);
      }

      if (instance<AppPreferences>().isSkippedOnBoarding) {
        if(instance<AppPreferences>().isUserRegistered){
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesManager.home.route, (_) => false);
        }else{
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesManager.login.route, (_) => false);
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesManager.onBoarding.route, (_) => false);
      }
    });
  }
}
