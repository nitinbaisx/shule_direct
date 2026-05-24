import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'jwt_token';
  static const String _emailKey = 'user_email';

  String _deletedMessagesKey(int conversationId) =>
      'deleted_msgs_$conversationId';

  SecureStorage(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _emailKey);
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  Future<Set<int>> getDeletedMessageIds(int conversationId) async {
    final raw = await _storage.read(key: _deletedMessagesKey(conversationId));
    if (raw == null || raw.isEmpty) return {};
    return raw
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .where((id) => id > 0)
        .toSet();
  }

  Future<void> addDeletedMessageId(int conversationId, int messageId) async {
    if (messageId <= 0) return;
    final ids = await getDeletedMessageIds(conversationId);
    ids.add(messageId);
    await _storage.write(
      key: _deletedMessagesKey(conversationId),
      value: ids.join(','),
    );
  }
}
