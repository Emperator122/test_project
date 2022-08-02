import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/repositories/posts_repository.dart';

class AllPostsPreviewSyncBloc
    extends BaseSyncBloc<BuiltList<Post>, AllPostsPreviewFetchEvent> {
  final PostsRepository postsRepository;

  AllPostsPreviewSyncBloc({required this.postsRepository}) : super(null);

  @override
  Future<BuiltList<Post>> fetch(AllPostsPreviewFetchEvent fetchDataEvent) async {
    return postsRepository.getUserPosts(fetchDataEvent.userId);
  }
}

class AllPostsPreviewFetchEvent extends SyncBlocFetchData {
  final String userId;

  AllPostsPreviewFetchEvent({
    required this.userId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
