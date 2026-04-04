import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';

abstract class ApiService {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);
  Future<User> getUser(int id);
  Future<List<User>> listUsers(ListUsersRequest request);
  Future<User> updateUser(UpdateUserRequest request);
  Future<void> deleteUser(int id);

  Future<Device> createDevice(CreateDeviceRequest request);
  Future<Device> getDevice(int id);
  Future<List<Device>> listDevices(ListDevicesRequest request);
  Future<Device> updateDevice(UpdateDeviceRequest request);
  Future<void> deleteDevice(int id);

  Future<DeviceConfig> createConfig(CreateConfigRequest request);
  Future<DeviceConfig> getConfig(int id);
  Future<ListConfigsResponse> listConfigs(ListConfigsRequest request);
  Future<DeviceConfig> updateConfig(UpdateConfigRequest request);
  Future<void> deleteConfig(int id);
  Future<ApplyConfigResponse> applyConfig(int configId);
}
