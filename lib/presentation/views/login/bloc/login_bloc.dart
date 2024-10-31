import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_task/app/user_messages.dart';
import 'package:todo_task/data/repository/repository_impl.dart';
import 'package:todo_task/data/request/request.dart';
import 'package:todo_task/domain/usecase/log_in_usecase.dart';

import '../../../../data/network/error_handler/failure.dart';
import '../../../../domain/model/models.dart';
import '../../../common/state_render.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository _repository;
  late final LoginUsecase _loginUsecase;

  LoginBloc(this._repository) : super(const LoginState()) {
    on<SubmitLoginEvent>(_login);

    _loginUsecase = LoginUsecase(_repository);
  }

  FutureOr<void> _login(
      SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copy(reqState: ReqState.loading));

    Either<Failure, RegisterDetails> response =
        await _loginUsecase.execute(LoginRequest(event.phone, event.password));
    response.fold((left) {
      emit(state.copy(
          reqState: ReqState.error, errorMessage: left.userMessage));
    }, (right) {
      // if(right.accessToken.isNotEmpty){
      //   await instance<AppPreferences>().setAccessToken(right.accessToken);
      // await instance<AppPreferences>().setRefreshToken(right.refreshToken);
      // }
      emit(state.copy(reqState: ReqState.success));
    });
  }
}
