
import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';

import '../../data/request/request.dart';
import '../model/models.dart';

abstract class RepositoryAbs{
  Future<Either<Failure, Articles>> getArticles(ArticleRequest articleRequest);
  Future<Either<Failure, RegisterDetails>> login(LoginRequest request);
  Future<Either<Failure, RegisterDetails>> signIn(RegisterRequest request);
}