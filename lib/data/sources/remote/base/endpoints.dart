
import 'package:suqokaz/utils/constants.dart';

class _Keys {
  final consumerKey = Constants.consumerKey;
  final consumerSecret = Constants.consumerSecret;
}

class _Login {
  final auth = Constants.baseUrl + "/wp-json/wc/v3";
  final loginEndpoint = Constants.baseUrl + "/wp-json/jwt-auth/v1/token";
}

class _MyList {
  final list = Constants.baseUrl + "/api/list";
}

class Endpoints {
  static final keys = _Keys();
  static final login = _Login();
  static final myList = _MyList();
}
