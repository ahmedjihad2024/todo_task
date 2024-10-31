import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';

enum ReqState { loading, empty, error, success, idle }

class ScreenState {
  static Widget setState(
      {required ReqState reqState,
      required Widget online,
      Widget? offline,
      Widget? loading,
      Widget? empty,
      Widget? idle}) {
    return switch (reqState) {
      ReqState.success => online,
      ReqState.loading => loading ?? const SizedBox.shrink(),
      ReqState.error => offline ?? const SizedBox.shrink(),
      ReqState.empty => empty ?? const SizedBox.shrink(),
      ReqState.idle => idle ?? const SizedBox.shrink(),
    };
  }

  static void showSnackBar(String message) {
    scaffoldMessengerKey.currentState!
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
