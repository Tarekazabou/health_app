import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../core/constants/constants.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _db = DatabaseService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Uuid _uuid = const Uuid();

  String? _currentUserId;
  User? _currentUser;

  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUserId;
  bool get isAuthenticated => _currentUserId != null;

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Initialize auth service - check if user is already logged in
  Future<bool> initialize() async {
    try {
      final userId = await _secureStorage.read(key: AppConstants.keyUserId);
      if (userId != null) {
        final user = await _db.getUserById(userId);
        if (user != null) {
          _currentUserId = userId;
          _currentUser = user;
          return true;
        }
      }
    } catch (e) {
      print('Auth initialization error: $e');
    }
    return false;
  }

  // Register new user
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      // Check if username exists
      final existingUser = await _db.getUserByUsername(username);
      if (existingUser != null) {
        return AuthResult(success: false, message: 'Username already taken');
      }

      // Check if email exists
      final existingEmail = await _db.getUserByEmail(email);
      if (existingEmail != null) {
        return AuthResult(success: false, message: 'Email already registered');
      }

      // Create new user
      final userId = _uuid.v4();
      final passwordHash = _hashPassword(password);
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final user = User(
        id: userId,
        username: username,
        email: email,
        passwordHash: passwordHash,
        fullName: fullName,
        createdAt: now,
      );

      await _db.insertUser(user);
      
      return AuthResult(
        success: true,
        message: 'Registration successful',
        userId: userId,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  // Login user
  Future<AuthResult> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      // Try to find user by username or email
      User? user = await _db.getUserByUsername(usernameOrEmail);
      user ??= await _db.getUserByEmail(usernameOrEmail);

      if (user == null) {
        return AuthResult(
          success: false,
          message: 'User not found',
        );
      }

      // Verify password
      final passwordHash = _hashPassword(password);
      if (user.passwordHash != passwordHash) {
        return AuthResult(
          success: false,
          message: 'Incorrect password',
        );
      }

      // Update last login
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      user = user.copyWith(lastLogin: now);
      await _db.updateUser(user);

      // Store credentials
      _currentUserId = user.id;
      _currentUser = user;
      await _secureStorage.write(key: AppConstants.keyUserId, value: user.id);
      await _secureStorage.write(key: AppConstants.keyUsername, value: user.username);

      return AuthResult(
        success: true,
        message: 'Login successful',
        userId: user.id,
        user: user,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: AppConstants.keyUserId);
      await _secureStorage.delete(key: AppConstants.keyUsername);
      await _secureStorage.delete(key: AppConstants.keyAuthToken);
      _currentUserId = null;
      _currentUser = null;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Change password
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return AuthResult(success: false, message: 'Not authenticated');
    }

    try {
      final currentHash = _hashPassword(currentPassword);
      if (_currentUser!.passwordHash != currentHash) {
        return AuthResult(success: false, message: 'Current password is incorrect');
      }

      final newHash = _hashPassword(newPassword);
      final updatedUser = _currentUser!.copyWith(passwordHash: newHash);
      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;

      return AuthResult(success: true, message: 'Password changed successfully');
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Password change failed: ${e.toString()}',
      );
    }
  }

  // Delete account
  Future<AuthResult> deleteAccount(String password) async {
    if (_currentUser == null) {
      return AuthResult(success: false, message: 'Not authenticated');
    }

    try {
      final passwordHash = _hashPassword(password);
      if (_currentUser!.passwordHash != passwordHash) {
        return AuthResult(success: false, message: 'Incorrect password');
      }

      // Note: CASCADE delete will remove all related data
      await _db.database.then((db) => db.delete('users', where: 'id = ?', whereArgs: [_currentUser!.id]));
      await logout();

      return AuthResult(success: true, message: 'Account deleted');
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Account deletion failed: ${e.toString()}',
      );
    }
  }

  // Get current user profile
  Future<User?> refreshCurrentUser() async {
    if (_currentUserId == null) return null;
    
    try {
      final user = await _db.getUserById(_currentUserId!);
      _currentUser = user;
      return user;
    } catch (e) {
      print('Refresh user error: $e');
      return null;
    }
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
