class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class FirebaseAuthExceptionWrapper implements Exception {
  final String message;
  FirebaseAuthExceptionWrapper(this.message);
}

// Domain/Data layers independent of Firebase/Dio exceptions
