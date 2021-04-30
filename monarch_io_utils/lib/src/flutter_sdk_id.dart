
import 'dart:io';

class FlutterSdkId {
  final String channel;
  final String version;
  FlutterSdkId({required this.channel, required this.version});

  static String get operatingSystem => Platform.operatingSystem;

  @override
  String toString() {
    return 'flutter_${operatingSystem}_$version-$channel';
  }

  static FlutterSdkId parse(String stringId) {
    // var pattern = RegExp(r'^flutter_(macos|windows|linux)_(.+)-(stable|beta|dev|master)$');
    var pattern = RegExp('^flutter_${operatingSystem}_(.+)-(stable|beta|dev|master)\$');
    if (pattern.hasMatch(stringId)) {
      var match = pattern.firstMatch(stringId)!;
      if (match.groupCount == 2) {
        var _version = match.group(1)!;
        var _channel = match.group(2)!;
        return FlutterSdkId(channel: _channel, version: _version);
      }
    }
    throw ArgumentError('Could not parse version and channel from "$stringId"');
  }
}
