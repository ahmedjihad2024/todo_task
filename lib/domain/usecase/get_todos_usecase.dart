

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/base.dart';

class GetTodosUsecase implements Base<int, Tasks>{
  final Repository _repository;
  GetTodosUsecase(this._repository);

  @override
  Future<Either<Failure, Tasks>> execute(int input) => _repository.getTodos(input);
}