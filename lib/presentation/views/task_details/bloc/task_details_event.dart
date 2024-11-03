part of 'task_details_bloc.dart';

@immutable
sealed class TaskDetailsEvent {}

class UpdateTaskEvent extends TaskDetailsEvent{
  final String id;
  final String status;

  UpdateTaskEvent({required this.id, required this.status});
}
