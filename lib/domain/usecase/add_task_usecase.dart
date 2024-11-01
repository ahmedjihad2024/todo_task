

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/usecase/base.dart';

import '../../data/request/request.dart';
import '../model/models.dart';

class AddTaskUsecase implements Base<AddTaskRequest, TaskId>{
  final Repository _repository;
  AddTaskUsecase(this._repository);

  @override
  Future<Either<Failure, TaskId>> execute(AddTaskRequest input) => _repository.addTask(input);
}