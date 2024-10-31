

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/base.dart';

class LoginUsecase implements Base<LoginRequest, RegisterDetails>{
  final Repository _repository;
  const LoginUsecase(this._repository);

  @override
  Future<Either<Failure, RegisterDetails>> execute(LoginRequest input) {
    return _repository.login(input);
  }

}