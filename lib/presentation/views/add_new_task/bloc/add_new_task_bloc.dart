import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/domain/usecase/add_task_usecase.dart';
import 'package:todo_task/domain/usecase/update_task_usecase.dart';
import 'package:todo_task/presentation/common/state_render.dart';

import '../../../../data/network/error_handler/failure.dart';
import '../../../../domain/model/models.dart';

part 'add_new_task_event.dart';

part 'add_new_task_state.dart';

class AddNewTaskBloc extends Bloc<AddNewTaskEvent, AddNewTaskState> {
  final Repository _repository;
  late AddTaskUsecase _addTaskUsecase;
  late UpdateTaskUsecase _updateTaskUsecase;

  AddNewTaskBloc(this._repository) : super(AddNewTaskState()) {
    on<AddTaskEvent>(_addNewTask);
    on<UpdateTaskEvent>(_updateTask);

    _addTaskUsecase = AddTaskUsecase(_repository);
    _updateTaskUsecase = UpdateTaskUsecase(_repository);
  }

  FutureOr<void> _addNewTask(
      AddTaskEvent event, Emitter<AddNewTaskState> emit) async {
    emit(
      state.copy(
        reqState: ReqState.loading
      )
    );
    Either<Failure, TaskDetails> response = await _addTaskUsecase.execute(
        AddTaskRequest(
            image: event.image,
            title: event.title,
            priority: event.priority,
            description: event.description,
            dueDate: event.dueDate));

    response.fold((left) {
      emit(
          state.copy(errorMessage: left.userMessage, reqState: ReqState.error));
    }, (right) {
      emit(state.copy(reqState: ReqState.success, taskDetails: right));
    });
  }

  FutureOr<void> _updateTask(
      UpdateTaskEvent event, Emitter<AddNewTaskState> emit) async {
    emit(
        state.copy(
            reqState: ReqState.loading
        )
    );
    Either<Failure, TaskDetails> response = await _updateTaskUsecase.execute(
        UpdateTaskRequest(
          id: event.id,
            image: event.image,
            title: event.title,
            priority: event.priority,
            description: event.description,
            dueDate: event.dueDate)
    );

    response.fold((left) {
      emit(
          state.copy(errorMessage: left.userMessage, reqState: ReqState.error));
    }, (right) {
      emit(state.copy(reqState: ReqState.success, taskDetails: right));
    });
  }

}
