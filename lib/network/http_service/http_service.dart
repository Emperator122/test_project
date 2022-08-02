import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/network/http_service/exceptions.dart';
import 'package:test_project/network/preferences/endpoints.dart';
import 'package:test_project/network/preferences/network_preferences.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static final HttpService _httpService = HttpService._build();

  late final NetworkPreferences preferences;

  factory HttpService() {
    return _httpService;
  }

  HttpService._build() {
    preferences = NetworkPreferences();
  }

  Future<dynamic> makeRequest({
    required String uri,
    HttpMethod httpMethod = HttpMethod.get,
    Map<String, dynamic>? body,
  }) async {
    void log(String logMessage) {
      if (kDebugMode) {
        print('-- Http Call \n$logMessage');
      }
    }

    final stringBody = body != null ? json.encode(body) : null;
    final headers = _buildRequestHeaders();

    // send request
    final requestUrl = '${preferences.currentEndpoint.toUrl()}/$uri';
    log('${httpMethod.name} $requestUrl');

    http.Response response;
    try {
      response = await _doRequest(httpMethod, requestUrl, stringBody, headers);
      log(
        'Response CODE: ${response.statusCode}\n'
        'Response BODY:\n'
        '${response.body}',
      );
    } catch (e, stacktrace) {
      log('REQUEST FAILED!\n$e\n$stacktrace');
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw HttpNoInternetException(requestUrl, e.toString());
      }
      throw HttpClientException(requestUrl, e.toString());
    }

    // parse json
    dynamic responseJson;
    try {
      responseJson = json.decode(response.body)!;
    } catch (e, stacktrace) {
      log('Response PARSING FAILED!\n$e\n$stacktrace');
      throw HttpJsonDecodeException(
        requestUrl,
        response.statusCode,
        response.reasonPhrase,
        response.body,
      );
    }

    return responseJson;
  }

  Future<http.Response> _doRequest(
    HttpMethod httpMethod,
    String requestUrl,
    String? body,
    Map<String, String> headers,
  ) async {
    final uri = Uri.parse(requestUrl);
    switch (httpMethod) {
      case HttpMethod.post:
        return http.post(
          uri,
          body: body,
          headers: headers,
        );
      case HttpMethod.put:
        return http.put(
          uri,
          body: body,
          headers: headers,
        );
      case HttpMethod.get:
        return http.get(
          uri,
          headers: headers,
        );
      case HttpMethod.delete:
        return http.delete(
          uri,
          body: body,
          headers: headers,
        );
    }
  }

  Map<String, String> _buildRequestHeaders() {
    final headers = <String, String>{};
    headers['Content-type'] = 'application/json; charset=UTF-8';
    return headers;
  }
}

enum HttpMethod {
  post,
  put,
  get,
  delete,
}

extension HttpMethodExt on HttpMethod {
  String get name {
    switch (this) {
      case HttpMethod.post:
        return 'POST';

      case HttpMethod.put:
        return 'PUT';

      case HttpMethod.get:
        return 'GET';

      case HttpMethod.delete:
        return 'DELETE';
    }
  }
}
