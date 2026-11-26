const pageSize = 20;

List<T> pageOf<T>(List<T> items, int page) {
  if (page < 1) {
    return [];
  }
  return items.skip((page - 1) * pageSize).take(pageSize).toList();
}
