abstract class SyncBlocEvent {}

abstract class SyncBlocFetchData extends SyncBlocEvent {
  final bool clearData;

  SyncBlocFetchData({
    this.clearData = false,
  });
}

class SyncBlocClearData extends SyncBlocEvent {}
