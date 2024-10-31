

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/request/request.dart';

import '../../data/network/error_handler/failure.dart';
import '../../data/repository/repository_impl.dart';
import '../model/models.dart';
import 'base.dart';

class SignUpUsecase implements Base<RegisterRequest, RegisterDetails>{

  final Repository _repository;
  const SignUpUsecase(this._repository);

  @override
  Future<Either<Failure, RegisterDetails>> execute(RegisterRequest input) {
    return _repository.signIn(input);
  }

}