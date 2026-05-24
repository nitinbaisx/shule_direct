import 'package:dio/dio.dart';
import 'package:shule_direct/core/network/api_response.dart';

class ApiHandler {
  ApiHandler._();

  static bool isSuccessStatus(int? statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  static bool isDeleteSuccess(int? statusCode) {
    return statusCode == 200 || statusCode == 201 || statusCode == 204;
  }

  static String? messageFromBody(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }

  static int? totalCountFromBody(dynamic data) {
    if (data is Map && data['count'] is num) {
      return (data['count'] as num).toInt();
    }
    return null;
  }

  static List<dynamic> _extractRawList(dynamic data) {
    if (data is List) return data;
    if (data is! Map) return [];
    if (data['results'] is List) return data['results'] as List;
    if (data['data'] is List) return data['data'] as List;
    if (data['data'] is Map && data['data']['results'] is List) {
      return data['data']['results'] as List;
    }
    return [];
  }

  static List<Map<String, dynamic>> parseListFromBody(dynamic data) {
    final raw = _extractRawList(data);
    final List<Map<String, dynamic>> result = [];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        result.add(item);
      } else if (item is Map) {
        result.add(Map<String, dynamic>.from(item));
      }
    }
    return result;
  }

  static Map<String, dynamic>? parseMapFromBody(dynamic data) {
    if (data is Map<String, dynamic>) {
      return _unwrapMessageMap(data);
    }
    if (data is Map) {
      return _unwrapMessageMap(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Map<String, dynamic>? _unwrapMessageMap(Map<String, dynamic> map) {
    final nested = map['data'];
    if (nested is Map) {
      final inner = Map<String, dynamic>.from(nested);
      if (inner['message'] is Map) {
        return Map<String, dynamic>.from(inner['message'] as Map);
      }
      if (inner['id'] != null || inner['content'] != null) {
        return inner;
      }
    }
    if (map['message'] is Map &&
        map['id'] == null &&
        map['content'] == null) {
      return Map<String, dynamic>.from(map['message'] as Map);
    }
    if (map['id'] != null || map['content'] != null) {
      return map;
    }
    return map;
  }

  static String failureMessage({
    required int? statusCode,
    required String defaultMessage,
    dynamic body,
  }) {
    if (statusCode == 401) {
      return messageFromBody(body) ?? 'Unauthorized. Please log in again.';
    }
    if (statusCode == 403) {
      return messageFromBody(body) ??
          'You are not allowed to delete this message.';
    }
    return messageFromBody(body) ?? defaultMessage;
  }

  static String messageFromDio(DioException error, String defaultMessage) {
    return failureMessage(
      statusCode: error.response?.statusCode,
      defaultMessage: defaultMessage,
      body: error.response?.data,
    );
  }

  static Future<ApiResponse<List<T>>> getList<T>({
    required Future<Response<dynamic>> Function() request,
    required T Function(Map<String, dynamic> json) fromJson,
    required String errorMessage,
  }) async {
    try {
      final response = await request();
      if (isSuccessStatus(response.statusCode)) {
        final items = parseListFromBody(response.data);
        final List<T> result = [];
        for (final map in items) {
          result.add(fromJson(map));
        }
        return ApiResponse.success(
          data: result,
          message: messageFromBody(response.data),
          totalCount: totalCountFromBody(response.data),
        );
      }
      return ApiResponse.failure(
        message: failureMessage(
          statusCode: response.statusCode,
          defaultMessage: errorMessage,
          body: response.data,
        ),
      );
    } on DioException catch (e) {
      return ApiResponse.failure(message: messageFromDio(e, errorMessage));
    } catch (e) {
      return ApiResponse.failure(message: e.toString());
    }
  }

  static Future<ApiResponse<T>> postData<T>({
    required Future<Response<dynamic>> Function() request,
    required T Function(Map<String, dynamic> json) fromJson,
    required String errorMessage,
  }) async {
    try {
      final response = await request();
      if (isSuccessStatus(response.statusCode)) {
        final map = parseMapFromBody(response.data);
        if (map != null) {
          return ApiResponse.success(
            data: fromJson(map),
            message: messageFromBody(response.data),
          );
        }
        return ApiResponse.failure(message: errorMessage);
      }
      return ApiResponse.failure(
        message: failureMessage(
          statusCode: response.statusCode,
          defaultMessage: errorMessage,
          body: response.data,
        ),
      );
    } on DioException catch (e) {
      return ApiResponse.failure(message: messageFromDio(e, errorMessage));
    } catch (e) {
      return ApiResponse.failure(message: e.toString());
    }
  }

  static Future<ApiResponse<void>> deleteData({
    required Future<Response<dynamic>> Function() request,
    required String errorMessage,
  }) async {
    try {
      final response = await request();
      if (isDeleteSuccess(response.statusCode)) {
        return ApiResponse.success(
          message: messageFromBody(response.data) ?? 'Deleted successfully',
        );
      }
      return ApiResponse.failure(
        message: failureMessage(
          statusCode: response.statusCode,
          defaultMessage: errorMessage,
          body: response.data,
        ),
      );
    } on DioException catch (e) {
      return ApiResponse.failure(message: messageFromDio(e, errorMessage));
    } catch (e) {
      return ApiResponse.failure(message: e.toString());
    }
  }
}
