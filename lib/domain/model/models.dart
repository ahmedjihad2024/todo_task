

import 'package:equatable/equatable.dart';
import 'package:todo_task/app/enums.dart';

class Source {
  String id;
  String name;
  Source(this.id, this.name);
}

class Article {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;
  Source? source;

  Article(this.author, this.source, this.content, this.title, this.description,
      this.publishedAt, this.url, this.urlToImage);


}

class Articles {
  List<Article> articles;
  Articles(this.articles);
}

class RegisterDetails {
  final String id;
  final String userName;
  final String accessToken;
  final String refreshToken;

  const RegisterDetails(
      {required this.id,
        required this.userName,
        required this.accessToken,
        required this.refreshToken});
}

class TaskDetails{
  final String id;
  final String image;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskState status;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskDetails(
      {required this.image,
        required this.priority,
        required this.description,
        required this.title,
        required this.user,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.id});
}


class Tasks{
  List<TaskDetails> tasksGroup;
  Tasks({
    required this.tasksGroup
  });
}

class ProfileDetails {
  final String name;
  final String phone;
  final String address;
  final int yearsExperience;
  final ExperienceLevel level;

  ProfileDetails(
      {required this.name,
        required this.phone,
        required this.address,
        required this.level,
        required this.yearsExperience});

}