
import '../network/api.dart';
import '../request/request.dart';
import '../responses/responses.dart';

abstract class DataSourceAbs{
  Future<ArticlesResponse> getArticles(ArticleRequest articleRequest);
  Future<RegisterDetailsResponse> login(String phone,String password);
  Future<RegisterDetailsResponse> signIn(RegisterRequest request);
  Future<TaskIdResponse> addTask(AddTaskRequest request);
}

class DataSource implements DataSourceAbs{

  AppServices appServices;
  DataSource(this.appServices);

  @override
  Future<ArticlesResponse> getArticles(ArticleRequest articleRequest) async => await appServices.getArticles(articleRequest);

  @override
  Future<RegisterDetailsResponse> login(String phone, String password) async => await appServices.login(phone, password);

  @override
  Future<RegisterDetailsResponse> signIn(RegisterRequest request) async => await appServices.signIn(request);

  @override
  Future<TaskIdResponse> addTask(AddTaskRequest request) async => await appServices.addTask(request);

}