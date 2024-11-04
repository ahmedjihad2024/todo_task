import 'package:json_annotation/json_annotation.dart';
import 'package:todo_task/app/enums.dart';

class RegisterDetailsResponse {
  final String? id;
  final String? userName;
  final String? accessToken;
  final String? refreshToken;

  const RegisterDetailsResponse(
      {required this.id,
      required this.userName,
      required this.accessToken,
      required this.refreshToken});

  factory RegisterDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RegisterDetailsResponse(
        id: json["_id"],
        userName: json["userName"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"]);
  }
}

class UploadedImageResponse {
  final String image;

  UploadedImageResponse(this.image);

  factory UploadedImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadedImageResponse(json["image"]);
  }
}

class TaskDetailsResponse {
  final String? id;
  final String? image;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final String? user;
  final String? createdAt;
  final String? updatedAt;

  TaskDetailsResponse(
      {required this.image,
      required this.priority,
      required this.description,
      required this.title,
      required this.user,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.id});

  factory TaskDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TaskDetailsResponse(
        id: json["_id"],
        image: json["image"],
        title: json["title"],
        status: json["status"],
        priority: json["priority"],
        user: json["user"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        description: json["desc"]);
  }
}

class TasksResponse {
  List<TaskDetailsResponse> tasksGroup;

  TasksResponse({required this.tasksGroup});

  factory TasksResponse.fromList(List<dynamic> data) {
    List<TaskDetailsResponse> group = [];
    for (Map<String, dynamic> item in data) {
      group.add(TaskDetailsResponse.fromJson(item));
    }
    return TasksResponse(tasksGroup: group);
  }
}

class ProfileDetailsResponse {
  final String name;
  final String phone;
  final String address;
  final int yearsExperience;
  final String level;

  ProfileDetailsResponse(
      {required this.name,
      required this.phone,
      required this.address,
      required this.level,
      required this.yearsExperience});

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponse(
        name: json["displayName"],
        phone: json["username"],
        address: json["address"],
        level: json["level"],
        yearsExperience: json["experienceYears"]);
  }
}
