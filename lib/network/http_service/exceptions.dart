abstract class HttpException implements Exception {
  final String requestUrl;

  HttpException(this.requestUrl);

  String get userMessage;

  Map<String, String> get extras => {
    'url': requestUrl,
  };
}

class HttpClientException extends HttpException {
  final String debugInfo;

  HttpClientException(
      String requestUrl,
      this.debugInfo,
      ) : super(requestUrl);

  @override
  String get userMessage => 'Ошибка Http клиента';

  @override
  Map<String, String> get extras => {
    ...super.extras,
    'debugInfo': debugInfo,
  };

  @override
  String toString() {
    return 'HttpClientException{requestUrl:$requestUrl debugInfo: $debugInfo}';
  }
}

class HttpNoInternetException extends HttpClientException {
  HttpNoInternetException(
      String requestUrl,
      String debugInfo,
      ) : super(requestUrl, debugInfo);

  @override
  String get userMessage => 'Нет интернет соединения';
}

abstract class HttpResponseException extends HttpException {
  final int responseCode;

  final String? responseMessage;

  final String responseBody;

  HttpResponseException(
      String requestUrl,
      this.responseCode,
      this.responseMessage,
      this.responseBody,
      ) : super(requestUrl);

  @override
  Map<String, String> get extras => {
    ...super.extras,
    'responseCode': responseCode.toString(),
    'responseMessage': responseMessage ?? '<null>',
    'responseBody': responseBody,
  };

  @override
  String toString() {
    return 'HttpResponseException{'
        'requestUrl:$requestUrl '
        'responseCode: $responseCode '
        'responseMessage: $responseMessage '
        'responseBody: $responseBody '
        '}';
  }
}

class HttpJsonDecodeException extends HttpResponseException {
  HttpJsonDecodeException(
      String requestUrl,
      int responseCode,
      String? responseMessage,
      String responseBody,
      ) : super(requestUrl, responseCode, responseMessage,
      responseBody);

  @override
  String get userMessage => 'Ошибка расшифроки Json';
}
