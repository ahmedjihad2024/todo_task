

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/base.dart';

import '../../data/repository/repository_impl.dart';

class GetProfileDetailsUsecase implements Base<void, ProfileDetails>{
  final Repository _repository;
  GetProfileDetailsUsecase(this._repository);

  @override
  Future<Either<Failure, ProfileDetails>> execute(void input) => _repository.getProfileDetails();
}