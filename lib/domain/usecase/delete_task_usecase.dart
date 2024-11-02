


import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/usecase/base.dart';

class DeleteTaskUsecase implements Base<String, void>{
  final Repository _repository;
  DeleteTaskUsecase(this._repository);

  @override
  Future<Either<Failure, void>> execute(String input) => _repository.deleteTask(input);

}