import 'package:json_annotation/json_annotation.dart';


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


class UploadedImageResponse{
  final String image;
  UploadedImageResponse(this.image);

  factory UploadedImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadedImageResponse(json["image"]);
  }
}

class TaskIdResponse{
  final String? id;
  TaskIdResponse({required this.id});

  factory TaskIdResponse.fromJson(Map<String, dynamic> json) {
    return TaskIdResponse(id: json["_id"]);
  }
}