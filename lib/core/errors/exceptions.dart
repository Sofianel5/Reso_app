class ServerException implements Exception {} // Error 500
class CacheException implements Exception {} // No local data
class ConnectionException implements Exception {} // No internet
class AuthenticationException extends ServerException {} // Error 403
class SignUpException extends AuthenticationException{
  String message;
  SignUpException({
    this.message
  }); // User submits bad data 
}