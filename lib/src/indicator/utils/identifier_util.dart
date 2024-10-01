/// Class with util methods
class IdentifierUtil {
  /// Method to get a unique identifier.
  static String getUniqueIdentifier() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
