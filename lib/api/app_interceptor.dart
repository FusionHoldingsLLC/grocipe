part of 'network.dart';

class ApiInterceptor extends Interceptor {
  factory ApiInterceptor() => _instance;
  static final ApiInterceptor _instance = ApiInterceptor._internal();

  ApiInterceptor._internal();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = HiveFunction.instance.user?.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({
        'Authorization': 'Bearer $token',
        'token': "Bearer $token",
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403) {
      eventBus.fire(SessionExpiredEvent());
    }
    handler.next(err);
  }
}
