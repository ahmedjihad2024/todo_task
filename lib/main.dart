import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/app/constants.dart';
import 'package:todo_task/app/supported_locales.dart';
import 'package:window_manager/window_manager.dart';
import 'app/app.dart';
import 'app/dependency_injection.dart';
import 'presentation/views/home/bloc/home_bloc.dart';

// 223546
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // init app modules
  await initAppModules();

  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
        )
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  // windows initialization
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    const size = Size(500, 300);
    WindowOptions windowOptions = const WindowOptions(
      size: size,
      center: true,
      backgroundColor: Colors.transparent,
      alwaysOnTop: true,
      skipTaskbar: true,
      title: "Tasky",
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(false);
    });
  }

  runApp(
    EasyLocalization(
        supportedLocales: SupportedLocales.allLocales,
        path: Constants.translationsPath,
        fallbackLocale: SupportedLocales.EN.locale,
        child: BlocProvider(
          create: (context) => instance<HomeBloc>(),
          child: MyApp(),
        )
    ),
  );
}

