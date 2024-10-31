import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_task/app/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'language';

enum RequestMethod{
  GET, POST, PUT, DELETE
}

class DioFactory {
  late Dio _dio;

  Dio get dio => _dio;

  DioFactory() {
    _dio = Dio();

    // int _timeOut = 60 * 1000;
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      // AUTHORIZATION: 'Bearer ${Constants.apiKey}',
      DEFAULT_LANGUAGE: 'en',
    };

    _dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        followRedirects: false,
        receiveDataWhenStatusError: true
      // receiveTimeout: Duration(seconds: _timeOut),
      // sendTimeout: Duration(seconds: _timeOut)
    );

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: false));
    }
  }

  Future<Response> request(String path,
      {RequestMethod method = RequestMethod.GET,
        Map<String, dynamic>? queryParameters,
        Object? body,
        Map<String, dynamic>? headers}) async {
    return await _dio.request(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
            method: method.name,
            headers: headers
        )
    );
  }

// Dio getDio() {
//   Dio dio = Dio();
//
//   // int _timeOut = 60 * 1000;
//   Map<String, String> headers = {
//     CONTENT_TYPE: APPLICATION_JSON,
//     ACCEPT: APPLICATION_JSON,
//     // AUTHORIZATION: 'Bearer ${ApiConstant.apiKey}',
//     DEFAULT_LANGUAGE: 'en',
//   };
//
//   dio.options = BaseOptions(
//       baseUrl: ApiConstant.baseUrl,
//       headers: headers,
//       followRedirects: false,
//       receiveDataWhenStatusError: true
//     // receiveTimeout: Duration(seconds: _timeOut),
//     // sendTimeout: Duration(seconds: _timeOut)
//   );
//
//   if(kDebugMode) {
//     dio.interceptors.add(PrettyDioLogger(
//         requestHeader: true, requestBody: true, responseHeader: true, responseBody: false));
//   }
//
//   return dio;
// }
}