import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/app/extensions.dart';
import 'package:todo_task/presentation/common/after_layout.dart';
import 'package:todo_task/presentation/common/state_render.dart';
import 'package:todo_task/presentation/views/home/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AfterLayout {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return ScreenState.setState(
              reqState: state.reqState,
              online: Center(
                child: Text(
                  "Home Page",
                  style: context.large,
                ),
              ),
            offline: Center(
              child: Text(
                state.message,
                style: context.large,
              ),
            ),
            empty: Center(
              child: Text(
                "It is empty",
                style: context.large,
              ),
            ),
            loading: Center(
              child: Text(
                "Loading",
                style: context.large,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    await context.read<HomeCubit>().getArticlesAbout("Egypt");
  }
}
