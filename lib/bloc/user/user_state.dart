import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/user_model.dart';

abstract class UserState {
  UserState();
}

class UserInitial extends UserState {
  UserInitial();
}

class UserLoadingState extends UserState {
  UserLoadingState();
}

class UserProfilePictureLoadingState extends UserState {
  UserProfilePictureLoadingState();
}

class UserLoadedState extends UserState {
  UserLoadedState();
}

class UserProfilePictureLoadedState extends UserState {
  UserProfilePictureLoadedState();
}

class UserSignedUpState extends UserState {
  final UserModel user;
  UserSignedUpState(this.user);
}

class UserErrorState extends UserState {
  final String message;
  UserErrorState(this.message);
}

class UserMessageState extends UserState {
  final String message;
  UserMessageState(this.message);
}

class VerifyEmailSuccessfullyState extends UserState {
  final String message;
  VerifyEmailSuccessfullyState(this.message);
}

class ResendVerifyEmailSuccessfullyState extends UserState {
  final String message;
  ResendVerifyEmailSuccessfullyState(this.message);
}

class UserLoggedOutState extends UserState {
  UserLoggedOutState();
}
