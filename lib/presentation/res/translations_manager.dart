

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
  invalid_password_or_email,
  my_tasks,
  all,
  inprogress,
  waiting,
  finished,
  medium,
  low,
  high,
  add_new_task,
  add_image,
  task_title,
  task_description,
  enter_title_here,
  enter_description_here,
  priority,
  due_date,
  choose_due_date,
  add_task,
  choose_image,
  try_again,
  delete,
  edit,
  update_task,
  update,
  task_details
}

extension Tra on Translation{
  String get tr => name.tr();
}