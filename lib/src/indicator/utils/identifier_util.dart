/// Class with util methods
class IdentifierUtil {
  static int _counter = 0;

  /// Method to get a unique identifier.
  static String getUniqueIdentifier() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_counter++}';
}
