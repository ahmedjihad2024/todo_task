part of 'home_cubit.dart';

class HomeState extends Equatable {
  final ReqState reqState;
  final List<Article> articles;
  final String message;
  const HomeState({this.reqState = ReqState.loading, this.articles = const [], this.message = ""});

  HomeState copyWith({
    ReqState? reqState,
    List<Article>? articles,
    String? message,
}){
    return HomeState(
      reqState: reqState ?? this.reqState,
      articles: articles ?? this.articles,
        message: message ?? this.message
    );
  }

  @override
  List<Object?> get props => [articles, reqState, message];
}
