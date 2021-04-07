import 'dart:io';

T valueForPlatform<T>({required T macos, required T windows}) {
  if (Platform.isMacOS) {
    return macos;
  } else if (Platform.isWindows) {
    return windows;
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}

T functionForPlatform<T>(
    {required T Function() macos, required T Function() windows}) {
  if (Platform.isMacOS) {
    return macos();
  } else if (Platform.isWindows) {
    return windows();
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}

Future futureForPlatform(
    {required Future Function() macos, required Future Function() windows}) {
  if (Platform.isMacOS) {
    return macos();
  } else if (Platform.isWindows) {
    return windows();
  } else {
    throw UnsupportedError(
        'The ${Platform.operatingSystem} platform is not supported');
  }
}
