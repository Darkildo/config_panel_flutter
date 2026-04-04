// This is a generated file - do not edit.
//
// Generated from device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use createDeviceRequestDescriptor instead')
const CreateDeviceRequest$json = {
  '1': 'CreateDeviceRequest',
  '2': [
    {'1': 'hostname', '3': 1, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'ip', '3': 2, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    {'1': 'is_active', '3': 4, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `CreateDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createDeviceRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVEZXZpY2VSZXF1ZXN0EhoKCGhvc3RuYW1lGAEgASgJUghob3N0bmFtZRIOCgJpcB'
    'gCIAEoCVICaXASGgoIbG9jYXRpb24YAyABKAlSCGxvY2F0aW9uEhsKCWlzX2FjdGl2ZRgEIAEo'
    'CFIIaXNBY3RpdmU=');

@$core.Deprecated('Use listDevicesRequestDescriptor instead')
const ListDevicesRequest$json = {
  '1': 'ListDevicesRequest',
  '2': [
    {
      '1': 'is_active',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isActive',
      '17': true
    },
    {'1': 'hostname_search', '3': 2, '4': 1, '5': 9, '10': 'hostnameSearch'},
  ],
  '8': [
    {'1': '_is_active'},
  ],
};

/// Descriptor for `ListDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0RGV2aWNlc1JlcXVlc3QSIAoJaXNfYWN0aXZlGAEgASgISABSCGlzQWN0aXZliAEBEi'
    'cKD2hvc3RuYW1lX3NlYXJjaBgCIAEoCVIOaG9zdG5hbWVTZWFyY2hCDAoKX2lzX2FjdGl2ZQ==');

@$core.Deprecated('Use deviceResponseDescriptor instead')
const DeviceResponse$json = {
  '1': 'DeviceResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'ip', '3': 3, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
    {'1': 'is_active', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `DeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceResponseDescriptor = $convert.base64Decode(
    'Cg5EZXZpY2VSZXNwb25zZRIOCgJpZBgBIAEoA1ICaWQSGgoIaG9zdG5hbWUYAiABKAlSCGhvc3'
    'RuYW1lEg4KAmlwGAMgASgJUgJpcBIaCghsb2NhdGlvbhgEIAEoCVIIbG9jYXRpb24SGwoJaXNf'
    'YWN0aXZlGAUgASgIUghpc0FjdGl2ZRI5CgpjcmVhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = {
  '1': 'ListDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.controlpanel.v1.DeviceResponse',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEjkKB2RldmljZXMYASADKAsyHy5jb250cm9scGFuZWwudj'
    'EuRGV2aWNlUmVzcG9uc2VSB2RldmljZXM=');
