import 'dart:async';
import 'package:pedantic/pedantic.dart';

import 'package:shelf/shelf.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:monarch_utils/log.dart';

final _logger = Logger('Middleware');

Middleware logResponseInfoAndCallHandler() => (Handler innerHandler) {
      return (Request request) async {
        final watch = Stopwatch()..start();
        final completer = Completer<Response>();

        unawaited(Chain.capture(() async {
          final res = await innerHandler(request);
          completer.complete(res);
        }, onError: (e, chain) {
          if (e is HijackException) throw e;
          _logger.severe('error-handling-request ${_formatRequest(request)}', e,
              chain.terse);
          completer.complete(Response.internalServerError());
        }));

        final response = await completer.future;
        watch.stop();

        _logger.info('response '
            'duration=${watch.duration.inMilliseconds}ms '
            'status_code=${response.statusCode} '
            '${_formatRequest(request)} ');

        return response;
      };
    };

Response? logRequestInfo(Request request) {
  _logger.info('request '
      '${_formatRequest(request)} ');
  return null;
}

String _formatRequest(Request request) {
  return 'method=${request.method} '
      'requested_uri=${_formatUri(request.requestedUri)}';
}

String _formatUri(Uri uri) {
  return '${uri.path}${_formatQuery(uri.query)}';
}

String _formatQuery(String query) {
  return query == '' ? '' : '?$query';
}
