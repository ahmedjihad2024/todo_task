

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/data/responses/responses.dart';

import '../request/request.dart';
import 'dio_factory.dart';


class ArticlesResponse{}

abstract class AppServicesClientAbs{
  Future<ArticlesResponse> getArticles(ArticleRequest articleRequest);
  Future<RegisterDetailsResponse> login(String phone,String password);
  Future<RegisterDetailsResponse> signIn(RegisterRequest request);
  Future<UploadedImageResponse> uploadImage(File file);
  Future<TaskIdResponse> addTask(AddTaskRequest request);
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

  @override
  Future<UploadedImageResponse> uploadImage(File file) async {
    Response response = await _dio.request(
        "upload/image",
        method: RequestMethod.POST,
        headers: {
          "Authorization" : "Bearer ${instance<AppPreferences>().accessToken}",
          "Content-Type": "multipart/form-data"
        },
        body: FormData.fromMap({
          'image': await MultipartFile.fromFile(file.path, contentType: DioMediaType.parse('image/jpeg')),
        })
    );
    return UploadedImageResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskIdResponse> addTask(AddTaskRequest request) async {

    var result = await uploadImage(request.image);

    Response response =
        await _dio.request(
        "todos",
        method: RequestMethod.POST,
        headers: {
          "Authorization" : "Bearer ${instance<AppPreferences>().accessToken}",
        },
        body: {
          "image"  : result.image,
          "title" : request.title,
          "desc" : request.description,
          "priority" : request.priority,
          "dueDate" : request.dueDate
        });
    return TaskIdResponse.fromJson(response.data as Map<String, dynamic>);
  }
}