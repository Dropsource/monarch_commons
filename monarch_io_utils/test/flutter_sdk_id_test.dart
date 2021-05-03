import 'package:test/test.dart';
import 'package:monarch_io_utils/src/flutter_sdk_id.dart';

void main() {
  group('FlutterSdkId', () {
    test('parseFlutterVersionOutput', () {
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
Flutter 2.0.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 1d9032c7e1 (4 days ago) • 2021-04-29 17:37:58 -0700
Engine • revision 05e680e202
Tools • Dart 2.12.3''');
        expect(id.version, '2.0.6');
        expect(id.channel, 'stable');
      }
      {
        var id = FlutterSdkId.parseFlutterVersionOutput('''
Flutter 2.2.0-10.2.pre • channel beta • https://github.com/flutter/flutter.git
Framework • revision b5017bf8de (5 days ago) • 2021-04-28 17:09:53 -0700
Engine • revision 91ed51e05c
Tools • Dart 2.13.0 (build 2.13.0-211.13.beta)''');
        expect(id.version, '2.2.0-10.2.pre');
        expect(id.channel, 'beta');
      }
    });

    test('parseFlutterVersionOutput throws', () {
      expect(() => FlutterSdkId.parseFlutterVersionOutput('''
Unexpected flutter version output
'''), throwsArgumentError);
    });
  });
}