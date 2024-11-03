part of 'task_details_bloc.dart';


@immutable
class TaskDetailsState{
  final ReqState reqState;
  final String? errorMessage;

  TaskDetailsState({this.reqState = ReqState.loading, this.errorMessage});

  TaskDetailsState copy({
    ReqState? reqState,
    String? errorMessage,
  }) {
    return TaskDetailsState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
