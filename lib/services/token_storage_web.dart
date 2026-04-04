import 'package:web/web.dart' as web;

void webStorageWrite(String key, String value) {
  web.window.localStorage.setItem(key, value);
}

String? webStorageRead(String key) {
  return web.window.localStorage.getItem(key);
}

void webStorageDelete(String key) {
  web.window.localStorage.removeItem(key);
}
