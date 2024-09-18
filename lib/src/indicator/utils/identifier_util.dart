class IdentifierUtil {
  static String getUniqueIdentifier() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
