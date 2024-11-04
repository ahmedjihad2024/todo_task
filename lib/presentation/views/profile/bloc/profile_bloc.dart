import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/model/models.dart';
import 'package:todo_task/domain/usecase/get_profile_details_usecase.dart';
import 'package:todo_task/presentation/common/state_render.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Repository _repository;
  late final GetProfileDetailsUsecase _getProfileDetailsUsecase;

  ProfileBloc(this._repository) : super(ProfileState()) {
    on<GetProfileDetails>(_getProfileDetails);

    _getProfileDetailsUsecase = GetProfileDetailsUsecase(_repository);
  }

  FutureOr<void> _getProfileDetails(GetProfileDetails event, Emitter<ProfileState> emit) async {
    var result = await _getProfileDetailsUsecase.execute(null);

    result.fold((left){
      emit(
        state.copy(
          reqState: ReqState.error,
          errorMessage: left.userMessage
        )
      );
    }, (right){
      emit(
          state.copy(
              reqState: ReqState.success,
              details: right
          )
      );
    });
  }
}
