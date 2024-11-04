part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class RefreshTasksEvent extends HomeEvent{
}

class LoadMoreTasksEvent extends HomeEvent{
  final RefreshController refreshController;
  LoadMoreTasksEvent(this.refreshController);
}

class HomeAddTaskEvent extends HomeEvent{
  final TaskDetails taskDetails;
  HomeAddTaskEvent(this.taskDetails);
}

class HomeUpdateTaskEvent extends HomeEvent{
  final TaskDetails taskDetails;
  HomeUpdateTaskEvent(this.taskDetails);
}

class HomeDeleteTaskEvent extends HomeEvent{
  final TaskDetails taskDetails;
  HomeDeleteTaskEvent(this.taskDetails);
}

class ApplyFilterEvent extends HomeEvent{
  final TaskState state;
  ApplyFilterEvent(this.state);
}

class LogoutEvent extends HomeEvent{
  final Function() onLogout;
  LogoutEvent(this.onLogout);
}

class GetTaskById extends HomeEvent {
  final String id;
  final OverlayLoading overlayLoading;
  GetTaskById(this.id, this.overlayLoading);
}

class CloseStreams extends HomeEvent{}