abstract class DisposableVM {
  final List<Function> _disposers;

  DisposableVM() : _disposers = [];

  void add(Function onDispose) => _disposers.add(onDispose);

  void dispose() {
    for(final dispose in _disposers) {
      dispose();
    }
  }
}
