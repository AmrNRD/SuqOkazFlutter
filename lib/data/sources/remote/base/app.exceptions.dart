class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    if(_message is String){
      String _msg = _message.replaceAll('\$', '\n');
      _msg = _msg.replaceAll('"', '');
      _msg = _msg.trim();
      _msg = "\n" + _msg;
      return "$_prefix$_msg";
    }else{
      return "$_message";
    }
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class ServerErrorException extends AppException {
  ServerErrorException([message]) : super(message, "Please Try again later: ");
}

class UnprocessableEntity extends AppException {
  UnprocessableEntity([message]) : super(message, "Please fix the following errors: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([String message]) : super(message, "Request time out: ");
}
