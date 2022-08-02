import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';

class SyncBlocErrorsListener extends StatelessWidget {
  final BaseSyncBloc bloc;
  final Widget child;

  const SyncBlocErrorsListener({
    Key? key,
    required this.bloc,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, _) {
        final state = bloc.state;
        if (state.hasLastSyncError) {
          ScaffoldMessenger.of(context).showSnackBar(
            _getErrorSnackBar(state.lastSyncError),
          );
        }
      },
      child: child,
    );
  }
}

class MultiSyncBlocErrorsListener extends StatelessWidget {
  final List<BaseSyncBloc> blocs;
  final Widget child;

  const MultiSyncBlocErrorsListener({
    Key? key,
    required this.blocs,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: blocs
          .map(
            (bloc) => BlocListener(
              bloc: bloc,
              listener: (context, _) {
                final state = bloc.state;
                if (state.hasLastSyncError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    _getErrorSnackBar(state.lastSyncError),
                  );
                }
              },
            ),
          )
          .toList(),
      child: child,
    );
  }
}

_getErrorSnackBar(String? error) => SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      content: RichText(
        text: TextSpan(
          text: 'Ошибка синхронизации\r\n',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: error ?? '',
              style: const TextStyle(fontWeight: FontWeight.normal),
            )
          ]
        ),
      ),
    );
