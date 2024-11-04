import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/app/dependency_injection.dart';
import 'package:todo_task/app/enums.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/delete_task_usecase.dart';
import 'package:todo_task/domain/usecase/get_task_by_id_usecase.dart';
import 'package:todo_task/domain/usecase/get_todos_usecase.dart';
import 'package:todo_task/presentation/common/overlay_loading.dart';

import '../../../../data/network/error_handler/failure.dart';
import '../../../common/state_render.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repository _repository;
  late GetTodosUsecase _getTodosUsecase;
  late DeleteTaskUsecase _deleteTaskUsecase;
  late GetTaskByIdUsecase _getTaskByIdUsecase;

  int page = 1;
  TaskState _filter = TaskState.all;
  List<TaskDetails> _groupOfTaskDetails = [];

  HomeBloc(this._repository) : super(HomeState()) {
    on<RefreshTasksEvent>(_refreshTasks);
    on<LoadMoreTasksEvent>(_loadMoreTasks);
    on<HomeAddTaskEvent>(_addTask);
    on<HomeUpdateTaskEvent>(_updateTask);
    on<HomeDeleteTaskEvent>(_deleteTask);
    on<ApplyFilterEvent>(_applyFilterEvent);
    on<LogoutEvent>(_logout);
    on<CloseStreams>(_closeStreams);
    on<GetTaskById>(_getTaskById);

    _getTodosUsecase = GetTodosUsecase(_repository);
    _deleteTaskUsecase = DeleteTaskUsecase(_repository);
    _getTaskByIdUsecase = GetTaskByIdUsecase(_repository);
  }

  var _toastController = StreamController<String>();
  var _qrResultController = StreamController<TaskDetails>();
  Stream<String> toastStream(){
    if(_toastController.isClosed) _toastController = StreamController<String>();
    return _toastController.stream;
  }
  Stream<TaskDetails> qrResult() {
    if(_qrResultController.isClosed) _qrResultController = StreamController<TaskDetails>();
   return _qrResultController.stream;
  }

  FutureOr<void> _refreshTasks(
      RefreshTasksEvent event, Emitter<HomeState> emit) async {
    emit(state.copy(reqState: ReqState.loading));

    page = 1;
    Either<Failure, Tasks> result = await _getTodosUsecase.execute(page);

    result.fold((left) {
      emit(
          state.copy(reqState: ReqState.error, errorMessage: left.userMessage));
    }, (right) {
      if (right.tasksGroup.isEmpty) {
        emit(state.copy(reqState: ReqState.empty, errorMessage: "No tasks"));
      } else {
        emit(state.copy(
            reqState: ReqState.success,
            tasksGroup: filterTasks(right.tasksGroup, _filter)));
        _groupOfTaskDetails = right.tasksGroup;
      }
    });
  }

  FutureOr<void> _loadMoreTasks(
      LoadMoreTasksEvent event, Emitter<HomeState> emit) async {
    Either<Failure, Tasks> result = await _getTodosUsecase.execute(++page);

    result.fold((left) {
      event.refreshController.loadFailed();
      _toastController.add(left.userMessage);
    }, (right) {
      if (right.tasksGroup.isEmpty && _groupOfTaskDetails.isEmpty) {
        emit(state.copy(reqState: ReqState.empty, errorMessage: "No tasks"));
      } else if (right.tasksGroup.isEmpty) {
        event.refreshController.loadNoData();
      } else {
        event.refreshController.loadComplete();
        emit(state.copy(
            reqState: ReqState.success,
            tasksGroup: filterTasks(
                [..._groupOfTaskDetails, ...right.tasksGroup], _filter)));
        _groupOfTaskDetails = [..._groupOfTaskDetails, ...right.tasksGroup];
      }
    });
  }

  FutureOr<void> _addTask(
      HomeAddTaskEvent event, Emitter<HomeState> emit) async {
    emit(state.copy(
        reqState: ReqState.success,
        tasksGroup:
            filterTasks([event.taskDetails, ..._groupOfTaskDetails], _filter)));
    _groupOfTaskDetails = [event.taskDetails, ..._groupOfTaskDetails];
  }

  FutureOr<void> _updateTask(
      HomeUpdateTaskEvent event, Emitter<HomeState> emit) async {
    int index = state.tasksGroup.indexWhere((e) => e.id == event.taskDetails.id);
    if(index != -1){
      var newGroup =
      _groupOfTaskDetails.where((e) => e.id != event.taskDetails.id).toList()..insert(index, event.taskDetails);
      emit(state.copy(
          reqState: ReqState.success,
          tasksGroup: filterTasks(newGroup, _filter)));
      _groupOfTaskDetails = newGroup;
    }
  }

  FutureOr<void> _deleteTask(
      HomeDeleteTaskEvent event, Emitter<HomeState> emit) async {
    Either<Failure, void> result =
        await _deleteTaskUsecase.execute(event.taskDetails.id);

    result.fold((left) {
      _toastController.add(left.userMessage);
    }, (right) {
      _groupOfTaskDetails = _groupOfTaskDetails
          .where((t) => t.id != event.taskDetails.id)
          .toList();
      var newData = filterTasks(_groupOfTaskDetails,
          _filter);
      emit(state.copy(
          tasksGroup: newData,
          errorMessage: newData.isEmpty ? "No Tasks" : null,
          reqState: newData.isEmpty ? ReqState.empty : ReqState.success));
    });
  }

  List<TaskDetails> filterTasks(
      List<TaskDetails> tasksGroup, TaskState status) {
    if (status == TaskState.all) return tasksGroup;
    return tasksGroup.where((e) => e.status == _filter).toList();
  }

  FutureOr<void> _applyFilterEvent(
      ApplyFilterEvent event, Emitter<HomeState> emit) async {
    _filter = event.state;
    emit(
      state.copy(
        tasksGroup: filterTasks(_groupOfTaskDetails, _filter)
      )
    );
  }

  FutureOr<void> _logout(
      LogoutEvent event, Emitter<HomeState> emit) async {
    await instance<AppPreferences>().clearAllTokens();
    event.onLogout();
    _groupOfTaskDetails = [];
    _filter = TaskState.all;
  }

  FutureOr<void> _getTaskById(GetTaskById event, Emitter<HomeState> emit) async {

    event.overlayLoading.showLoading();

    Either<Failure, TaskDetails> result = await _getTaskByIdUsecase.execute(event.id);

    result.fold((left) {
      event.overlayLoading.hideLoading();
      _toastController.add(left.userMessage);
    }, (right) {
      event.overlayLoading.hideLoading();
      _qrResultController.add(right);
    });

  }




  FutureOr<void> _closeStreams(CloseStreams event, Emitter<HomeState> emit) async {
    await  _toastController.close();
    await _qrResultController.close();
  }
}
