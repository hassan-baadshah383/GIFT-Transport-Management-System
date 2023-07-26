class HttpExceptions implements Exception {
  String message;

  HttpExceptions(this.message);

  @override
  String toString() {
    return message.toString();
  }
}
