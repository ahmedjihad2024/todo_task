

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/usecase/base.dart';

import '../model/models.dart';

class GetTaskByIdUsecase implements Base<String, TaskDetails>{
  final Repository _repository;
  GetTaskByIdUsecase(this._repository);

  @override
  Future<Either<Failure, TaskDetails>> execute(String input) {
    return _repository.getTaskById(input);
  }

}