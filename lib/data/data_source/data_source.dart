
import '../network/api.dart';
import '../request/request.dart';
import '../responses/responses.dart';

abstract class DataSourceAbs{
  Future<RegisterDetailsResponse> login(String phone,String password);
  Future<RegisterDetailsResponse> signIn(RegisterRequest request);
  Future<TaskDetailsResponse> addTask(AddTaskRequest request);
  Future<TasksResponse> getTodos(int page);
  Future<void> deleteTask(String id);
  Future<TaskDetailsResponse> updateTask(UpdateTaskRequest request);
}

class DataSource implements DataSourceAbs{

  AppServices appServices;
  DataSource(this.appServices);

  @override
  Future<RegisterDetailsResponse> login(String phone, String password) async => await appServices.login(phone, password);

  @override
  Future<RegisterDetailsResponse> signIn(RegisterRequest request) async => await appServices.signIn(request);

  @override
  Future<TaskDetailsResponse> addTask(AddTaskRequest request) async => await appServices.addTask(request);

  @override
  Future<TasksResponse> getTodos(int page) async => await appServices.getTodos(page);

  @override
  Future<void> deleteTask(String id) async => await appServices.deleteTask(id);

  @override
  Future<TaskDetailsResponse> updateTask(UpdateTaskRequest request) async => await appServices.updateTask(request);
}