
import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';

import '../../data/request/request.dart';
import '../../data/responses/responses.dart';
import '../model/models.dart';

abstract class RepositoryAbs{
  Future<Either<Failure, RegisterDetails>> login(LoginRequest request);
  Future<Either<Failure, RegisterDetails>> signIn(RegisterRequest request);
  Future<Either<Failure, TaskDetails>> addTask(AddTaskRequest request);
  Future<Either<Failure, Tasks>> getTodos(int page);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, TaskDetails>> updateTask(UpdateTaskRequest request);
  Future<Either<Failure, TaskDetails>> getTaskById(String id);
  Future<Either<Failure, ProfileDetails>> getProfileDetails();
}