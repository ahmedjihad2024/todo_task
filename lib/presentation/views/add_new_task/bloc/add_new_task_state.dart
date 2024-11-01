part of 'add_new_task_bloc.dart';

class AddNewTaskState {
  final ReqState reqState;
  final String? errorMessage;

  AddNewTaskState({this.reqState = ReqState.idle, this.errorMessage});

  AddNewTaskState copy({
    ReqState? reqState,
    String? errorMessage
  }) {
    return AddNewTaskState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }
}
