
import 'package:suqokaz/data/models/user_model.dart';


abstract class UserRepository {
  Future<UserModel> login(String email, String password,String platform);

  Future<UserModel> loginWithProvider(
      String providerType,
      String userID,
      String email,
      String name,
      String token,
      String profileUrl,
      String platform);

  Future<UserModel> signUp(String email, String name, String password, String passwordConfirmation,String platform);


  Future<String> verifyEmail(int code);

  Future<String> resendVerifyEmail();

  Future<UserModel> update(UserModel user);
  Future<UserModel> updateProfilePicture(String photo,String name);

  Future<String> forgetPassword(String email);

  Future<String> resetPassword(String email,String token,String newPassword);

  Future<UserModel> fetchUserData();
  Future<UserModel> loadUserData();
  logout();
}

class UserDataRepository implements UserRepository {
  @override
  Future<UserModel> fetchUserData() {
    // TODO: implement fetchUserData
    throw UnimplementedError();
  }

  @override
  Future<String> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loadUserData() {
    // TODO: implement loadUserData
    throw UnimplementedError();
  }

  @override
  Future<UserModel> login(String email, String password,  String platform) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithProvider(String providerType, String userID, String email, String name, String token,  String profileUrl, String platform) {
    // TODO: implement loginWithProvider
    throw UnimplementedError();
  }

  @override
  logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<String> resendVerifyEmail() {
    // TODO: implement resendVerifyEmail
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(String email, String token, String newPassword) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUp(String email, String name, String password, String passwordConfirmation, String platform) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<UserModel> update(UserModel user) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateProfilePicture(String photo, String name) {
    // TODO: implement updateProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<String> verifyEmail(int code) {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

}
