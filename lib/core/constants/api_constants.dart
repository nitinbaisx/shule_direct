class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://dev-api.supersourcing.com/shuledirect-service';

  static const String wsBaseUrl =
      'wss://dev-api.supersourcing.com/shuledirect-service/ws/';

  static const String loginEndpoint = '/candidates/login/';

  static const String conversationsEndpoint = '/chat/conversations/';

  static const String messagesEndpoint = '/chat/messages/';

  static String wsChat(int conversationId, String token) =>
      '${wsBaseUrl}chat/$conversationId/?token=$token';

  static String deleteMessage(int messageId) =>
      '/chat/messages/$messageId/';
}
