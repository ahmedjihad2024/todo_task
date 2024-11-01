import 'dart:io';

class ArticleRequest {
  final String article;
  int pageSize;
  int pageNumber;

  ArticleRequest(
      {required this.article,
      required this.pageSize,
      required this.pageNumber});
}

class LoginRequest {
  final String phone;
  final String password;

  const LoginRequest(this.phone, this.password);
}

class RegisterRequest {
  final String userName;
  final String password;
  final String phone;
  final int experienceYears;
  final String address;
  final String level;

  const RegisterRequest(this.userName, this.address, this.password,
      this.experienceYears, this.level, this.phone);
}

// "image"  : "path.png",
// "title" : "title",
// "desc" : "desc",
// "priority" : "low",//low , medium , high
// "dueDate" : "2024-05-15"

class AddTaskRequest {
  final File image;
  final String title;
  final String description;
  final String priority;
  final String dueDate;

  AddTaskRequest(
      {required this.image,
      required this.title,
      required this.priority,
      required this.description,
      required this.dueDate});
}
