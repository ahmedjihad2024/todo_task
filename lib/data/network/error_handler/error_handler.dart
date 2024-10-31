import 'dart:io';

import 'package:dio/dio.dart';
import 'failure.dart';

extension DioErrorTypeFailure on DioErrorType {
  Failure get getFailure {
    return CustomDioLocalError(error: this);
  }
}

extension ApiErrorTypeFailure on ApiErrorType {
  Failure get getFailure {
    return CustomServerError(error: this);
  }
}

extension ErrorHandler on Exception {
  Failure get handle {
    return switch (this) {
      // Dio Errors
      DioException() => switch ((this as DioException).type) {
          DioExceptionType.cancel =>
            CustomDioLocalError(error: DioErrorType.CANCEL),
          DioExceptionType.connectionError =>
            CustomDioLocalError(error: DioErrorType.CONNECTION_ERROR),
          DioExceptionType.unknown =>
            CustomDioLocalError(error: DioErrorType.UNKNOWN),
          DioExceptionType.connectionTimeout =>
            CustomDioLocalError(error: DioErrorType.CONNECTION_TIMEOUT),
          DioExceptionType.sendTimeout =>
            CustomDioLocalError(error: DioErrorType.SEND_TIMEOUT),
          DioExceptionType.receiveTimeout =>
            CustomDioLocalError(error: DioErrorType.RECEIVE_TIMEOUT),
          DioExceptionType.badCertificate =>
            CustomDioLocalError(error: DioErrorType.BAD_CERTIFICATE),
          DioExceptionType.badResponse =>
            _handleResponseError((this as DioException).response),
          _ => DioLocalError(message: (this as DioException).message)
        },
      _ => UnexpectedError(message: toString())
    };
  }
}

Failure _handleResponseError(Response? response) {
  final dynamic status = response?.statusCode ?? response?.data["statusCode"];
  final String? message = response?.data["message"];
  final dynamic error = response?.data["error"] ?? "";

  if (status != null && message != null) {
    final apiError = ApiErrorType.from(status, message);
    return apiError != null
        ? CustomServerError(error: apiError)
        : ServerError(message: message);
  } else {
    return ServerError(message: "An unknown error occurred.");
  }
}

enum DioErrorType {
  CANCEL("CANCEL", "Request was cancelled", "CANCEL"),
  CONNECTION_ERROR("CONNECTION_ERROR", "Failed to connect to the server",
      "CONNECTION_ERROR"),
  UNKNOWN("UNKNOWN", "An unknown error occurred", "UNKNOWN"),
  CONNECTION_TIMEOUT("CONNECTION_TIMEOUT", "Connection to the server timed out",
      "CONNECTION_TIMEOUT"),
  SEND_TIMEOUT(
      "SEND_TIMEOUT", "Request timed out while sending", "SEND_TIMEOUT"),
  RECEIVE_TIMEOUT("RECEIVE_TIMEOUT", "Response timed out while receiving",
      "RECEIVE_TIMEOUT"),
  BAD_CERTIFICATE("BAD_CERTIFICATE", "Invalid certificate from the server",
      "BAD_CERTIFICATE"),
  BAD_RESPONSE("BAD_RESPONSE", "Invalid or unexpected response from the server",
      "BAD_RESPONSE");

  // Example HTTP errors
  // INTERNAL_SERVER_ERROR(500, "Internal Server Error", "INTERNAL_SERVER_ERROR"),
  // BAD_REQUEST(400, "Bad Request", "BAD_REQUEST"),
  // UNAUTHORIZED(401, "Unauthorized", "UNAUTHORIZED"),
  // FORBIDDEN(403, "Forbidden", "FORBIDDEN"),
  // NOT_FOUND(404, "Not Found", "NOT_FOUND"),
  // TOO_MANY_REQUESTS(429, "Too Many Requests", "TOO_MANY_REQUESTS");

  final dynamic
      status; // `dynamic` to handle both String (Dio errors) and int (HTTP errors)
  final String message;
  final String error;

  const DioErrorType(this.status, this.message, this.error);

  static DioErrorType? from(dynamic status, String error) {
    for (var e in DioErrorType.values) {
      if (e.status == status && e.error.toLowerCase() == error.toLowerCase()) {
        return e;
      }
    }
    return null;
  }
}

enum ApiErrorType {
  UNAUTHORIZED_INVALID_PASSWORD_OR_EMAIL(401, "يوجد خطأ في رقم الهاتف أو كلمة المرور"),
  BAD_REQUEST_USER_EXISTS(422, "رقم الهاتف مستخدم بالفعل");

  final dynamic statusCode;
  final String message;

  const ApiErrorType(this.statusCode, this.message);

  static ApiErrorType? from(dynamic statusCode, String message) {
    for (var e in ApiErrorType.values) {
      if (e.message.toLowerCase() == message.toLowerCase() && e.statusCode == statusCode) {
        return e;
      }
    }
    return null;
  }
}

// enum ApiFirebaseError {
//   INVALID_CREDENTIALS(
//     "ERROR_INVALID_CREDENTIAL",
//     "The supplied auth credential is incorrect, malformed or has expired.",
//     "InvalidCredentials",
//   ),
//   USER_DISABLED(
//     "ERROR_USER_DISABLED",
//     "This user account has been disabled.",
//     "UserDisabled",
//   ),
//   EMAIL_ALREADY_IN_USE(
//     "ERROR_EMAIL_ALREADY_IN_USE",
//     "The email address is already in use by another account.",
//     "EmailAlreadyInUse",
//   ),
//   WEAK_PASSWORD(
//     "ERROR_WEAK_PASSWORD",
//     "The password is too weak.",
//     "WeakPassword",
//   ),
//   USER_NOT_FOUND(
//     "ERROR_USER_NOT_FOUND",
//     "User not found.",
//     "UserNotFound",
//   ),
//   OPERATION_NOT_ALLOWED(
//     "ERROR_OPERATION_NOT_ALLOWED",
//     "Operation not allowed.",
//     "OperationNotAllowed",
//   ),
//   TOO_MANY_REQUESTS(
//     "ERROR_TOO_MANY_REQUESTS",
//     "Too many requests. Try again later.",
//     "TooManyRequests",
//   );
//
//   final String code;
//   final String message;
//   final String error;
//
//   const ApiFirebaseError(this.code, this.message, this.error);
//
//   static ApiFirebaseError? from(String code) {
//     return ApiFirebaseError.values.firstWhere(
//       (e) => e.code.toLowerCase() == code.toLowerCase(),
//     );
//   }
// }

// class ErrorHandler implements Exception {
//   final Failure failure;
//
//   ErrorHandler.handle(dynamic error)
//       : failure = switch (error) {
//     DioException() => _handleErrorDio(error),
//     _ => DioErrors.DEFAULT.failure,
//   };
// }
//
// Failure _handleErrorDio(DioException error) {
//   return switch (error.type) {
//     DioExceptionType.connectionTimeout => DioErrors.CONNECT_TIMEOUT.failure,
//     DioExceptionType.sendTimeout => DioErrors.SEND_TIMEOUT.failure,
//     DioExceptionType.receiveTimeout => DioErrors.RECEIVE_TIMEOUT.failure,
//     DioExceptionType.badCertificate => DioErrors.BAD_CERTIFICATE.failure,
//     DioExceptionType.badResponse => _handleBadResponse(error.response),
//     DioExceptionType.cancel => DioErrors.CANCEL.failure,
//     DioExceptionType.connectionError => DioErrors.CONNECTION_ERROR.failure,
//     _ => DioErrors.DEFAULT.failure,
//   };
// }
//
// Failure _handleBadResponse(Response? response) {
//   final statusCode = response?.statusCode;
//   final statusMessage = response?.statusMessage;
//
//   if (statusCode != null && statusMessage != null) {
//
//     for (var error in ApiErrors.values) {
//       if (error.code == response?.data["code"]) {
//         return error.failure();
//       }
//     }
//
//     for (var error in DioErrors.values) {
//       if (error.code == statusCode) {
//         return error.failure;
//       }
//     }
//
//     return Failure(statusCode, statusMessage);
//   } else {
//     return DioErrors.DEFAULT.failure;
//   }
// }
//
// enum DioErrors {
//   SUCCESS(200, 'SUCCESS'),
//   NO_CONTENT(201, "NO_CONTENT"),
//   BAD_REQUEST(400, "BAD_REQUEST"),
//   UNAUTHORIZED(401, "UNAUTHORIZED"),
//   FORBIDDEN(403, "FORBIDDEN"),
//   TOO_MANY_REQUESTS(429, "TOO_MANY_REQUESTS"),
//   INTERNAL_SERVER_ERROR(500, "INTERNAL_SERVER_ERROR"),
//
//   // LOCAL STATUS CODE
//   CONNECT_TIMEOUT(-1, "CONNECT_TIMEOUT"),
//   CANCEL(-2, "CANCEL"),
//   RECEIVE_TIMEOUT(-3, "RECEIVE_TIMEOUT"),
//   SEND_TIMEOUT(-4, "SEND_TIMEOUT"),
//   CACHE_ERROR(-5, "CACHE_ERROR"),
//   NO_INTERNET_CONNECTION(501, "NO_INTERNET_CONNECTION"),
//   DEFAULT(-7, "DEFAULT"),
//   CONNECTION_ERROR(-9, "CONNECTION_ERROR"),
//   BAD_CERTIFICATE(-10, "BAD_CERTIFICATE"),
//   BAD_RESPONSE(-11, "BAD_RESPONSE");
//
//   final int code;
//   final String message;
//   const DioErrors(this.code, this.message);
//
//   Failure get failure => Failure(code, message);
// }
//
// enum ApiErrors {
//   RATE_LIMITED(-1, "error"),
//   MAXIMUM_RESULTS_REACHED(-1, "error");
//
//   final String message;
//   final int code;
//   const ApiErrors(this.code, this.message);
//
//   Failure failure() => Failure(code, message);
// }
