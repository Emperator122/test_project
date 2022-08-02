import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/posts_repository.dart';
import 'package:test_project/screens/posts/bloc/posts_preview_bloc.dart';
import 'package:test_project/screens/posts/widgets/posts_list.dart';

class PostsVM extends DisposableVM {
  late final AllPostsPreviewSyncBloc allPostsPreviewSyncBloc;

  PostsVM(String userId) {
    allPostsPreviewSyncBloc =
        AllPostsPreviewSyncBloc(postsRepository: PostsRepositoryImpl());

    allPostsPreviewSyncBloc.add(AllPostsPreviewFetchEvent(userId: userId));

    add(() => allPostsPreviewSyncBloc.close());
  }

  BuiltList<Post> get posts {
    assert(allPostsPreviewSyncBloc.state.data != null, 'no data in usersSyncBloc');
    return allPostsPreviewSyncBloc.state.data!;
  }

  bool get postsSyncing =>
      allPostsPreviewSyncBloc.state.syncing || !allPostsPreviewSyncBloc.state.hadSync;
}

class PostsScreen extends StatefulWidget {
  final User user;

  const PostsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostsScreenState();
}

class PostsScreenState extends State<PostsScreen> {
  late final PostsVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = PostsVM(widget.user.id.toString());
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
        title: Text('${widget.user.username}\'s Posts'),
      ),
      body: ListView(
        children: [
          BlocBuilder(
            bloc: _vm.allPostsPreviewSyncBloc,
            builder: (context, _) {
              if (_vm.postsSyncing) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (_vm.allPostsPreviewSyncBloc.state.hasOnlyError) {
                return Center(
                  child: Text(
                    'Ошибка синхронизации.\n${_vm.allPostsPreviewSyncBloc.state.lastSyncError}',
                  ),
                );
              }

              return PostsList(
                posts: _vm.posts,
                onPostTap: (Post post) {  },
              );
            },
          ),
        ],
      ),
    );
  }
}
