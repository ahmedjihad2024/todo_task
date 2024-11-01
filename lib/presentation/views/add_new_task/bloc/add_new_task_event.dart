part of 'add_new_task_bloc.dart';

@immutable
sealed class AddNewTaskEvent {}

class AddTaskEvent extends AddNewTaskEvent {
  final File image;
  final String title;
  final String description;
  final String priority;
  final String dueDate;

  AddTaskEvent(
      {required this.image,
        required this.title,
        required this.priority,
        required this.description,
        required this.dueDate});
}

