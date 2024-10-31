import 'package:flutter/material.dart';
import 'app.dart';

extension NonNullString on String?{
  String get orEmpty => this ?? "";
}

extension NonNullInt on int?{
  int get orEmpty => this ?? 0;
}


extension ThemeSettings on BuildContext{

  set setTheme(ThemeMode theme) =>
      findAncestorStateOfType<MyAppState>()
          ?.setTheme = theme;

  ThemeData get theme => Theme.of(this);

  TextStyle get small => theme.textTheme.titleSmall!;

  TextStyle get medium => theme.textTheme.titleMedium!;

  TextStyle get large => theme.textTheme.titleLarge!;

  ColorScheme get colorScheme => theme.colorScheme;
}