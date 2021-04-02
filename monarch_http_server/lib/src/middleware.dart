import 'package:monarch_utils/log.dart';
import 'package:shelf/shelf.dart';

final _logger = Logger('Middleware');

Middleware logResponseInfo() => (Handler innerHandler) {
      return (Request request) async {
        Response response;
        final watch = Stopwatch()..start();
        try {
          response = await innerHandler(request);
        } catch (e) {
          if (e is HijackException) rethrow;
          _logger.severe(
              'error handling request ${_formatRequest(request)} ');
          rethrow;
        }
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
