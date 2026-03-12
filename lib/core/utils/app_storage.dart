import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _id = 'user_id';
  static const _userName = 'user_name';
  static const _userEmail = 'user_email';
  static const _isVerified = 'is_verified';
  static const _isPaid = 'is_paid';
  static const _password = 'password';


  /// Save
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  Future<void> saveName(String name) async {
    await _storage.write(key: _userName, value: name);
  }
  Future<void> saveEmail(String email) async {
    await _storage.write(key: _userEmail, value: email);
  }
  Future<void> saveIsVerified(bool isVerified) async {
    await _storage.write(key: _isVerified, value: isVerified.toString());
  }
  Future<void> saveIsPaid(bool isPaid) async {
    await _storage.write(key: _isPaid, value: isPaid.toString());
  }
  Future<void> saveId(String id) async {
    await _storage.write(key: _id, value: id);
  }
  Future<void> savePassword(String password) async {
    await _storage.write(key: _password, value: password);
  }

  /// Read
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  Future<String?> getName() async {
    return await _storage.read(key: _userName);
  }
  Future<String?> getEmail() async {
    return await _storage.read(key: _userEmail);
  }
  Future<String?> getIsVerified() async {
    return await _storage.read(key: _isVerified);
  }
  Future<String?> getIsPaid() async {
    return await _storage.read(key: _isPaid);
  }
  Future<String?> getId() async {
    return await _storage.read(key: _id);
  }
  Future<String?> getPassword() async {
    return await _storage.read(key: _password);
  }
  /// Delete
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
  Future<void> clearName() async {
    await _storage.delete(key: _userName);
  }
  Future<void> clearEmail() async {
    await _storage.delete(key: _userEmail);
  }
  Future<void> clearIsVerified() async {
    await _storage.delete(key: _isVerified);
  }
  Future<void> clearIsPaid() async {
    await _storage.delete(key: _isPaid);
  }
  Future<void> clearId() async {
    await _storage.delete(key: _id);
  }
  Future<void> clearPassword() async {
    await _storage.delete(key: _password);
  }
}
