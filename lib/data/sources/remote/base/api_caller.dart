import 'dart:collection';
import 'dart:io';
import "dart:async";
import 'dart:math';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';
import '../../../../main.dart';
import 'app.exceptions.dart';
import 'endpoints.dart';

class APICaller {
  String _url = Constants.baseUrl;

  setUrl(String url) {
    this._url = url;
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get OAuth URL
  getOAuthURL(String requestMethod, String endpoint, bool isHttps) {
    var token = "";
    String url = Endpoints.login.auth.replaceFirst("langCode/", Root.locale.languageCode ?? "en" + "/") + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=" + Endpoints.keys.consumerKey + "&consumer_secret=" + Endpoints.keys.consumerSecret
              : "?consumer_key=" + Endpoints.keys.consumerKey + "&consumer_secret=" + Endpoints.keys.consumerSecret);
    }

    var rand = Random();
    var codeUnits = List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = String.fromCharCodes(codeUnits);
    int timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

    var method = requestMethod;
    var parameters = "oauth_consumer_key=" +
        Endpoints.keys.consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = '$parameterString${Uri.encodeQueryComponent(key)}=${treeMap[key]}&';
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);
    parameterString = parameterString.replaceAll(' ', '%20');

    final baseString = method +
        "&" +
        Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    final signingKey = Endpoints.keys.consumerSecret + "&" + token;

    final hmacSha1 = crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    final signature = hmacSha1.convert(utf8.encode(baseString));

    final finalSignature = base64Encode(signature.bytes);

    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl =
          url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    }
    return requestUrl;
  }

  Future<dynamic> getData({Map<String, String> headers, bool needAuthorization = false}) async {
    if (headers == null) {
      headers = {};
    }
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";

    if (needAuthorization) {
      headers["Authorization"] = await getToken();
    }
    try {
      final res = await http.get(Uri.encodeFull(_url), headers: headers).timeout(
          const Duration(
            seconds: 20,
          ), onTimeout: () {
        throw RequestTimeOutException("Poor internet or no internet connectivity");
      });
      var dataRetrived = _returnResponse(res);
      return dataRetrived;
    } on SocketException {
      return [];
    }
  }

  Future<dynamic> postData({Map body, Map<String, String> headers, bool needAuthorization = false}) async {
    if (headers == null) {
      headers = {};
    }
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";

    if (needAuthorization) {
      headers["Authorization"] = await getToken();
    }
    if (body == null) {
      body = {};
    }
    try {
      final res = await http.post(Uri.encodeFull(_url), headers: headers, body: json.encode(body)).timeout(
          const Duration(
            seconds: 20,
          ), onTimeout: () {
        throw RequestTimeOutException("Poor internet or no internet connectivity");
      });
      var dataRetrived = _returnResponse(res);
      return dataRetrived;
    } on SocketException {
      return [];
    }
  }

  Future<dynamic> deleteData({Map<String, String> headers, bool needAuthorization = false}) async {
    if (headers == null) {
      headers = {};
    }
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";

    if (needAuthorization) {
      headers["Authorization"] = "Bearer " + await getToken();
    }
    try {
      final res = await http.delete(Uri.encodeFull(_url), headers: headers).timeout(
          const Duration(
            seconds: 20,
          ), onTimeout: () {
        throw RequestTimeOutException("Poor internet or no internet connectivity");
      });
      var dataRetrived = _returnResponse(res);
      return dataRetrived;
    } on SocketException {
      return [];
    }
  }

  Future<dynamic> putData({Map body, Map<String, String> headers, bool needAuthorization}) async {
    if (headers == null) {
      headers = {};
    }
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";

    if (needAuthorization) {
      headers["Authorization"] = await getToken();
    }
    print(headers);
    if (body == null) {
      body = {};
    }
    try {
      final res = await http.put(Uri.encodeFull(_url), headers: headers, body: json.encode(body)).timeout(
          const Duration(
            seconds: 20,
          ), onTimeout: () {
        throw RequestTimeOutException("Poor internet or no internet connectivity");
      });
      var dataRetrived = _returnResponse(res);
      return dataRetrived;
    } on SocketException {
      return [];
    }
  }

  _returnResponse(http.Response response) {
    print(response.statusCode);
    //print(response.headers);
    print(response.body);
    print(response.request);
    switch (response.statusCode) {
      case 200:
        final responseBody = json.decode(response.body);
        return responseBody;
      case 201:
        final responseBody = json.decode(response.body);
        return responseBody;
      case 400:
        throw BadRequestException("Server error please try again later.");
      case 401:
        final responseBody = json.decode(response.body);
        throw UnauthorisedException(responseBody["message"]);
      case 403:
        final responseBody = json.decode(response.body);
        throw UnauthorisedException(responseBody["message"]);
      case 409:
        final responseBody = json.decode(response.body);
        throw InvalidInputException(responseBody["message"]);
      case 404:
        throw BadRequestException("Internal server error, please try again later");
      case 422:
        final responseBody = json.decode(response.body);
        throw UnprocessableEntity(responseBody["message"]);
      case 500:
        throw ServerErrorException(response.statusCode);
      case 503:
        break;
      default:
        throw FetchDataException(
          "Error occured while communicating with Server with StatusCode : ${response.statusCode}",
        );
    }
  }
}
