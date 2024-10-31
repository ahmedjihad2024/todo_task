import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_task/presentation/res/routes_manager.dart';
import 'package:todo_task/presentation/res/theme_manager.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:window_manager/window_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        designWidth: 360,
        designHeight: 690,
        builder: (context, details) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: RoutesManager.splash.route,
            theme: ThemeManager.lightTheme,
            themeMode: _themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: RoutesGeneratorManager.getRoute,
          );
        });
  }

  set setTheme(ThemeMode themeMode) => setState(()=> _themeMode = themeMode);
}
