import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/presentation/views/home/cubit/home_cubit.dart';
import 'package:todo_task/presentation/views/home/view/home_view.dart';
import 'package:todo_task/presentation/views/login/bloc/login_bloc.dart';
import 'package:todo_task/presentation/views/login/view/login_view.dart';
import 'package:todo_task/presentation/views/on_boarding/view/on_boarding_view.dart';
import 'package:todo_task/presentation/views/sign_up/bloc/sign_up_bloc.dart';
import 'package:todo_task/presentation/views/sign_up/view/sign_up_view.dart';

import '../views/splash/view/splash_view.dart';

enum RoutesManager {
  splash('splash-view/'),
  home('home-view/'),
  onBoarding("on-boarding-view/"),
  login("login/"),
  signUp("sign-up/");

  final String route;

  const RoutesManager(this.route);
}

class RoutesGeneratorManager {
  static final Map<String, WidgetBuilder> _routeBuilders = {
    RoutesManager.splash.route: (_) => const SplashView(),
    RoutesManager.onBoarding.route: (_) => OnBoardingView(),
    RoutesManager.login.route: (_) => BlocProvider(
        create: (_) => instance<LoginBloc>(), child: LoginView()),
    RoutesManager.signUp.route: (_) => BlocProvider(
        create: (_) => instance<SignUpBloc>(), child: SignUpView()),
    RoutesManager.home.route: (_) => BlocProvider(
          create: (_) => instance<HomeCubit>(),
          child: const HomeView(),
        ),
  };

  static Route<dynamic> getRoute(RouteSettings settings) => MaterialPageRoute(
      builder: _routeBuilders[settings.name]!, settings: settings);
}