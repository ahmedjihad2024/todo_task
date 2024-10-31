


import 'package:todo_task/data/network/error_handler/error_handler.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/presentation/res/translations_manager.dart';

extension UserMessages on Failure {
  String get userMessage => switch(this) {
  // Dio-specific errors
    DioLocalError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,
    CustomDioLocalError(error: final dioError) => dioError?.message ?? DEFAULT_ERROR_MESSAGE,

  // Server-side errors
    ServerError(message: final msg) => msg ?? "A server error occurred.",
    CustomServerError(error: final apiError) => switch(apiError){
      ApiErrorType.UNAUTHORIZED_INVALID_PASSWORD_OR_EMAIL => Translation.invalid_password_or_email.tr,
      ApiErrorType.BAD_REQUEST_USER_EXISTS => Translation.phone_number_exists.tr,
      _ => apiError?.message ?? DEFAULT_ERROR_MESSAGE
    },

  // Unexpected errors
    UnexpectedError(message: final msg) => msg ?? DEFAULT_ERROR_MESSAGE,

  // No internet connection
    NoInternetConnection() => "No internet connection. Please check your network settings.",

    _ => DEFAULT_ERROR_MESSAGE
  };
}


final DEFAULT_ERROR_MESSAGE = "Oops! Something went wrong. Please try again.";