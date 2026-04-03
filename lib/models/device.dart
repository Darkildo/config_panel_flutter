/// Device model matching proto/v1/device.proto — DeviceResponse
class Device {
  final int id;
  final String hostname;
  final String ip;
  final String location;
  final bool isActive;
  final DateTime createdAt;

  const Device({
    required this.id,
    required this.hostname,
    required this.ip,
    required this.location,
    required this.isActive,
    required this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      hostname: json['hostname'] as String,
      ip: json['ip'] as String,
      location: json['location'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostname': hostname,
    'ip': ip,
    'location': location,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
  };
}

/// Matches ListDevicesRequest
class ListDevicesRequest {
  final bool? isActive;
  final String hostnameSearch;

  const ListDevicesRequest({this.isActive, this.hostnameSearch = ''});
}

/// Matches CreateDeviceRequest
class CreateDeviceRequest {
  final String hostname;
  final String ip;
  final String location;
  final bool isActive;

  const CreateDeviceRequest({
    required this.hostname,
    required this.ip,
    required this.location,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'hostname': hostname,
    'ip': ip,
    'location': location,
    'is_active': isActive,
  };
}
