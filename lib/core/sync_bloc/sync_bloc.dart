import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/state.dart';

abstract class BaseSyncBloc<TData>
    extends Bloc<SyncBlocEvent, SyncBlocState<TData>> {

  BaseSyncBloc(TData? initialData)
      : super(SyncBlocState.initial(data: initialData)) {
    on<SyncBlocFetchData>((event, emit) => _onFetchData(event, emit));
  }

  Future<void> _onFetchData(
    SyncBlocFetchData event,
    Emitter<SyncBlocState<TData>> emit,
  ) async {
    try {
      emit(state.withSyncing(clearData: event.clearData));
      final data = await fetch();
      emit(state.withData(data));
    }
    catch (e){
      emit(state.withError(e.toString()));
    }
  }

  Future<TData> fetch();
}
