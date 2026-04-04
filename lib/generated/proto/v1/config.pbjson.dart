// This is a generated file - do not edit.
//
// Generated from config.proto.

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

@$core.Deprecated('Use createConfigRequestDescriptor instead')
const CreateConfigRequest$json = {
  '1': 'CreateConfigRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 3, '10': 'deviceId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `CreateConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConfigRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVDb25maWdSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoA1IIZGV2aWNlSWQSGAoHdm'
    'Vyc2lvbhgCIAEoCVIHdmVyc2lvbhIYCgdjb250ZW50GAMgASgJUgdjb250ZW50');

@$core.Deprecated('Use listConfigsRequestDescriptor instead')
const ListConfigsRequest$json = {
  '1': 'ListConfigsRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 3, '10': 'deviceId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListConfigsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0Q29uZmlnc1JlcXVlc3QSGwoJZGV2aWNlX2lkGAEgASgDUghkZXZpY2VJZBISCgRwYW'
    'dlGAIgASgFUgRwYWdlEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use configResponseDescriptor instead')
const ConfigResponse$json = {
  '1': 'ConfigResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'device_id', '3': 2, '4': 1, '5': 3, '10': 'deviceId'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'applied_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'appliedAt',
      '17': true
    },
  ],
  '8': [
    {'1': '_applied_at'},
  ],
};

/// Descriptor for `ConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configResponseDescriptor = $convert.base64Decode(
    'Cg5Db25maWdSZXNwb25zZRIOCgJpZBgBIAEoA1ICaWQSGwoJZGV2aWNlX2lkGAIgASgDUghkZX'
    'ZpY2VJZBIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9uEhgKB2NvbnRlbnQYBCABKAlSB2NvbnRl'
    'bnQSOQoKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZW'
    'F0ZWRBdBI+CgphcHBsaWVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgA'
    'UglhcHBsaWVkQXSIAQFCDQoLX2FwcGxpZWRfYXQ=');

@$core.Deprecated('Use listConfigsResponseDescriptor instead')
const ListConfigsResponse$json = {
  '1': 'ListConfigsResponse',
  '2': [
    {
      '1': 'configs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.controlpanel.v1.ConfigResponse',
      '10': 'configs'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListConfigsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Q29uZmlnc1Jlc3BvbnNlEjkKB2NvbmZpZ3MYASADKAsyHy5jb250cm9scGFuZWwudj'
    'EuQ29uZmlnUmVzcG9uc2VSB2NvbmZpZ3MSFAoFdG90YWwYAiABKAVSBXRvdGFsEhIKBHBhZ2UY'
    'AyABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use applyConfigRequestDescriptor instead')
const ApplyConfigRequest$json = {
  '1': 'ApplyConfigRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `ApplyConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyConfigRequestDescriptor =
    $convert.base64Decode('ChJBcHBseUNvbmZpZ1JlcXVlc3QSDgoCaWQYASABKANSAmlk');

@$core.Deprecated('Use applyConfigResponseDescriptor instead')
const ApplyConfigResponse$json = {
  '1': 'ApplyConfigResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'applied_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'appliedAt'
    },
  ],
};

/// Descriptor for `ApplyConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyConfigResponseDescriptor = $convert.base64Decode(
    'ChNBcHBseUNvbmZpZ1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSOQoKYXBwbG'
    'llZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWFwcGxpZWRBdA==');
