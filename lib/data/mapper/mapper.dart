import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/data/responses/responses.dart';
import 'package:todo_task/domain/model/models.dart';

extension RegisterDetailsMapper on RegisterDetailsResponse {
  RegisterDetails get toDomain => RegisterDetails(
      id: id.orEmpty,
      userName: userName.orEmpty,
      accessToken: accessToken.orEmpty,
      refreshToken: refreshToken.orEmpty);
}
