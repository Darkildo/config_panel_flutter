import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/auth.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api;
  final TokenStorage _tokenStorage;
  final void Function(String? token)? onTokenChanged;

  String? _token;
  bool _isLoading = false;
  String? _error;
  Timer? _expiryTimer;

  AuthProvider(
    this._api, {
    required TokenStorage tokenStorage,
    this.onTokenChanged,
  }) : _tokenStorage = tokenStorage;

  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> tryRestoreSession() async {
    final token = await _tokenStorage.load();
    if (token != null) {
      _token = token;
      onTokenChanged?.call(token);
      _scheduleExpiryLogout(token);
      notifyListeners();
    }
  }

  Future<bool> login(String login, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.login(
        LoginRequest(login: login, password: password),
      );
      await _setToken(response.token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String login, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.register(
        RegisterRequest(login: login, password: password),
      );
      await _setToken(response.token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _expiryTimer?.cancel();
    _expiryTimer = null;
    _token = null;
    _error = null;
    onTokenChanged?.call(null);
    await _tokenStorage.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _setToken(String token) async {
    _token = token;
    onTokenChanged?.call(token);
    await _tokenStorage.save(token);
    _scheduleExpiryLogout(token);
  }

  void _scheduleExpiryLogout(String token) {
    _expiryTimer?.cancel();
    _expiryTimer = null;

    final remaining = TokenStorage.remainingLifetime(token);
    if (remaining == null || remaining.isNegative) {
      logout();
      return;
    }

    _expiryTimer = Timer(remaining, () {
      debugPrint('Token expired, logging out');
      logout();
    });
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}
