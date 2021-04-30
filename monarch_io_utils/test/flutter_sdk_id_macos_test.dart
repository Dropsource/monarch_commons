@TestOn('mac-os')

import 'package:test/test.dart';
import 'package:monarch_io_utils/src/flutter_sdk_id.dart';

void main() {
  group('FlutterSdkId', () {
    test('toString', () {
      expect(FlutterSdkId(channel: 'stable', version: '2.0.5').toString(), 'flutter_macos_2.0.5-stable');
      expect(FlutterSdkId(channel: 'dev', version: '2.2.0-10.1.pre').toString(), 'flutter_macos_2.2.0-10.1.pre-dev');
    });

    test('parse', () {
      {
        var id = FlutterSdkId.parse('flutter_macos_2.0.5-stable');
        expect(id.version, '2.0.5');
        expect(id.channel, 'stable');
      }
      {
        var id = FlutterSdkId.parse('flutter_macos_2.2.0-10.1.pre-dev');
        expect(id.version, '2.2.0-10.1.pre');
        expect(id.channel, 'dev');
      }
      {
        var id = FlutterSdkId.parse('flutter_macos_2.2.333-a+b.pre-beta');
        expect(id.version, '2.2.333-a+b.pre');
        expect(id.channel, 'beta');
      }
    });

    test('parse throws', () {
      expect(() => FlutterSdkId.parse('flutter_macos_'), throwsArgumentError);
    });
  });
}