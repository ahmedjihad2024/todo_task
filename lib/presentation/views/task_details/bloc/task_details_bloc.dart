import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/presentation/common/capture_widget.dart';

import '../../../../data/network/error_handler/failure.dart';
import '../../../../data/request/request.dart';
import '../../../../domain/model/models.dart';
import '../../../../domain/usecase/update_task_usecase.dart';
import '../../../common/state_render.dart';
import '../../home/bloc/home_bloc.dart';

part 'task_details_event.dart';

part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final Repository _repository;
  late UpdateTaskUsecase _updateTaskUsecase;

  TaskDetailsBloc(this._repository) : super(TaskDetailsState()) {
    on<UpdateTaskEvent>(_updateTask);
    on<SaveQrAsImage>(_saveQrAsImage);

    _updateTaskUsecase = UpdateTaskUsecase(_repository);
  }

  FutureOr<void> _updateTask(
      UpdateTaskEvent event, Emitter<TaskDetailsState> emit) async {
    emit(state.copy(reqState: ReqState.loading));
    Either<Failure, TaskDetails> response =
        await _updateTaskUsecase.execute(UpdateTaskRequest(
      id: event.id,
          status: event.status
    ));

    response.fold((left) {
      emit(
          state.copy(errorMessage: left.userMessage, reqState: ReqState.error));
    }, (right) {
      emit(state.copy(reqState: ReqState.success));
    });
  }


  FutureOr<void> _saveQrAsImage(SaveQrAsImage event, Emitter<TaskDetailsState> emit) async {
    if((await Permission.manageExternalStorage.status).isDenied && !Platform.isWindows ){
      var result = await [
        Permission.manageExternalStorage
      ].request();
      if (!result[Permission.manageExternalStorage]!.isGranted) return;
    }
    var directory = Platform.isWindows ? (await getDownloadsDirectory())! : Directory("/storage/emulated/0/Download");
    if(!(await directory.exists())) await directory.create();
    await event.controller.captureAndSaveAsImage(path: directory.path);
    emit(
        state.copy(
            reqState: ReqState.toastError,
            errorMessage: "Image Saved"
        )
    );
  }
}
