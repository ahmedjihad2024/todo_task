

import 'package:dio/dio.dart';
import 'package:todo_task/data/responses/responses.dart';

import '../request/request.dart';
import 'dio_factory.dart';


class ArticlesResponse{}

abstract class AppServicesClientAbs{
  Future<ArticlesResponse> getArticles(ArticleRequest articleRequest);
  Future<RegisterDetailsResponse> login(String phone,String password);
  Future<RegisterDetailsResponse> signIn(RegisterRequest request);
}

class AppServices implements AppServicesClientAbs{
  DioFactory _dio;
  AppServices(this._dio);

  @override
  Future<ArticlesResponse> getArticles(ArticleRequest articleRequest) async {
    return ArticlesResponse();
  }

  @override
  Future<RegisterDetailsResponse> login(String phone,String password) async {
    Response response = await _dio.request(
        "auth/login",
        method: RequestMethod.POST,
        body: {
          "phone" : phone,
          "password": password
        });
    return RegisterDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RegisterDetailsResponse> signIn(RegisterRequest request) async {
    Response response = await _dio.request(
        "auth/register",
        method: RequestMethod.POST,
        body: {
          "phone" : request.phone,
          "password" : request.password,
          "displayName" : request.userName,
          "experienceYears" : request.experienceYears,
          "address" : request.address,
          "level" : request.level
        });
    return RegisterDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}