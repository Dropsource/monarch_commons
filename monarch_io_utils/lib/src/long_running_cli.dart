import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';

abstract class LongRunningCli<T> {
  late Completer<T> _exitCompleter;

  /// Returns a future that completes when the long-running
  /// work has exited.
  Future<T> get exit => _exitCompleter.future;
  bool get hasExited => _exitCompleter.isCompleted;

  T get userTerminatedExitCode;

  /// Runs the long running CLI task, command or process.
  void run() {
    _exitCompleter = Completer();
    _listenForUserQuit();
    didRun();
  }

  void _listenForUserQuit() {
    ProcessSignal.sigint.watch().listen((signal) async {
      if (signal == ProcessSignal.sigint) {
        await terminate(userTerminatedExitCode);
      }
    });
  }

  /// Implementations should start work.
  @protected 
  void didRun();

  /// Call this function when the user has requested termination.
  /// It will terminate any in-progress work and then `finish`.
  Future<void> terminate(T exitCode) async {
    await willTerminate();
    finish(exitCode);
  }

  /// Implementations should terminate any in-progress work.
  @protected 
  Future<void> willTerminate();

  /// Completes the exit future with the provided `exitCode`.
  void finish(T exitCode) {
    if (!hasExited) {
      _exitCompleter.complete(exitCode);
    }
  }

}

