import 'dart:io';
import '../constants/app_constants.dart';

class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, [this.details]);

  @override
  String toString() {
    return 'AppException: $message${details != null ? ' - $details' : ''}';
  }
}

class NetworkException extends AppException {
  const NetworkException([String? details])
    : super(AppConstants.networkErrorMessage, details);
}

class ServerException extends AppException {
  const ServerException([String? details])
    : super(AppConstants.serverErrorMessage, details);
}

class TimeoutException extends AppException {
  const TimeoutException([String? details])
    : super(AppConstants.timeoutErrorMessage, details);
}

class UnknownException extends AppException {
  const UnknownException([String? details])
    : super(AppConstants.unknownErrorMessage, details);
}

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is SocketException) {
      return NetworkException(error.message);
    } else if (error is HttpException) {
      return ServerException(error.message);
    } else if (error is FormatException) {
      return const ServerException('Invalid response format');
    } else if (error is AppException) {
      return error;
    } else {
      return UnknownException(error.toString());
    }
  }

  static String getErrorMessage(dynamic error) {
    final appException = handleError(error);
    return appException.message;
  }
}
