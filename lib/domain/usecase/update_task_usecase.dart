


import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/usecase/base.dart';

import '../../data/request/request.dart';
import '../model/models.dart';

class UpdateTaskUsecase implements Base<UpdateTaskRequest, TaskDetails>{
  final Repository _repository;
  UpdateTaskUsecase(this._repository);

  @override
  Future<Either<Failure, TaskDetails>> execute(UpdateTaskRequest input) => _repository.updateTask(input);

}