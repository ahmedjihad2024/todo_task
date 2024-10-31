

import 'package:flutter/material.dart';

enum SupportedLocales{
  EN(Locale('en'));

  final Locale locale;
  const SupportedLocales(this.locale);

  static List<Locale> get allLocales {
    return values.map((e) => e.locale).toList();
  }
}