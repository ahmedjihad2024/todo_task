import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/data/data_source/data_source.dart';
import 'package:todo_task/data/network/api.dart';
import 'package:todo_task/data/network/dio_factory.dart';
import 'package:todo_task/data/network/internet_checker.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/presentation/views/home/cubit/home_cubit.dart';
import 'package:todo_task/presentation/views/login/bloc/login_bloc.dart';
import 'package:todo_task/presentation/views/sign_up/bloc/sign_up_bloc.dart';

import '../domain/usecase/articles.dart';

final instance = GetIt.instance;

Future initAppModules() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  instance.registerFactory<DioFactory>(() => DioFactory());
  instance.registerFactory<NetworkConnectivity>(() => NetworkConnectivity());
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(sharedPreferences));

  // ** Data
  instance.registerFactory<AppServices>(() => AppServices(instance<DioFactory>()));
  instance
      .registerLazySingleton<DataSource>(() => DataSource(instance<AppServices>()));
  instance.registerLazySingleton<Repository>(() =>
      Repository(instance<DataSource>(), instance<NetworkConnectivity>()));
  // **

  // ** Blocs
  instance.registerFactory<HomeCubit>(()=> HomeCubit(instance));
  instance.registerFactory<LoginBloc>(()=> LoginBloc(instance<Repository>()));
  instance.registerFactory<SignUpBloc>(()=> SignUpBloc(instance<Repository>()));
  // **

  instance.registerFactory<GetArticles>(() => GetArticles(instance<Repository>()));
}
