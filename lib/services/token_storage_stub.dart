void webStorageWrite(String key, String value) {
  throw UnsupportedError('webStorageWrite is only supported on web');
}

String? webStorageRead(String key) {
  throw UnsupportedError('webStorageRead is only supported on web');
}

void webStorageDelete(String key) {
  throw UnsupportedError('webStorageDelete is only supported on web');
}
