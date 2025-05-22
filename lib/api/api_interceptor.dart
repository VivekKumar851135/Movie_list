import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiInterceptor extends Interceptor {
  final String watchmodeApiKey = 'rDiPBDGNyiS2mdiCIO2OVAaNHrJ5tmnODZ7EfDej';
  final String omdbApiKey = '66d21b38';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    
    if (options.uri.host == 'api.watchmode.com') {
      options.queryParameters['apiKey'] = watchmodeApiKey;
    } else if (options.uri.host == 'www.omdbapi.com') {
      options.queryParameters['apikey'] = omdbApiKey;
    }
    
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
