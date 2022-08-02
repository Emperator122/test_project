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
  late final PostsSyncBloc postsSyncBloc;

  PostsVM(String userId) {
    postsSyncBloc =
        PostsSyncBloc(postsRepository: PostsRepositoryImpl());

    postsSyncBloc.add(PostsFetchEvent(userId: userId));

    add(() => postsSyncBloc.close());
  }

  BuiltList<Post> get posts {
    assert(postsSyncBloc.state.data != null, 'no data in usersSyncBloc');
    return postsSyncBloc.state.data!;
  }

  bool get postsSyncing =>
      postsSyncBloc.state.syncing || !postsSyncBloc.state.hadSync;
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
      body: BlocBuilder(
        bloc: _vm.postsSyncBloc,
        builder: (context, _) {
          if (_vm.postsSyncing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_vm.postsSyncBloc.state.hasOnlyError) {
            return Center(
              child: Text(
                'Ошибка синхронизации.\n${_vm.postsSyncBloc.state.lastSyncError}',
              ),
            );
          }

          return PostsList(
            posts: _vm.posts,
            onPostTap: (Post post) {  },
          );
        },
      ),
    );
  }
}
