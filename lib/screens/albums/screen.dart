import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/core/sync_bloc/sync_bloc_error_listener.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/albums_repository.dart';
import 'package:test_project/screens/album/screen.dart';
import 'package:test_project/screens/albums/bloc/albums_bloc.dart';
import 'package:test_project/screens/albums/widgets/albums_list.dart';

class AlbumsVM extends DisposableVM {
  late final AlbumsSyncBloc albumsSyncBloc;

  AlbumsVM(String userId) {
    albumsSyncBloc = AlbumsSyncBloc(albumsRepository: AlbumsRepositoryImpl());

    albumsSyncBloc.add(AlbumsFetchEvent(userId: userId));

    add(() => albumsSyncBloc.close());
  }

  BuiltList<AlbumPreviewDto> get albums {
    assert(
        albumsSyncBloc.state.data != null, 'no data in albumsPreviewSyncBloc');
    return albumsSyncBloc.state.data!;
  }

  bool get albumsSyncing =>
      albumsSyncBloc.state.syncing || !albumsSyncBloc.state.hadSync;
}

class AlbumsScreen extends StatefulWidget {
  final User user;

  const AlbumsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlbumsScreenState();
}

class AlbumsScreenState extends State<AlbumsScreen> {
  late final AlbumsVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = AlbumsVM(widget.user.id.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.username}\'s Albums'),
      ),
      body: SyncBlocErrorsListener(
        bloc: _vm.albumsSyncBloc,
        child: BlocBuilder(
            bloc: _vm.albumsSyncBloc,
            builder: (context, _) {
              if (_vm.albumsSyncing) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (_vm.albumsSyncBloc.state.hasOnlyError) {
                return Center(
                  child: Text(
                    'Ошибка синхронизации.\n${_vm.albumsSyncBloc.state.lastSyncError}',
                  ),
                );
              }

              return Albums(
                albums: _vm.albums,
                onAlbumTap: (album) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AlbumScreen(
                      album: album,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
