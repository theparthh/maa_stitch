/// Thrown when a file cannot be decoded. [message] is shown to the user.
class EmbroideryDecodeException implements Exception {
  const EmbroideryDecodeException(this.message);

  final String message;

  @override
  String toString() => message;
}
