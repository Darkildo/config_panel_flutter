class DeviceConfig {
  final int id;
  final int deviceId;
  final String version;
  final String content;
  final DateTime createdAt;
  final DateTime? appliedAt;

  const DeviceConfig({
    required this.id,
    required this.deviceId,
    required this.version,
    required this.content,
    required this.createdAt,
    this.appliedAt,
  });

  bool get isApplied => appliedAt != null;

  DeviceConfig copyWith({
    String? version,
    String? content,
    DateTime? appliedAt,
  }) {
    return DeviceConfig(
      id: id,
      deviceId: deviceId,
      version: version ?? this.version,
      content: content ?? this.content,
      createdAt: createdAt,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}

class CreateConfigRequest {
  final int deviceId;
  final String version;
  final String content;

  const CreateConfigRequest({
    required this.deviceId,
    required this.version,
    required this.content,
  });
}

class GetConfigRequest {
  final int id;

  const GetConfigRequest({required this.id});
}

class ListConfigsRequest {
  final int deviceId;
  final int page;
  final int pageSize;

  const ListConfigsRequest({
    required this.deviceId,
    this.page = 1,
    this.pageSize = 20,
  });
}

class ListConfigsResponse {
  final List<DeviceConfig> configs;
  final int total;
  final int page;
  final int pageSize;

  const ListConfigsResponse({
    required this.configs,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class UpdateConfigRequest {
  final int id;
  final String? version;
  final String? content;

  const UpdateConfigRequest({required this.id, this.version, this.content});
}

class DeleteConfigRequest {
  final int id;

  const DeleteConfigRequest({required this.id});
}

class ApplyConfigResponse {
  final bool success;
  final DateTime appliedAt;

  const ApplyConfigResponse({required this.success, required this.appliedAt});
}
