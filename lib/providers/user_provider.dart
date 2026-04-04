import 'package:flutter/foundation.dart';
import '../models/auth.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _api;

  UserProvider(this._api);

  List<User> _users = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  String _searchQuery = '';

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
    loadUsers();
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _api.listUsers(
        ListUsersRequest(loginSearch: _searchQuery),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser({
    required int id,
    String? login,
    String? password,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _api.updateUser(
        UpdateUserRequest(id: id, login: login, password: password),
      );
      _isSaving = false;
      notifyListeners();
      await loadUsers();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    _error = null;
    notifyListeners();
    try {
      await _api.deleteUser(id);
      await loadUsers();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
