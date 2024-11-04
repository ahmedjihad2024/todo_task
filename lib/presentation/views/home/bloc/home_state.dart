part of 'home_bloc.dart';

@immutable
class HomeState{
  final ReqState reqState;
  final String? errorMessage;
  final List<TaskDetails> tasksGroup;

  HomeState({this.reqState = ReqState.loading, this.errorMessage, this.tasksGroup = const []});

  HomeState copy({
    ReqState? reqState,
    String? errorMessage,
    List<TaskDetails>? tasksGroup,
  }) {
    return HomeState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
      tasksGroup: tasksGroup ?? this.tasksGroup,
    );
  }
}