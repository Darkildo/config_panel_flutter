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

  factory DeviceConfig.fromJson(Map<String, dynamic> json) {
    return DeviceConfig(
      id: json['id'] as int,
      deviceId: json['device_id'] as int,
      version: json['version'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      appliedAt: json['applied_at'] != null
          ? DateTime.parse(json['applied_at'] as String)
          : null,
    );
  }

  DeviceConfig copyWith({DateTime? appliedAt}) {
    return DeviceConfig(
      id: id,
      deviceId: deviceId,
      version: version,
      content: content,
      createdAt: createdAt,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'device_id': deviceId,
    'version': version,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    'applied_at': appliedAt?.toIso8601String(),
  };
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

  Map<String, dynamic> toJson() => {
    'device_id': deviceId,
    'version': version,
    'content': content,
  };
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

class ApplyConfigResponse {
  final bool success;
  final DateTime appliedAt;

  const ApplyConfigResponse({required this.success, required this.appliedAt});
}
