

import 'package:dartz/dartz.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/domain/usecase/base.dart';

import '../model/models.dart';

class GetArticles implements Base<ArticleRequest, Articles>{
  final Repository _repository;
  const GetArticles(this._repository);

  @override
  Future<Either<Failure, Articles>> execute(ArticleRequest input) async => _repository.getArticles(input);

}