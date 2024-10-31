import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_task/app/app_preferences.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/domain/usecase/sign_up_usecase.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/enums.dart';
import '../../../../data/network/error_handler/failure.dart';
import '../../../../data/request/request.dart';
import '../../../../domain/model/models.dart';
import '../../../common/state_render.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final Repository _repository;
  late final SignUpUsecase _signUpUsecase;

  SignUpBloc(this._repository) : super(const SignUpState()) {
    on<SubmitSignUpEvent>(_signUp);

    _signUpUsecase = SignUpUsecase(_repository);
  }




  FutureOr<void> _signUp(SubmitSignUpEvent event, Emitter<SignUpState> emit) async {
    emit(state.copy(reqState: ReqState.loading));

    Either<Failure, RegisterDetails> response =
        await _signUpUsecase.execute(RegisterRequest(
          event.userName,
          event.address,
          event.password,
          event.experienceYears,
          event.level,
          event.phone
        ));
    response.fold((left) {
      print(left.userMessage);
      emit(state.copy(
          reqState: ReqState.error, errorMessage: left.userMessage));
    }, (right) async {
      // if(right.accessToken.isNotEmpty){
      //   await instance<AppPreferences>().setAccessToken(right.accessToken);
      //   await instance<AppPreferences>().setRefreshToken(right.refreshToken);
      // }
      emit(state.copy(reqState: ReqState.success));
    });
  }

}
