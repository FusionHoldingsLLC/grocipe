part of 'network.dart';

class ApiError implements Exception {
  final String errorDescription;
  final dynamic data;
  final DioExceptionType? dioErrorType;
  final int? statusCode;
  static const unknownError = 'Something went wrong, please try again';
  static const internetError = 'Internet connection error, please try again';
  static const cancelError = 'API request canceled, please try again';
  static const internetError2 =
      'Please check your internet connection, seems you are offline';

  ApiError({
    required this.errorDescription,
    this.data,
    this.dioErrorType,
    this.statusCode,
  });

  factory ApiError.fromDioError(DioException error) {
    try {
      String description = '';
      switch (error.type) {
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          description = error.response?.data['detail'] ?? unknownError;
          break;
        case DioExceptionType.badResponse:
          description = extractDescriptionFromResponse(error.response);
          break;
        case DioExceptionType.cancel:
          description = cancelError;
          break;
        case DioExceptionType.unknown:
        case DioExceptionType.connectionError:
          description = unknownError;
          if (error.error is SocketException) {
            description = internetError;
          } else {
            description = unknownError;
          }
          break;
      }
      return ApiError(
        errorDescription: description,
        dioErrorType: error.type,
        data: error.response?.data != null
            ? error.response?.data['detail']
            : null,
        statusCode: error.response?.statusCode,
      );
    } catch (e) {
      return ApiError(
        errorDescription: unknownError,
      );
    }
  }

  static String extractDescriptionFromResponse(Response? response) {
    try {
      if (response == null || response.statusCode == null) {
        return unknownError;
      }

      if (response.statusCode! >= 500) {
        return 'Internal Server error, please try again later';
      }
      if (response.data != null &&
          response.data['detail']?[0]?["msg"] != null) {
        return response.data['detail'][0]["msg"] as String;
      } else if (response.data != null && response.data['detail'] != null) {
        return response.data['detail'];
      } else {
        return response.statusMessage ?? '';
      }
    } catch (error) {
      return response?.data['detail'] ?? unknownError;
    }
  }

  @override
  String toString() => errorDescription;
}
