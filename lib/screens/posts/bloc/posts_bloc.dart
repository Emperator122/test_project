import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/repositories/posts_repository.dart';

class PostsSyncBloc
    extends BaseSyncBloc<BuiltList<Post>, PostsFetchEvent> {
  final PostsRepository postsRepository;

  PostsSyncBloc({required this.postsRepository}) : super(null);

  @override
  Future<BuiltList<Post>> fetch(PostsFetchEvent fetchDataEvent) async {
    return postsRepository.getUserPosts(fetchDataEvent.userId);
  }
}

class PostsFetchEvent extends SyncBlocFetchData {
  final String userId;

  PostsFetchEvent({
    required this.userId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
