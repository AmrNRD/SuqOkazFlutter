import 'package:shared_preferences/shared_preferences.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/data/sources/remote/base/api_caller.dart';
import 'package:suqokaz/data/sources/remote/base/app.exceptions.dart';
import 'package:suqokaz/data/sources/remote/base/endpoints.dart';

abstract class UserRepository {
  login(Map body);

  Future<UserModel> loginWithProvider(
      String providerType, String userID, String email, String name, String token, String profileUrl, String platform);

  Future<UserModel> signUp(String email, String name, String password, String passwordConfirmation, String platform);

  Future<String> verifyEmail(int code);

  Future<String> resendVerifyEmail();

  Future<UserModel> update(UserModel user);
  Future<UserModel> updateProfilePicture(String photo, String name);

  Future<String> forgetPassword(String email);

  Future<String> resetPassword(String email, String token, String newPassword);

  Future<UserModel> fetchUserData();
  Future<UserModel> loadUserData();
  logout();
}

class UserDataRepository implements UserRepository {
  APICaller apiCaller = new APICaller();
  static String userToken;

  getUserToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userToken = prefs.getString('access_token');
      return userToken;
    } catch (e) {
      return null;
    }
  }

  saveUserPrefrence(rawMap, {saveToken = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("done 11");
    if (saveToken) {
      await prefs.setString(
        'access_token',
        "Bearer " + rawMap['data']['token'],
      );
    }
  }

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
  login(Map body) async {
    apiCaller.setUrl(Endpoints.login.loginEndpoint);
    final rawMap = await apiCaller.postData(body: body) as Map;
    if (rawMap["statusCode"] == 403) {
      throw UnauthorisedException(rawMap["message"]);
    }
    await saveUserPrefrence(rawMap);
    print("done");
  }

  @override
  Future<UserModel> loginWithProvider(
      String providerType, String userID, String email, String name, String token, String profileUrl, String platform) {
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
