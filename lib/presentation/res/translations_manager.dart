

import 'package:easy_localization/easy_localization.dart';

enum Translation{
  on_splash_title_one,
  on_splash_title_two,
  let_start,
  login,
  password,
  did_not_have_account,
  sign_up_here,
  sign_in,
  enter_valid_phone,
  already_have_account,
  sign_up,
  name,
  years_of_experience,
  choose_experience,
  address,
  choose_year,
  choose_level,
  phone_number_exists,
  invalid_password_or_email
}

extension Tra on Translation{
  String get tr => name.tr();
}