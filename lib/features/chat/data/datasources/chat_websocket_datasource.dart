import 'package:shule_direct/core/constants/import_files.dart';

class ChatWebSocketDataSource {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _streamController;
  Timer? _reconnectTimer;
  int _conversationId = 0;
  String _token = '';
  bool _isDisposed = false;

  Stream<Map<String, dynamic>> connect({
    required int conversationId,
    required String token,
  }) {
    disconnect();
    _conversationId = conversationId;
    _token = token;
    _isDisposed = false;
    _streamController = StreamController<Map<String, dynamic>>.broadcast();
    _connect();
    return _streamController!.stream;
  }

  void _connect() {
    if (_isDisposed) return;
    try {
      final uri = Uri.parse(ApiConstants.wsChat(_conversationId, _token));
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data as String);
            if (!(_streamController?.isClosed ?? true)) {
              _streamController?.add(decoded as Map<String, dynamic>);
            }
          } catch (_) {}
        },
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), _connect);
  }

  void sendMessage(Map<String, dynamic> message) {
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (_) {}
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
    _streamController?.close();
    _streamController = null;
  }

  void dispose() {
    _isDisposed = true;
    disconnect();
  }
}
