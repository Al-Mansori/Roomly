class ServerException implements Exception {}

class CacheException implements Exception {}


class NoDataException implements Exception {
  final String message;

  const NoDataException({this.message = 'No data found'});

  @override
  String toString() => 'NoDataException: $message';
}

