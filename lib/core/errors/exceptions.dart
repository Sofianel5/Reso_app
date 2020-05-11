class ServerException implements Exception {} // Error 500
class CacheException implements Exception {} // No local data
class ConnectionException implements Exception {} // No internet
class AuthenticationException extends ServerException {} // Error 403