import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/articles.dart';
import 'package:todo_task/presentation/common/state_render.dart';

import '../../../../data/network/error_handler/failure.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetIt getIt;
  HomeCubit(this.getIt) : super(const HomeState());

  int articlePageNumber = 1;
  String? article;

  Future<void> _getArticlesAbout(String article, int pageNumber) async {
    // var articleRequest = ArticleRequest(
    //   article: article,
    //   pageSize: 10,
    //   pageNumber: pageNumber
    // );
    //
    // Either<Failure, Articles> response = await getIt<GetArticles>().execute(articleRequest);
    //
    // response.fold((Failure failure){
    //   if(failure is NoInternetConnection){
    //     emit(state.copyWith(reqState: ReqState.offline, message: "There is no internet connection"));
    //   }else{
    //     emit(state.copyWith(reqState: ReqState.offline, message: failure.userMessage));
    //   }
    // }, (Articles articles){
    //   if(state.articles.isNotEmpty && articles.articles.isNotEmpty){
    //     emit(state.copyWith(reqState: ReqState.empty));
    //   }else{
    //     emit(state.copyWith(reqState: ReqState.success, articles: [...state.articles, ...articles.articles]));
    //   }
    // });
  }

  Future<void> reloadMoreArticles() async{
    articlePageNumber++;
    await _getArticlesAbout(article!, articlePageNumber);
  }

  Future<void> getArticlesAbout(String article) async{
    articlePageNumber = 1;
    await _getArticlesAbout(article, articlePageNumber);
  }

}
