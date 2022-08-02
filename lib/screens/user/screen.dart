import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/core/sync_bloc/sync_bloc_error_listener.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/albums_repository.dart';
import 'package:test_project/repositories/posts_repository.dart';
import 'package:test_project/screens/album/screen.dart';
import 'package:test_project/screens/albums/screen.dart';
import 'package:test_project/screens/post/screen.dart';
import 'package:test_project/screens/posts/screen.dart';
import 'package:test_project/screens/user/bloc/albums_preview_bloc.dart';
import 'package:test_project/screens/user/bloc/posts_preview_bloc.dart';
import 'package:test_project/screens/user/widgets/address_info.dart';
import 'package:test_project/screens/user/widgets/albums_list.dart';
import 'package:test_project/screens/user/widgets/company_info.dart';
import 'package:test_project/screens/user/widgets/posts_list.dart';
import 'package:test_project/screens/user/widgets/primary_info.dart';

class UserVM extends DisposableVM {
  late final PostsPreviewSyncBloc postsPreviewSyncBloc;
  late final AlbumsPreviewSyncBloc albumsPreviewSyncBloc;

  UserVM(String userId) {
    postsPreviewSyncBloc =
        PostsPreviewSyncBloc(postsRepository: PostsRepositoryImpl());
    albumsPreviewSyncBloc =
        AlbumsPreviewSyncBloc(albumsRepository: AlbumsRepositoryImpl());

    postsPreviewSyncBloc.add(PostsPreviewFetchEvent(userId: userId));

    albumsPreviewSyncBloc.add(AlbumsPreviewFetchEvent(userId: userId));

    add(() => postsPreviewSyncBloc.close());
    add(() => albumsPreviewSyncBloc.close());
  }

  BuiltList<Post> get posts {
    assert(postsPreviewSyncBloc.state.data != null, 'no data in usersSyncBloc');
    return postsPreviewSyncBloc.state.data!;
  }

  BuiltList<AlbumPreviewDto> get albums {
    assert(albumsPreviewSyncBloc.state.data != null,
        'no data in albumsPreviewSyncBloc');
    return albumsPreviewSyncBloc.state.data!;
  }

  bool get postsSyncing =>
      postsPreviewSyncBloc.state.syncing || !postsPreviewSyncBloc.state.hadSync;

  bool get albumsSyncing =>
      albumsPreviewSyncBloc.state.syncing ||
      !albumsPreviewSyncBloc.state.hadSync;
}

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  late final UserVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = UserVM(widget.user.id.toString());
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
        title: Text(widget.user.username),
      ),
      body: MultiSyncBlocErrorsListener(
        blocs: [
          _vm.albumsPreviewSyncBloc,
          _vm.postsPreviewSyncBloc,
        ],
        child: ListView(
          children: [
            PrimaryInfo(user: widget.user),
            CompanyInfo(company: widget.user.company),
            AddressInfo(address: widget.user.address),
            BlocBuilder(
              bloc: _vm.postsPreviewSyncBloc,
              builder: (context, _) {
                if (_vm.postsSyncing) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_vm.postsPreviewSyncBloc.state.hasOnlyError) {
                  return Center(
                    child: Text(
                      'Ошибка синхронизации.\n${_vm.postsPreviewSyncBloc.state.lastSyncError}',
                    ),
                  );
                }

                return PostsListPreview(
                  posts: _vm.posts,
                  onWatchAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostsScreen(user: widget.user),
                    ),
                  ),
                  onPostTap: (post) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostScreen(
                        user: widget.user,
                        post: post,
                      ),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder(
              bloc: _vm.albumsPreviewSyncBloc,
              builder: (context, _) {
                if (_vm.albumsSyncing) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_vm.albumsPreviewSyncBloc.state.hasOnlyError) {
                  return Center(
                    child: Text(
                      'Ошибка синхронизации.\n${_vm.albumsPreviewSyncBloc.state.lastSyncError}',
                    ),
                  );
                }

                return AlbumsPreview(
                  albums: _vm.albums,
                  onWatchAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AlbumsScreen(user: widget.user),
                    ),
                  ),
                  onAlbumTap: (album) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AlbumScreen(
                        album: album,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
