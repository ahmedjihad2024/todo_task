import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/data/responses/responses.dart';
import 'package:todo_task/domain/model/models.dart';

extension RegisterDetailsMapper on RegisterDetailsResponse {
  RegisterDetails get toDomain => RegisterDetails(
      id: id.orEmpty,
      userName: userName.orEmpty,
      accessToken: accessToken.orEmpty,
      refreshToken: refreshToken.orEmpty);
}

extension TaskDetailsMapper on TaskDetailsResponse {
  TaskDetails get toDomain => TaskDetails(
      id: id.orEmpty,
      title: title.orEmpty,
      description: description.orEmpty,
      user: user.orEmpty,
      status: TaskState.from(status.orEmpty)!,
      priority: TaskPriority.from(priority.orEmpty)!,
      image: image.orEmpty,
      createdAt: DateTime.parse(createdAt.orEmpty),
      updatedAt: DateTime.parse(updatedAt.orEmpty));
}

extension TasksMapper on TasksResponse{
  Tasks get toDomain => Tasks(
      tasksGroup: tasksGroup.map((e) => e.toDomain).toList()
  );
}
