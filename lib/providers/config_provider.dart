import 'package:flutter/foundation.dart';
import '../models/config.dart';
import '../services/api_service.dart';

class ConfigProvider extends ChangeNotifier {
  final ApiService _api;

  ConfigProvider(this._api);

  List<DeviceConfig> _configs = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isApplying = false;
  String? _error;
  int _total = 0;
  int _page = 1;
  int _pageSize = 20;

  List<DeviceConfig> get configs => _configs;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isApplying => _isApplying;
  String? get error => _error;
  int get total => _total;
  int get page => _page;
  int get pageSize => _pageSize;

  Future<void> loadConfigs(int deviceId, {int page = 1}) async {
    _isLoading = true;
    _error = null;
    _page = page;
    notifyListeners();
    try {
      final response = await _api.listConfigs(
        ListConfigsRequest(deviceId: deviceId, page: page, pageSize: _pageSize),
      );
      _configs = response.configs;
      _total = response.total;
      _page = response.page;
      _pageSize = response.pageSize;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createConfig({
    required int deviceId,
    required String version,
    required String content,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _api.createConfig(
        CreateConfigRequest(
          deviceId: deviceId,
          version: version,
          content: content,
        ),
      );
      _isSaving = false;
      notifyListeners();
      await loadConfigs(deviceId);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateConfig({
    required int configId,
    required int deviceId,
    String? version,
    String? content,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _api.updateConfig(
        UpdateConfigRequest(id: configId, version: version, content: content),
      );
      _isSaving = false;
      notifyListeners();
      await loadConfigs(deviceId);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteConfig(int configId, int deviceId) async {
    _error = null;
    notifyListeners();
    try {
      await _api.deleteConfig(configId);
      await loadConfigs(deviceId);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> applyConfig(int configId, int deviceId) async {
    _isApplying = true;
    _error = null;
    notifyListeners();
    try {
      await _api.applyConfig(configId);
      _isApplying = false;
      notifyListeners();
      await loadConfigs(deviceId);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isApplying = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
