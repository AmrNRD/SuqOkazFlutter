import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/data/sources/remote/base/api_caller.dart';
import 'package:suqokaz/data/sources/remote/base/app.exceptions.dart';
import 'package:suqokaz/data/sources/remote/base/endpoints.dart';
import 'package:suqokaz/utils/constants.dart';

import '../../main.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


abstract class UserRepository {
  Future<UserModel> login(String username,String password);

  Future<UserModel> loginWithFacebook(String userID, String email, String name, String token, String profileUrl, String platform);

  Future<UserModel> loginWithGoogle( String userID, String email, String name, String token, String profileUrl, String platform);

  Future<UserModel> loginWithApple( String userID, String email, String name, String token, String profileUrl, String platform);

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
  Future<UserModel> login(String username,String password) async {
    var cookieLifeTime = 120960000000;
      final client = http.Client();
      final request = Request('POST', Uri.parse('${Constants.baseUrl}/wp-json/api/flutter_user/generate_auth_cookie/?insecure=cool'))
        ..followRedirects = true;
      request.followRedirects = true;
      request.headers[HttpHeaders.contentTypeHeader] = 'application/x-www-form-urlencoded';
      request.body = convert.jsonEncode({
        "seconds": cookieLifeTime.toString(),
        "username": username,
        "password": password
      });
      final response = await client.send(request);
      final respStr = await response.stream.bytesToString();

      final body = convert.jsonDecode(respStr);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel userModel=UserModel.fromJson(body['user']);
        prefs.setString('userData', json.encode(userModel));
        await prefs.setString('access_token',body['cookie']);
        return userModel;
      } else {
        throw Exception("The username or password is incorrect.");
      }

  }




  @override
  Future<String> resendVerifyEmail() {
    // TODO: implement resendVerifyEmail
  }

  @override
  Future<String> resetPassword(String email, String token, String newPassword) {
    // TODO: implement resetPassword
  }

  @override
  Future<UserModel> signUp(String email,String password, String passwordConfirmation) async {

    try {
      String niceName = email;

      final client = http.Client();
      final request = Request('POST', Uri.parse("${Constants.baseUrl}/wp-json/api/flutter_user/register/?insecure=cool&"))
        ..followRedirects = true;
      request.followRedirects = true;
      request.headers[HttpHeaders.contentTypeHeader] = 'application/x-www-form-urlencoded';
      request.body = convert.jsonEncode({
        "user_email": email,
        "user_login": email,
        "username": email,
        "user_pass": password,
        "email": email,
        "user_nicename": niceName,
        "display_name": niceName,
        "role":  "subscriber"
      });
      final response = await client.send(request);
      final respStr = await response.stream.bytesToString();


      var body = convert.jsonDecode(respStr);
      if (response.statusCode == 200 && body["message"] == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel userModel=await getUserInfo(body['cookie']);
        prefs.setString('userData', json.encode(userModel));
        await prefs.setString('access_token', body['cookie']);
        return userModel;
      } else {
        var message = body["message"];
        throw Exception(message != null ? message : "Can not create the user.");
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }

  }

  Future<UserModel> getUserInfo(cookie) async {
    try {
      final http.Response response = await http.get(
          "${Constants.baseUrl}/wp-json/api/flutter_user/get_currentuserinfo?cookie=$cookie");
      final body = convert.jsonDecode(response.body);
      print("json out of /wp-json/api/flutter_user/get_currentuserinfo?cookie=");
      print(body);
      if (response.statusCode == 200 && body["user"] != null) {
        var user = body['user'];
        return UserModel.fromJsonFB(user);
      } else {
        throw Exception(body["message"]);
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<UserModel> update(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token=prefs.getString('access_token');
    print(token);

    final body = convert.jsonEncode({...user.toUpdateJson(), "cookie": token});

    final http.Response response = await http.post("${Constants.baseUrl}/wp-json/api/flutter_user/update_user_profile", body: body);
    print(response.body);
    if (response.statusCode == 200) {
      UserModel userModel=UserModel.fromJson(jsonDecode(response.body));
      prefs.setString('userData', json.encode(userModel));
      return userModel;
    } else {
      throw Exception(Constants.isRTL ? "خطأ اثناء تحديث البيانات, حاول لاحقا" : "Can not update user info");
    }
  }

  @override
  Future<UserModel> updateProfilePicture(String photo, String name) {

  }

  @override
  Future<String> verifyEmail(int code) {
    // TODO: implement verifyEmail

  }



  @override
  logout() async {
    Root.user=null;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String theme = preferences.getString("theme");
    String lang=preferences.getString('languageCode');
    await preferences.clear();
    await preferences.setString('theme', theme);
    print(preferences.getString('userData'));
    await preferences.setString('languageCode', lang);
  }

  @override
  Future<UserModel> loginWithApple(String userID, String email, String name, String token, String profileUrl, String platform) async {
    var endPoint = "${Constants.baseUrl}/wp-json/api/flutter_user/apple_login?email=$email&display_name=$name&user_name=${email.split("@")[0]}";

    var response = await http.get(endPoint);

    var jsonDecode = convert.jsonDecode(response.body);

    UserModel user=UserModel.fromJsonFB(jsonDecode);
    String tokene = jsonDecode['cookie'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(user));
    await prefs.setString('access_token', "Bearer " + tokene);
    return user;
  }

  @override
  Future<UserModel> loginWithFacebook(String userID, String email, String name, String token, String profileUrl, String platform) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint = "${Constants.baseUrl}/wp-json/api/flutter_user/fb_connect/?second=$cookieLifeTime""&access_token=$token";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode["cookie"] == null) {
        throw Exception(jsonDecode['msg']);
      }

      UserModel user=UserModel.fromJsonFB(jsonDecode);
      String tokene = jsonDecode['cookie'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', json.encode(user));
      await prefs.setString('access_token', "Bearer " + tokene);

      return user;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<UserModel> loginWithGoogle( String userID, String email, String name, String token, String profileUrl, String platform) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint =
          "${Constants.baseUrl}/wp-json/api/flutter_user/google_login/?second=$cookieLifeTime"
          "&access_token=$token";

      var response = await http.get(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode["cookie"] == null) {
        throw Exception(jsonDecode['error']);
      }
      UserModel user=UserModel.fromJsonFB(jsonDecode);
      String token_f = jsonDecode['cookie'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', json.encode(user));
      await prefs.setString('access_token', "Bearer " + token_f);
      return user;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }
}
