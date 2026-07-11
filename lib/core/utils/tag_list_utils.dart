/// Shared helpers for tag/skill list editors.
abstract final class TagListUtils {
  static List<String> addUnique(List<String> items, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || items.contains(trimmed)) {
      return items;
    }
    return [...items, trimmed];
  }

  static List<String> remove(List<String> items, String value) {
    return items.where((item) => item != value).toList();
  }
}
