part of 'sign_up_bloc.dart';

class SignUpState {
  final ReqState reqState;
  final String? errorMessage;
  const SignUpState({
    this.errorMessage,
    this.reqState = ReqState.idle
  });

  SignUpState copy({
    ReqState? reqState,
    String? errorMessage,
  }){
    return SignUpState(
      reqState: reqState ?? this.reqState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
