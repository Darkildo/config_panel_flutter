// This is a generated file - do not edit.
//
// Generated from device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $1;

import 'device.pb.dart' as $0;

export 'device.pb.dart';

@$pb.GrpcServiceName('controlpanel.v1.DeviceService')
class DeviceServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DeviceServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.DeviceResponse> createDevice(
    $0.CreateDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeviceResponse> getDevice(
    $0.GetDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDevice, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDevicesResponse> listDevices(
    $0.ListDevicesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeviceResponse> updateDevice(
    $0.UpdateDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateDevice, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteDevice(
    $0.DeleteDeviceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteDevice, request, options: options);
  }

  // method descriptors

  static final _$createDevice =
      $grpc.ClientMethod<$0.CreateDeviceRequest, $0.DeviceResponse>(
          '/controlpanel.v1.DeviceService/CreateDevice',
          ($0.CreateDeviceRequest value) => value.writeToBuffer(),
          $0.DeviceResponse.fromBuffer);
  static final _$getDevice =
      $grpc.ClientMethod<$0.GetDeviceRequest, $0.DeviceResponse>(
          '/controlpanel.v1.DeviceService/GetDevice',
          ($0.GetDeviceRequest value) => value.writeToBuffer(),
          $0.DeviceResponse.fromBuffer);
  static final _$listDevices =
      $grpc.ClientMethod<$0.ListDevicesRequest, $0.ListDevicesResponse>(
          '/controlpanel.v1.DeviceService/ListDevices',
          ($0.ListDevicesRequest value) => value.writeToBuffer(),
          $0.ListDevicesResponse.fromBuffer);
  static final _$updateDevice =
      $grpc.ClientMethod<$0.UpdateDeviceRequest, $0.DeviceResponse>(
          '/controlpanel.v1.DeviceService/UpdateDevice',
          ($0.UpdateDeviceRequest value) => value.writeToBuffer(),
          $0.DeviceResponse.fromBuffer);
  static final _$deleteDevice =
      $grpc.ClientMethod<$0.DeleteDeviceRequest, $1.Empty>(
          '/controlpanel.v1.DeviceService/DeleteDevice',
          ($0.DeleteDeviceRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
}

@$pb.GrpcServiceName('controlpanel.v1.DeviceService')
abstract class DeviceServiceBase extends $grpc.Service {
  $core.String get $name => 'controlpanel.v1.DeviceService';

  DeviceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateDeviceRequest, $0.DeviceResponse>(
        'CreateDevice',
        createDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateDeviceRequest.fromBuffer(value),
        ($0.DeviceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDeviceRequest, $0.DeviceResponse>(
        'GetDevice',
        getDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDeviceRequest.fromBuffer(value),
        ($0.DeviceResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListDevicesRequest, $0.ListDevicesResponse>(
            'ListDevices',
            listDevices_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListDevicesRequest.fromBuffer(value),
            ($0.ListDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateDeviceRequest, $0.DeviceResponse>(
        'UpdateDevice',
        updateDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateDeviceRequest.fromBuffer(value),
        ($0.DeviceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteDeviceRequest, $1.Empty>(
        'DeleteDevice',
        deleteDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteDeviceRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.DeviceResponse> createDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateDeviceRequest> $request) async {
    return createDevice($call, await $request);
  }

  $async.Future<$0.DeviceResponse> createDevice(
      $grpc.ServiceCall call, $0.CreateDeviceRequest request);

  $async.Future<$0.DeviceResponse> getDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetDeviceRequest> $request) async {
    return getDevice($call, await $request);
  }

  $async.Future<$0.DeviceResponse> getDevice(
      $grpc.ServiceCall call, $0.GetDeviceRequest request);

  $async.Future<$0.ListDevicesResponse> listDevices_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListDevicesRequest> $request) async {
    return listDevices($call, await $request);
  }

  $async.Future<$0.ListDevicesResponse> listDevices(
      $grpc.ServiceCall call, $0.ListDevicesRequest request);

  $async.Future<$0.DeviceResponse> updateDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateDeviceRequest> $request) async {
    return updateDevice($call, await $request);
  }

  $async.Future<$0.DeviceResponse> updateDevice(
      $grpc.ServiceCall call, $0.UpdateDeviceRequest request);

  $async.Future<$1.Empty> deleteDevice_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteDeviceRequest> $request) async {
    return deleteDevice($call, await $request);
  }

  $async.Future<$1.Empty> deleteDevice(
      $grpc.ServiceCall call, $0.DeleteDeviceRequest request);
}
