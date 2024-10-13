abstract class SearchAlgorithm<T> {
  Future<T?> search(Future<void> Function(T) renderNode);
}
