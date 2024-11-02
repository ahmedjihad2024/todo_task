import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';

enum ReqState { loading, empty, error, success, idle, toastError }

class ScreenState {
  static Widget setState(
      {required ReqState reqState,
      required Widget Function() online,
      Widget Function()? error,
        Widget Function()? loading,
        Widget Function()? empty,
        Widget Function()? idle}) {
    return switch (reqState) {
      ReqState.success || ReqState.toastError => online(),
      ReqState.loading => loading?.call() ?? const SizedBox.shrink(),
      ReqState.error => error?.call() ?? const SizedBox.shrink(),
      ReqState.empty => empty?.call() ?? const SizedBox.shrink(),
      ReqState.idle => idle?.call() ?? const SizedBox.shrink(),

    };
  }

  static void showSnackBar(String message) {
    scaffoldMessengerKey.currentState!
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
