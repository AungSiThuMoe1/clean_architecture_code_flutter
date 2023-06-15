import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_advance_mvvm/app/app_prefs.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/constant.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  AppPreference _appPreference;
  DioFactory(this._appPreference);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    String language = await _appPreference.getAppLanguage();
    int _timeOut = 60 * 1000; // 1 min
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constant.token,
      DEFAULT_LANGUAGE: language // todo get lang from app prefs
    };

    dio.options = BaseOptions(
        baseUrl: Constant.baseUrl,
        connectTimeout: _timeOut,
        receiveTimeout: _timeOut,
        validateStatus: (statusCode)=> true,
        headers: headers);

    if (kReleaseMode) {
      debugPrint("release mode no logs");
    } else {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}
