import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/user_model.dart';

abstract class UserEvent extends Equatable {
  UserEvent();
}

class GetUser extends UserEvent {
  GetUser();
  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends UserEvent {
  final UserModel user;
  UpdateUserProfile(this.user);
  @override
  List<Object> get props => [user];
}

class UpdateUserProfilePicture extends UserEvent {
  final String photo;
  final String name;
  UpdateUserProfilePicture(this.photo, this.name);
  @override
  List<Object> get props => [photo, name];
}

class UserReportPurchase extends UserEvent {
  final int id;
  final String purchaseToken;
  final String transactionReceipt;
  final String productId;
  UserReportPurchase(this.id, this.purchaseToken, this.transactionReceipt, this.productId);

  @override
  List<Object> get props => [id, purchaseToken, transactionReceipt, productId];
}

class LoginUser extends UserEvent {
  final String email;
  final String password;
  //final String firebaseToken;
  final String platform;
  LoginUser({
    this.email,
    this.password, //this.firebaseToken
    this.platform,
  });

  @override
  List<Object> get props => [
        email, password, // firebaseToken,
        platform,
      ];
}

class LoginUserWithGoogle extends UserEvent {
  final String userID;
  final String email;
  final String token;
  final String name;
  final String profileUrl;
  final String platform;

  LoginUserWithGoogle(this.userID, this.email, this.name, this.token, this.profileUrl, this.platform);

  @override
  List<Object> get props => [userID, email, token, name, profileUrl, platform];
}

class LoginUserWithFacebook extends UserEvent {
  final String userID;
  final String email;
  final String token;
  final String name;
  final String profileUrl;
  final String platform;

  LoginUserWithFacebook(this.userID, this.email, this.name, this.token, this.profileUrl, this.platform);

  @override
  List<Object> get props => [userID, email, token, name, profileUrl, platform];
}


class LoginUserWithApple extends UserEvent {
  final String userID;
  final String email;
  final String token;
  final String name;
  final String profileUrl;
  final String platform;

  LoginUserWithApple(this.userID, this.email, this.name, this.token, this.profileUrl, this.platform);

  @override
  List<Object> get props => [userID, email, token, name, profileUrl, platform];
}

class SignUpUser extends UserEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  SignUpUser(this.email, this.password, this.passwordConfirmation);

  @override
  List<Object> get props => [email,password, passwordConfirmation];
}

class ForgotPassword extends UserEvent {
  final String email;
  ForgotPassword(this.email);
  @override
  List<Object> get props => [email];
}

class VerifyEmail extends UserEvent {
  final int code;
  VerifyEmail(this.code);
  @override
  List<Object> get props => [code];
}

class ResendVerifyEmail extends UserEvent {
  ResendVerifyEmail();
  @override
  List<Object> get props => [];
}

class FindResetPassword extends UserEvent {
  final String token;
  FindResetPassword(this.token);
  @override
  List<Object> get props => [token];
}

class ResetPassword extends UserEvent {
  final String email;
  final String token;
  final String newPassword;
  ResetPassword(this.email, this.token, this.newPassword);
  @override
  List<Object> get props => [email, token, newPassword];
}

class LogoutUser extends UserEvent {
  LogoutUser();
  @override
  List<Object> get props => [];
}
