import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/data/sources/remote/base/api_caller.dart';
import 'package:suqokaz/data/sources/remote/base/app.exceptions.dart';
import 'package:suqokaz/data/sources/remote/base/endpoints.dart';

import '../../main.dart';

abstract class UserRepository {
  login(Map body);

  Future<UserModel> loginWithProvider(
      String providerType, String userID, String email, String name, String token, String profileUrl, String platform);

  Future<UserModel> signUp(String email, String password, String passwordConfirmation);

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
  static UserModel user;

  @override
  Future<UserModel> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      throw HttpException('no user logged in');
    }
    user = UserModel.fromJson(json.decode(prefs.get('userData')));
    return user;
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
    UserModel user=UserModel.fromJson(rawMap['data']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(user));
    await prefs.setString('access_token', "Bearer " + rawMap['data']['token']);
    return user;
  }

  @override
  Future<UserModel> loginWithProvider(
      String providerType, String userID, String email, String name, String token, String profileUrl, String platform) {
    // TODO: implement loginWithProvider
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
  Future<UserModel> signUp(String email,String password, String passwordConfirmation) async {
    apiCaller.setUrl(Endpoints.login.registerEndpoint);
    //reg
    final regMap = await apiCaller.postData(body: {"email":email,"password":password}) as Map;
    UserModel user=UserModel.fromJson(regMap['user']);
    //login
    apiCaller.setUrl(Endpoints.login.loginEndpoint);
    final rawMap = await apiCaller.postData(body: {"username":email,"password":password}) as Map;
    if (rawMap["statusCode"] == 403) {
      throw UnauthorisedException(rawMap["message"]);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(user));
    await prefs.setString('access_token', "Bearer " + rawMap['data']['token']);
    return user;

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



  @override
  logout() async {
    Root.user=null;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String theme = preferences.getString("theme");
    String lang=preferences.getString('languageCode');
    preferences.clear();
    preferences.setString('theme', theme);
    preferences.setString('languageCode', lang);
  }
}
