// This is a generated file - do not edit.
//
// Generated from config.proto.

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

import 'config.pb.dart' as $0;

export 'config.pb.dart';

@$pb.GrpcServiceName('controlpanel.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConfigServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ConfigResponse> createConfig(
    $0.CreateConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConfigResponse> getConfig(
    $0.GetConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListConfigsResponse> listConfigs(
    $0.ListConfigsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listConfigs, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConfigResponse> updateConfig(
    $0.UpdateConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateConfig, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteConfig(
    $0.DeleteConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.ApplyConfigResponse> applyConfig(
    $0.ApplyConfigRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyConfig, request, options: options);
  }

  // method descriptors

  static final _$createConfig =
      $grpc.ClientMethod<$0.CreateConfigRequest, $0.ConfigResponse>(
          '/controlpanel.v1.ConfigService/CreateConfig',
          ($0.CreateConfigRequest value) => value.writeToBuffer(),
          $0.ConfigResponse.fromBuffer);
  static final _$getConfig =
      $grpc.ClientMethod<$0.GetConfigRequest, $0.ConfigResponse>(
          '/controlpanel.v1.ConfigService/GetConfig',
          ($0.GetConfigRequest value) => value.writeToBuffer(),
          $0.ConfigResponse.fromBuffer);
  static final _$listConfigs =
      $grpc.ClientMethod<$0.ListConfigsRequest, $0.ListConfigsResponse>(
          '/controlpanel.v1.ConfigService/ListConfigs',
          ($0.ListConfigsRequest value) => value.writeToBuffer(),
          $0.ListConfigsResponse.fromBuffer);
  static final _$updateConfig =
      $grpc.ClientMethod<$0.UpdateConfigRequest, $0.ConfigResponse>(
          '/controlpanel.v1.ConfigService/UpdateConfig',
          ($0.UpdateConfigRequest value) => value.writeToBuffer(),
          $0.ConfigResponse.fromBuffer);
  static final _$deleteConfig =
      $grpc.ClientMethod<$0.DeleteConfigRequest, $1.Empty>(
          '/controlpanel.v1.ConfigService/DeleteConfig',
          ($0.DeleteConfigRequest value) => value.writeToBuffer(),
          $1.Empty.fromBuffer);
  static final _$applyConfig =
      $grpc.ClientMethod<$0.ApplyConfigRequest, $0.ApplyConfigResponse>(
          '/controlpanel.v1.ConfigService/ApplyConfig',
          ($0.ApplyConfigRequest value) => value.writeToBuffer(),
          $0.ApplyConfigResponse.fromBuffer);
}

@$pb.GrpcServiceName('controlpanel.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'controlpanel.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateConfigRequest, $0.ConfigResponse>(
        'CreateConfig',
        createConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateConfigRequest.fromBuffer(value),
        ($0.ConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetConfigRequest, $0.ConfigResponse>(
        'GetConfig',
        getConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetConfigRequest.fromBuffer(value),
        ($0.ConfigResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListConfigsRequest, $0.ListConfigsResponse>(
            'ListConfigs',
            listConfigs_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListConfigsRequest.fromBuffer(value),
            ($0.ListConfigsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateConfigRequest, $0.ConfigResponse>(
        'UpdateConfig',
        updateConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateConfigRequest.fromBuffer(value),
        ($0.ConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteConfigRequest, $1.Empty>(
        'DeleteConfig',
        deleteConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteConfigRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ApplyConfigRequest, $0.ApplyConfigResponse>(
            'ApplyConfig',
            applyConfig_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ApplyConfigRequest.fromBuffer(value),
            ($0.ApplyConfigResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ConfigResponse> createConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateConfigRequest> $request) async {
    return createConfig($call, await $request);
  }

  $async.Future<$0.ConfigResponse> createConfig(
      $grpc.ServiceCall call, $0.CreateConfigRequest request);

  $async.Future<$0.ConfigResponse> getConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetConfigRequest> $request) async {
    return getConfig($call, await $request);
  }

  $async.Future<$0.ConfigResponse> getConfig(
      $grpc.ServiceCall call, $0.GetConfigRequest request);

  $async.Future<$0.ListConfigsResponse> listConfigs_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListConfigsRequest> $request) async {
    return listConfigs($call, await $request);
  }

  $async.Future<$0.ListConfigsResponse> listConfigs(
      $grpc.ServiceCall call, $0.ListConfigsRequest request);

  $async.Future<$0.ConfigResponse> updateConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateConfigRequest> $request) async {
    return updateConfig($call, await $request);
  }

  $async.Future<$0.ConfigResponse> updateConfig(
      $grpc.ServiceCall call, $0.UpdateConfigRequest request);

  $async.Future<$1.Empty> deleteConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteConfigRequest> $request) async {
    return deleteConfig($call, await $request);
  }

  $async.Future<$1.Empty> deleteConfig(
      $grpc.ServiceCall call, $0.DeleteConfigRequest request);

  $async.Future<$0.ApplyConfigResponse> applyConfig_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApplyConfigRequest> $request) async {
    return applyConfig($call, await $request);
  }

  $async.Future<$0.ApplyConfigResponse> applyConfig(
      $grpc.ServiceCall call, $0.ApplyConfigRequest request);
}
