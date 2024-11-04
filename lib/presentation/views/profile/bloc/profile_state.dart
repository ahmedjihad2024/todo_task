part of 'profile_bloc.dart';

class ProfileState {
  final ReqState reqState;
  final String? errorMessage;
  final ProfileDetails? details;

  ProfileState(
      {this.reqState = ReqState.loading, this.errorMessage, this.details});

  ProfileState copy(
      {ReqState? reqState, String? errorMessage, ProfileDetails? details}) {
    return ProfileState(
        reqState: reqState ?? this.reqState,
        errorMessage: errorMessage ?? this.errorMessage,
        details: details ?? this.details);
  }
}
