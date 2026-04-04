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
}

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
}

class GetDeviceRequest {
  final int id;

  const GetDeviceRequest({required this.id});
}

class ListDevicesRequest {
  final bool? isActive;
  final String hostnameSearch;

  const ListDevicesRequest({this.isActive, this.hostnameSearch = ''});
}

class UpdateDeviceRequest {
  final int id;
  final String? hostname;
  final String? ip;
  final String? location;
  final bool? isActive;

  const UpdateDeviceRequest({
    required this.id,
    this.hostname,
    this.ip,
    this.location,
    this.isActive,
  });
}

class DeleteDeviceRequest {
  final int id;

  const DeleteDeviceRequest({required this.id});
}
