class SyncBlocState<TData> {
  late final TData? data;

  late final bool syncing;

  late final String? lastSyncError;

  bool get hadSync => hasData || hasLastSyncError;

  bool get hasData => data != null;

  bool get hasLastSyncError => (lastSyncError != null);

  bool get hasOnlyError => hasLastSyncError && !hasData;

  SyncBlocState._(this.data, this.syncing, this.lastSyncError);

  SyncBlocState.initial({this.data})
      : syncing = false,
        lastSyncError = null;

  SyncBlocState<TData> withSyncing({bool clearData = false}) {
    assert(!syncing);
    final newData = clearData ? null : data;
    return SyncBlocState._(newData, true, null);
  }

  SyncBlocState<TData> withData(TData newData) {
    return SyncBlocState._(newData, false, null);
  }

  SyncBlocState<TData> withError(
    String syncError, {
    bool clearData = false,
  }) {
    final newData = clearData ? null : data;
    return SyncBlocState._(newData, false, syncError);
  }
}
