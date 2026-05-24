import 'package:dio/dio.dart';
import 'package:shule_direct/core/constants/api_constants.dart';
import 'package:shule_direct/core/network/api_handler.dart';
import 'package:shule_direct/core/network/api_response.dart';
import 'package:shule_direct/features/auth/data/models/user_model.dart';
import 'package:shule_direct/features/chat/data/models/message_model.dart';
import 'package:shule_direct/features/conversation/data/models/conversation_model.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      if (ApiHandler.isSuccessStatus(response.statusCode)) {
        final body = ApiHandler.parseMapFromBody(response.data);
        final user = UserModel.fromLoginResponse(
          body: body,
          authorizationHeader: response.headers.value('authorization'),
          refreshTokenHeader: response.headers.value('refresh-token'),
        );
        if (user.accessToken.isEmpty) {
          return ApiResponse.failure(
            message: 'Login failed: no token received.',
          );
        }
        return ApiResponse.success(
          data: user,
          message: ApiHandler.messageFromBody(response.data) ??
              'Login successful',
        );
      }
      return ApiResponse.failure(
        message: ApiHandler.failureMessage(
          statusCode: response.statusCode,
          defaultMessage: 'Login failed. Please try again.',
          body: response.data,
        ),
      );
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: ApiHandler.messageFromDio(e, 'Invalid email or password.'),
      );
    } catch (e) {
      return ApiResponse.failure(message: e.toString());
    }
  }

  Future<ApiResponse<List<ConversationModel>>> getConversations() {
    return ApiHandler.getList<ConversationModel>(
      request: () => dio.get(ApiConstants.conversationsEndpoint),
      fromJson: ConversationModel.fromJson,
      errorMessage: 'Failed to load conversations.',
    );
  }

  Future<ApiResponse<List<MessageModel>>> getMessages({
    required int conversationId,
    required int limit,
    required int offset,
    required String currentUserEmail,
    String? ordering,
  }) {
    final queryParameters = <String, dynamic>{
      'conversation': conversationId,
      'limit': limit,
      'offset': offset,
    };
    if (ordering != null && ordering.isNotEmpty) {
      queryParameters['ordering'] = ordering;
    }

    return ApiHandler.getList<MessageModel>(
      request: () => dio.get(
        ApiConstants.messagesEndpoint,
        queryParameters: queryParameters,
      ),
      fromJson: (json) => MessageModel.fromJson(json, currentUserEmail),
      errorMessage: 'Failed to load messages.',
    );
  }

  Future<ApiResponse<MessageModel>> sendMessage({
    required int conversationId,
    required String content,
    required String type,
    required String currentUserEmail,
    int? replyTo,
  }) {
    final Map<String, dynamic> body = {
      'conversation_id': conversationId,
      'content': content,
      'type': type,
    };
    if (replyTo != null) body['reply_to'] = replyTo;

    return ApiHandler.postData<MessageModel>(
      request: () => dio.post(ApiConstants.messagesEndpoint, data: body),
      fromJson: (json) => MessageModel.fromJson(json, currentUserEmail),
      errorMessage: 'Failed to send message.',
    );
  }

  Future<ApiResponse<void>> deleteMessage(int messageId) {
    return ApiHandler.deleteData(
      request: () => dio.delete(ApiConstants.deleteMessage(messageId)),
      errorMessage: 'Failed to delete message.',
    );
  }
}
