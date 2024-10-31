part of 'sign_up_bloc.dart';

sealed class SignUpEvent{
  const SignUpEvent();
}

class SubmitSignUpEvent extends SignUpEvent{
  final String userName;
  final String password;
  final String phone;
  final int experienceYears;
  final String address;
  final String level;

  const SubmitSignUpEvent(
      this.userName,
      this.address,
      this.password,
      this.experienceYears,
      this.level,
      this.phone
      );

}

