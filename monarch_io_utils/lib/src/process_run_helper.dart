import 'dart:io';
import 'process_utils.dart';

class ProcessRunHelper {
  final String executable;
  final List<String> arguments;
  final String? workingDirectory;

  ProcessRunHelper(this.executable, this.arguments,
      {this.workingDirectory, List<int>? successExitCodes}) {
    if (successExitCodes != null) {
      _successExitCodes = successExitCodes;
    }
  }

  late ProcessResult _result;
  ProcessResult get result => _result;

  List<int> _successExitCodes = [0];
  bool get isSuccess => _successExitCodes.contains(_result.exitCode);

  late String _stdout;
  String get stdout => _stdout;

  late String _stderr;
  String get stderr => _stderr;

  String get prettyCmd => getPrettyCommand(executable, arguments);

  void runSync() {
    _result = Process.runSync(executable, arguments,
        workingDirectory: workingDirectory, runInShell: Platform.isWindows);

    _stdout = _result.stdout;
    _stderr = _result.stderr;
  }

  String getOutputMessage() {
    return '''
command-output exit_code=${result.exitCode} success=$isSuccess command="$prettyCmd"
stdout:
$stdout

stderr:
$stderr''';
  }
}
