import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/presentation/views/add_new_task/bloc/add_new_task_bloc.dart';
import 'package:todo_task/presentation/views/add_new_task/view/add_new_task_view.dart';
import 'package:todo_task/presentation/views/home/bloc/home_bloc.dart';
import 'package:todo_task/presentation/views/home/view/home_view.dart';
import 'package:todo_task/presentation/views/login/bloc/login_bloc.dart';
import 'package:todo_task/presentation/views/login/view/login_view.dart';
import 'package:todo_task/presentation/views/on_boarding/view/on_boarding_view.dart';
import 'package:todo_task/presentation/views/profile/bloc/profile_bloc.dart';
import 'package:todo_task/presentation/views/profile/views/profile_view.dart';
import 'package:todo_task/presentation/views/qr_scanner/view/qr_scanner_view.dart';
import 'package:todo_task/presentation/views/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo_task/presentation/views/sign_up/view/sign_up_view.dart';
import 'package:todo_task/presentation/views/task_details/bloc/task_details_bloc.dart';
import 'package:todo_task/presentation/views/task_details/view/task_details_view.dart';

import '../views/splash/view/splash_view.dart';

enum RoutesManager {
  splash('splash-view/'),
  home('home-view/'),
  onBoarding("on-boarding-view/"),
  login("login/"),
  signUp("sign-up/"),
  taskDetails("task-details/"),
  addNewTask("add-new-task/"),
  qrScanner("qr-scanner/"),
  profileDetails("profile-details/");

  final String route;

  const RoutesManager(this.route);
}

class RoutesGeneratorManager {
  static WidgetBuilder _getBuilder(String? name, RouteSettings settings) {
    return switch (RoutesManager.values.firstWhere((t) => t.route == name)) {
      RoutesManager.splash => (_) => const SplashView(),
      RoutesManager.onBoarding => (_) => OnBoardingView(),
      RoutesManager.login => (_) => BlocProvider(
          create: (_) => instance<LoginBloc>(), child: LoginView()),
      RoutesManager.signUp => (_) => BlocProvider(
          create: (_) => instance<SignUpBloc>(), child: SignUpView()),
      RoutesManager.home => (_) => HomeView(),
      RoutesManager.addNewTask => (_) => BlocProvider(
          create: (_) => instance<AddNewTaskBloc>(),
          child: AddNewTaskView(
            newTask: settings.arguments != null
                ? (settings.arguments as Map)["new-task"] ?? true
                : true,
            taskDetails: settings.arguments != null
                ? (settings.arguments as Map)["details"]
                : null,
          )),
      RoutesManager.taskDetails => (_) => BlocProvider(
            create: (_) => instance<TaskDetailsBloc>(),
            child: TaskDetailsView(
                tasksDetails: settings.arguments as TaskDetails),
          ),
      RoutesManager.qrScanner => (_) => QrScannerView(),
      RoutesManager.profileDetails => (_) => BlocProvider(
        create: (_) => instance<ProfileBloc>(),
        child: ProfileView(),
      ),
    };
  }

  static Route<dynamic> getRoute(RouteSettings settings) => MaterialPageRoute(
      builder: _getBuilder(settings.name, settings), settings: settings);

// static Route<dynamic> getRoute(RouteSettings settings) => MaterialPageRoute(
//     builder: _routeBuilders[settings.name]!, settings: settings);
}
