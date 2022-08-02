import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/state.dart';

abstract class BaseSyncBloc<TData, TFetchEvent extends SyncBlocFetchData>
    extends Bloc<SyncBlocEvent, SyncBlocState<TData>> {
  BaseSyncBloc(TData? initialData)
      : super(SyncBlocState.initial(data: initialData)) {
    on<TFetchEvent>((event, emit) => _onFetchData(event, emit));
  }

  Future<void> _onFetchData(
    TFetchEvent event,
    Emitter<SyncBlocState<TData>> emit,
  ) async {
    try {
      emit(state.withSyncing(clearData: event.clearData));
      final data = await fetch(event);
      emit(state.withData(data));
    } catch (e) {
      emit(state.withError(e.toString()));
    }
  }

  Future<TData> fetch(TFetchEvent fetchDataEvent);
}
