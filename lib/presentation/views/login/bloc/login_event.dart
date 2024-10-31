part of 'login_bloc.dart';

sealed class LoginEvent{
  const LoginEvent();
}


class SubmitLoginEvent extends LoginEvent{
  final String phone;
  final String password;

  const SubmitLoginEvent(
      this.phone,
      this.password,
      );
}

