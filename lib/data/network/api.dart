import 'dart:io';

import 'package:dio/dio.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/data/responses/responses.dart';
import 'package:todo_task/domain/model/models.dart';

import '../request/request.dart';
import 'dio_factory.dart';

abstract class AppServicesClientAbs {
  Future<RegisterDetailsResponse> login(String phone, String password);

  Future<RegisterDetailsResponse> signIn(RegisterRequest request);

  Future<UploadedImageResponse> uploadImage(File file);

  Future<TaskDetailsResponse> addTask(AddTaskRequest request);

  Future<TasksResponse> getTodos(int page);

  Future<void> deleteTask(String id);

  Future<String> refreshToken();

  Future<TaskDetailsResponse> updateTask(UpdateTaskRequest request);

  Future<TaskDetailsResponse> getTaskById(String id);

  Future<ProfileDetailsResponse> getProfileDetails();


}

class AppServices implements AppServicesClientAbs {
  DioFactory _dio;

  AppServices(this._dio);

  @override
  Future<RegisterDetailsResponse> login(String phone, String password) async {
    Response response = await _dio.request("auth/login",
        method: RequestMethod.POST,
        body: {"phone": phone, "password": password});
    return RegisterDetailsResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<RegisterDetailsResponse> signIn(RegisterRequest request) async {
    Response response =
        await _dio.request("auth/register", method: RequestMethod.POST, body: {
      "phone": request.phone,
      "password": request.password,
      "displayName": request.userName,
      "experienceYears": request.experienceYears,
      "address": request.address,
      "level": request.level
    });
    return RegisterDetailsResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<UploadedImageResponse> uploadImage(File file) async {
    Response response = await _dio.request("upload/image",
        method: RequestMethod.POST,
        headers: {"Content-Type": "multipart/form-data"},
        body: FormData.fromMap({
          'image': await MultipartFile.fromFile(file.path,
              contentType: DioMediaType.parse('image/jpeg')),
        }));
    return UploadedImageResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskDetailsResponse> addTask(AddTaskRequest request) async {
    var result = await uploadImage(request.image);

    Response response =
        await _dio.request("todos", method: RequestMethod.POST, body: {
      "image": result.image,
      "title": request.title,
      "desc": request.description,
      "priority": request.priority,
      "dueDate": request.dueDate
    });
    return TaskDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TasksResponse> getTodos(int page) async {
    Response response = await _dio.request("todos",
        method: RequestMethod.GET, queryParameters: {"page": page});

    return TasksResponse.fromList(response.data);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dio.request("todos/$id", method: RequestMethod.DELETE, headers: {
      "Authorization": "Bearer ${instance<AppPreferences>().accessToken}",
    });
  }

  @override
  Future<String> refreshToken() async {
    Response response = await _dio.request("auth/refresh-token",
        method: RequestMethod.GET,
        queryParameters: {"token": instance<AppPreferences>().refreshToken});
    return response.data["access_token"];
  }

  @override
  Future<TaskDetailsResponse> updateTask(UpdateTaskRequest request) async {
    var body = {};

    if (request.image != null) {
      var result = await uploadImage(request.image!);
      body.addAll({"image": result.image});
    }
    if (request.title != null)
      body.addAll({
        "title": request.title,
      });
    if (request.description != null)
      body.addAll({
        "desc": request.description,
      });
    if (request.priority != null)
      body.addAll({
        "priority": request.priority,
      });
    if (request.dueDate != null)
      body.addAll({
        "dueDate": request.dueDate,
      });
    if (request.status != null)
      body.addAll({
        "status": request.status,
      });

    Response response = await _dio.request("todos/${request.id}",
        method: RequestMethod.PUT, body: body);

    return TaskDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TaskDetailsResponse> getTaskById(String id) async {
    Response response =
        await _dio.request("todos/$id", method: RequestMethod.GET);
    if(response.data.toString().trim().isEmpty) throw "This task is not exists";
    return TaskDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileDetailsResponse> getProfileDetails() async {
    Response response =
        await _dio.request("auth/profile", method: RequestMethod.GET);
    return ProfileDetailsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
