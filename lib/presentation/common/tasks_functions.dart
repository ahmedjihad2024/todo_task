import 'package:flutter/material.dart';

import '../../app/enums.dart';
import '../res/color_manager.dart';
import '../res/translations_manager.dart';

String getTaskStateText(TaskState state) {
  return switch (state) {
    TaskState.all => Translation.all.tr,
    TaskState.inprogress => Translation.inprogress.tr,
    TaskState.waiting => Translation.waiting.tr,
    TaskState.finished => Translation.finished.tr,
  };
}

Color getTaskStateColor(TaskState state) {
  return switch (state) {
    TaskState.inprogress => ColorManager.royalPurple,
    TaskState.waiting => ColorManager.orange,
    TaskState.finished => ColorManager.strongBlue,
    _ => Colors.transparent
  };
}

String getPriorityText(TaskPriority priority) {
  return switch (priority) {
    TaskPriority.low => Translation.low.tr,
    TaskPriority.medium => Translation.medium.tr,
    TaskPriority.high => Translation.high.tr,
  };
}

Color getTaskPriorityColor(TaskPriority priority) {
  return switch (priority) {
    TaskPriority.low => ColorManager.strongBlue,
    TaskPriority.medium => ColorManager.royalPurple,
    TaskPriority.high => ColorManager.orange,
  };
}