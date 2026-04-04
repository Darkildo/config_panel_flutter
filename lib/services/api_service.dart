import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';

abstract class ApiService {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);

  Future<Device> createDevice(CreateDeviceRequest request);
  Future<List<Device>> listDevices(ListDevicesRequest request);

  Future<DeviceConfig> createConfig(CreateConfigRequest request);
  Future<ListConfigsResponse> listConfigs(ListConfigsRequest request);
  Future<ApplyConfigResponse> applyConfig(int configId);
}
