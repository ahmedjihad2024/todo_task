

import 'package:dartz/dartz.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/data/data_source/data_source.dart';
import 'package:todo_task/data/mapper/mapper.dart';
import 'package:todo_task/data/network/error_handler/error_handler.dart';
import 'package:todo_task/data/network/error_handler/failure.dart';
import 'package:todo_task/data/network/internet_checker.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/repository/repository.dart';

import '../request/request.dart';

class Repository implements RepositoryAbs{

  final DataSource _dataSource;
  final NetworkConnectivity _networkConnectivity;
  Repository(this._dataSource, this._networkConnectivity);

  @override
  Future<Either<Failure, Articles>> getArticles(ArticleRequest articleRequest) async{
    if(await _networkConnectivity.isConnected){
      try{
        var response = await _dataSource.getArticles(articleRequest);
        return const Left(NoInternetConnection());
      }on Exception catch(e){
        return Left(e.handle);
      }
    }else{
      return const Left(NoInternetConnection());
    }
  }

  @override
  Future<Either<Failure, RegisterDetails>> login(LoginRequest request) async {
    if(await _networkConnectivity.isConnected){
      try{
        var response = await _dataSource.login(request.phone, request.password);
        return Right(response.toDomain);
      }on Exception catch(e){
        return Left(e.handle);
      }
    }else{
      return const Left(NoInternetConnection());
    }
  }

  @override
  Future<Either<Failure, RegisterDetails>> signIn(RegisterRequest request) async {
    if(await _networkConnectivity.isConnected){
      try{
        var response = await _dataSource.signIn(request);
        return Right(response.toDomain);
      }on Exception catch(e){
        return Left(e.handle);
      }
    }else{
      return const Left(NoInternetConnection());
    }
  }
}

