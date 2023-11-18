import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/src/retry_not_supported_exception.dart';

import 'package:spade_lite/Common/api_handler/api_response.dart';

Response handleError(DioException e) {
  Response response;
  switch (e.type) {
    case DioExceptionType.cancel:
      response = Response(
        data: apiResponse(
          message: 'Request cancelled!',
        ),
        requestOptions: RequestOptions(path: ''),
      );
      break;
    case DioExceptionType.connectionTimeout:
      response = Response(
        data: apiResponse(
          message: 'Network connection timed out!',
        ),
        requestOptions: RequestOptions(path: ''),
      );
      break;
    case DioExceptionType.receiveTimeout:
      response = Response(
        data: apiResponse(
          message: 'Something went wrong. Please try again later!',
        ),
        requestOptions: RequestOptions(path: ''),
      );
      break;
    case DioExceptionType.sendTimeout:
      response = Response(
        data: apiResponse(
          message: 'Something went wrong. Please try again later',
        ),
        requestOptions: RequestOptions(path: ''),
      );
      break;
    case DioExceptionType.unknown:
      if (e.error is SocketException) {
        response = Response(
          data: apiResponse(
            message: 'Please check your network connection!',
          ),
          requestOptions: RequestOptions(path: ''),
        );
      } else if (e.error is HttpException) {
        response = Response(
          data: apiResponse(
            message: 'Network connection issue',
          ),
          requestOptions: RequestOptions(path: ''),
        );
      } else if (e.error is RetryNotSupportedException) {
        response = Response(
          data: apiResponse(
            message: 'Network connection issue. Please try again later',
          ),
          requestOptions: RequestOptions(path: ''),
        );
      } else {
        log(e.error.toString());
        response = Response(
          data: apiResponse(
            message: 'Something went wrong. Please try again later',
          ),
          requestOptions: RequestOptions(path: ''),
        );
      }
      break;
    case DioExceptionType.badResponse:
      if (e.response?.data.runtimeType == String) {
        response = Response(
          data: apiResponse(
            message: e.response?.data ??
                'Something went wrong. Please try again later',
            data: {
              'error': true,
              'message': 'Something went wrong. Please try again later',
              'details': e.response?.data,
            },
          ),
          statusCode: e.response?.statusCode ?? 000,
          statusMessage: e.response?.statusMessage ?? 'NULL',
          requestOptions: RequestOptions(path: ''),
        );
      } else {
        response = Response(
          data: apiResponse(
            message: e.response?.data?['message'] ??
                'Something went wrong. Please try again later',
            data: e.response?.data,
          ),
          statusCode: e.response?.statusCode ?? 000,
          statusMessage: e.response?.statusMessage ?? 'NULL',
          requestOptions: RequestOptions(path: ''),
        );
      }
    default:
      if (e.response?.data.runtimeType == String &&
          e.error.toString().contains('404')) {
        response = Response(
          data: apiResponse(
            data: e.response?.data,
            message: 'An error occurred, please try again',
            errorCode: 404,
          ),
          requestOptions: RequestOptions(path: ''),
        );
      } else if (e.response?.data.runtimeType == String &&
          e.error.toString().contains('400')) {
        try {
          response = Response(
            data: apiResponse(
              data: e.response?.data,
              message: e.response?.data['message'] ??
                  'An error occurred, please try again',
              errorfield: e.response?.data['errorField'] ?? 'null',
              errorCode: 400,
            ),
            requestOptions: RequestOptions(path: ''),
          );
        } catch (e) {
          response = Response(
            data: apiResponse(
              message: 'An error occurred, please try again',
              errorCode: 400,
            ),
            requestOptions: RequestOptions(path: ''),
          );
        }
      } else {
        response = Response(
            data: apiResponse(
                data: e.response?.data,
                message: (e.response?.data?.isNotEmpty ?? false)
                    ? e.response?.data['message']
                    : 'NULL',
                errorfield: e.response?.data['errorField'] ?? 'null',
                errorCode: (e.response?.data?.isNotEmpty ?? false)
                    ? e.response?.data['errorCode']
                    : 000),
            statusCode: e.response?.statusCode ?? 000,
            requestOptions: RequestOptions(path: ''));
      }
  }
  return response;
}
