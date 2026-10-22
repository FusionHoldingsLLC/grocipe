part of 'network.dart';

final networkProvider = Provider<Network>((ref) => Network());

class Network {
  static const connectTimeOut = Duration(seconds: 120);
  static const receiverTimeOut = Duration(seconds: 120);
  late Dio dio;
  late bool showLog;

  final _dioBaseOptions = BaseOptions(
    connectTimeout: connectTimeOut,
    receiveTimeout: receiverTimeOut,
    baseUrl: UrlConfig.baseUrl,
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  );

  Network({String? baseUrl, this.showLog = false}) {
    dio = Dio();
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(ErrorInterceptor());

    dio.options = _dioBaseOptions;
    if (baseUrl != null) dio.options.baseUrl = baseUrl;
    if (showLog) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, logPrint: printDioLogs),
      );
    }
  }

  Network.noInterceptor([String? baseUrl]) {
    dio = Dio();
    if (baseUrl != null) dio.options.baseUrl = baseUrl;
    dio.options = _dioBaseOptions;
  }

  /// Factory constructor used mainly for injecting an instance of [Dio] mock
  Network.test(this.dio);

  Future<Response> call(
    String path,
    RequestMethod method, {
    Map<String, dynamic>? queryParams,
    data,
    FormData? formData,
    ResponseType responseType = ResponseType.json,
    String classTag = '',
    bool showLog = false,
    bool useUrlEncoded = false,
  }) async {
    Response? response;
    var params = queryParams ?? {};
    final headerOverride = useUrlEncoded
        ? {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
          }
        : null;

    try {
      switch (method) {
        case RequestMethod.post:
          response = await dio.post(
            path,
            queryParameters: params,
            data: data ?? formData,
            options: Options(
              responseType: responseType,
              headers: headerOverride,
            ),
          );
          break;
        case RequestMethod.get:
          response = await dio.get(path, queryParameters: params);
          break;
        case RequestMethod.put:
          response = await dio.put(path, queryParameters: params, data: data);
          break;
        case RequestMethod.patch:
          response = await dio.patch(path, queryParameters: params, data: data);
          break;
        case RequestMethod.delete:
          response = await dio.delete(
            path,
            queryParameters: params,
            data: data,
          );
          break;
        case RequestMethod.upload:
          response = await dio.post(
            path,
            data: formData,
            queryParameters: params,
            options: Options(headers: {
              "Content-Disposition": "form-data",
              "Content-Type": "multipart/form-data",
            }),
            onSendProgress: (sent, total) {
              eventBus.fire(FileTransferProgressEvent(sent, total, classTag));
            },
          );
          break;
      }
      if (showLog) devLog("$path API network response: $response");
      return response;
    } on DioException catch (error, stackTrace) {
      final apiError = ApiError.fromDioError(error);
      if (showLog) {
        devLog("$path: ${error.response?.statusCode} code");
        devLog("API response: ${error.response}");
      }
      return Future.error(apiError, stackTrace);
    } catch (_) {
      rethrow;
    }
  }

  Future<String?> getResponseType(String url) async {
    try {
      final res = await Dio().get(url);
      return res.headers.value("Content-Type");
    } catch (_) {}
    return null;
  }

  Future<File> downloadFile({
    required String url,
    required String savePath,
  }) async {
    try {
      Response response = await Dio().get(
        url,
        onReceiveProgress: (received, total) {
          eventBus.fire(FileTransferProgressEvent(received, total, savePath));
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      rethrow;
    }
  }
}

enum RequestMethod { post, get, put, delete, upload, patch }
