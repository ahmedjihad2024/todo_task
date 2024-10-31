import 'package:flutter/cupertino.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/res/color_manager.dart';

void showToast({
  required String msg,
  required ToastificationType type,
  required BuildContext context,
  int timeInSec = 3,
  BorderSide? borderSide
}) {
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flat,
    borderSide: borderSide ?? BorderSide(
        color: ColorManager.black.withOpacity(.3),
        width: 1
    ),
    backgroundColor: ColorManager.white,
    description: Text(msg, style: context.small.copyWith(color: ColorManager.black, fontSize: desktopSize(14.sp, 14)), softWrap: true,),
    showProgressBar: false,
    showIcon: false,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: Duration(seconds: timeInSec),
    borderRadius: BorderRadius.circular(12.0),
    animationDuration: const Duration(milliseconds: 250),
  );
}