abstract class SyncBlocEvent {}

class SyncBlocFetchData extends SyncBlocEvent {
  final bool clearData;

  SyncBlocFetchData({this.clearData = false});
}

class SyncBlocClearData extends SyncBlocEvent {}
