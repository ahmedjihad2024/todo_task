part of 'add_new_task_bloc.dart';

class AddNewTaskState {
  final ReqState reqState;
  final String? errorMessage;
  final TaskDetails? taskDetails;

  AddNewTaskState({this.reqState = ReqState.idle, this.errorMessage, this.taskDetails});

  AddNewTaskState copy({
    ReqState? reqState,
    String? errorMessage,
    TaskDetails? taskDetails
  }) {
    return AddNewTaskState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
      taskDetails: taskDetails ?? this.taskDetails
    );
  }
}
