import 'package:flutter/material.dart';
import 'package:todo_task/presentation/res/fonts_manager.dart';

import '../../app/app.dart';
import 'color_manager.dart';

class ThemeManager {
  static get lightTheme =>
      ThemeData(
          scaffoldBackgroundColor: ColorManager.white,
          primaryColor: ColorManager.royalPurple,
          fontFamily: FontsManager.DM_SANS.name,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 24.0),
            titleMedium: TextStyle(fontSize: 16.0),
            titleSmall: TextStyle(fontSize: 14.0),
          ),
          colorScheme: const ColorScheme.light(
            primary: ColorManager.royalPurple,
            onPrimary: ColorManager.black,
            onPrimaryContainer: ColorManager.white
          ));
}

