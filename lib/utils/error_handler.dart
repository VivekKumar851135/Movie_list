import 'package:dio/dio.dart';
import 'dart:io';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timed out. Please check your internet connection.";
        case DioExceptionType.sendTimeout:
          return "Request timed out. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Response timed out. Please try again.";
        case DioExceptionType.connectionError:
          if (error.error is SocketException) {
            return "No internet connection. Please check your network.";
          }
          return "Connection error. Please try again.";
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 400:
              return "Invalid request. Please try again.";
            case 401:
              return "Unauthorized. Please login again.";
            case 404:
              return "The requested movie was not found.";
            case 500:
              return "Server error. Please try again later.";
            default:
              return "Network error occurred. Please try again.";
          }
        default:
          return "An unexpected error occurred. Please try again.";
      }
    }
    return "Something went wrong. Please try again.";
  }
}
