import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../core/constants/constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _currentUserId;
  User? _currentUser;
  String? _accessToken;

  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUserId;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _accessToken != null && _currentUserId != null;

  Future<bool> initialize() async {
    try {
      _accessToken = await _secureStorage.read(key: AppConstants.keyAuthToken);
      _currentUserId = await _secureStorage.read(key: AppConstants.keyUserId);
      
      if (_accessToken != null && _currentUserId != null) {
        try {
          final profile = await _apiService.getMyProfile();
          _currentUser = User.fromMap(profile);
          return true;
        } catch (e) {
          print('Failed to load profile or token expired: $e');
          await _clearCredentials();
          return false;
        }
      }
    } catch (e) {
      print('Auth initialization error: $e');
    }
    return false;
  }

  Future<void> _clearCredentials() async {
    await _secureStorage.delete(key: AppConstants.keyAuthToken);
    await _secureStorage.delete(key: AppConstants.keyUserId);
    await _secureStorage.delete(key: AppConstants.keyUsername);
    _accessToken = null;
    _currentUserId = null;
    _currentUser = null;
  }

  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _apiService.signup(
        email: email,
        password: password,
        username: username,
        fullName: fullName ?? username,
      );
      
      print('Backend registration successful');
      
      _accessToken = response['access_token'];
      _currentUserId = response['user_id'];
      
      await _secureStorage.write(key: AppConstants.keyAuthToken, value: _accessToken);
      await _secureStorage.write(key: AppConstants.keyUserId, value: _currentUserId);
      await _secureStorage.write(key: AppConstants.keyUsername, value: username);
      
      try {
        final profile = await _apiService.getMyProfile();
        _currentUser = User.fromMap(profile);
      } catch (e) {
        print('Profile not yet created');
      }
      
      return AuthResult(
        success: true,
        message: 'Registration successful',
        userId: _currentUserId,
        user: _currentUser,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(usernameOrEmail, password);
      
      print('Backend login successful');
      
      _accessToken = response['access_token'];
      _currentUserId = response['user_id'];
      
      await _secureStorage.write(key: AppConstants.keyAuthToken, value: _accessToken);
      await _secureStorage.write(key: AppConstants.keyUserId, value: _currentUserId);
      
      final profile = await _apiService.getMyProfile();
      _currentUser = User.fromMap(profile);
      
      await _secureStorage.write(key: AppConstants.keyUsername, value: _currentUser?.username ?? '');

      return AuthResult(
        success: true,
        message: 'Login successful',
        userId: _currentUserId,
        user: _currentUser,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
      await _clearCredentials();
    } catch (e) {
      print('Logout error: $e');
      await _clearCredentials();
    }
  }

  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUserId == null) {
      return AuthResult(success: false, message: 'Not authenticated');
    }
    return AuthResult(
      success: false,
      message: 'Password change not yet implemented',
    );
  }

  Future<AuthResult> deleteAccount(String password) async {
    if (_currentUserId == null) {
      return AuthResult(success: false, message: 'Not authenticated');
    }
    return AuthResult(
      success: false,
      message: 'Account deletion not yet implemented',
    );
  }

  Future<User?> refreshCurrentUser() async {
    if (_accessToken == null) return null;
    
    try {
      final profile = await _apiService.getMyProfile();
      _currentUser = User.fromMap(profile);
      return _currentUser;
    } catch (e) {
      print('Refresh user error: $e');
      return null;
    }
  }

  Future<AuthResult> resetPassword(String email) async {
    return AuthResult(
      success: false,
      message: 'Password reset not yet implemented',
    );
  }
}

class AuthResult {
  final bool success;
  final String message;
  final String? userId;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.userId,
    this.user,
  });
}
