import 'package:flutter/foundation.dart';
import '../models/device.dart';
import '../services/api_service.dart';

class DeviceProvider extends ChangeNotifier {
  final ApiService _api;

  DeviceProvider(this._api);

  List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;
  bool? _filterActive;
  String _searchQuery = '';

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool? get filterActive => _filterActive;
  String get searchQuery => _searchQuery;

  void setFilter(bool? isActive) {
    _filterActive = isActive;
    notifyListeners();
    loadDevices();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
    loadDevices();
  }

  Future<void> loadDevices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _devices = await _api.listDevices(
        ListDevicesRequest(
          isActive: _filterActive,
          hostnameSearch: _searchQuery,
        ),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Create Device ──

  bool _isCreating = false;
  String? _createError;

  bool get isCreating => _isCreating;
  String? get createError => _createError;

  Future<bool> createDevice({
    required String hostname,
    required String ip,
    required String location,
    required bool isActive,
  }) async {
    _isCreating = true;
    _createError = null;
    notifyListeners();

    try {
      await _api.createDevice(
        CreateDeviceRequest(
          hostname: hostname,
          ip: ip,
          location: location,
          isActive: isActive,
        ),
      );
      _isCreating = false;
      notifyListeners();
      // Reload device list to include new device
      await loadDevices();
      return true;
    } catch (e) {
      _createError = e.toString().replaceFirst('Exception: ', '');
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  void clearCreateError() {
    _createError = null;
    notifyListeners();
  }

  Device? getDeviceById(int id) {
    try {
      return _devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
