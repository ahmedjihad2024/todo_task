part of 'login_bloc.dart';

class LoginState {
  final ReqState reqState;
  final String? errorMessage;
  const LoginState({
    this.errorMessage,
    this.reqState = ReqState.idle
  });

  LoginState copy({
    ReqState? reqState,
    String? errorMessage,
  }){
    return LoginState(
      reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
