import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/post.dart';
import 'package:test_project/repositories/posts_repository.dart';

class PostsPreviewSyncBloc
    extends BaseSyncBloc<BuiltList<Post>, PostsPreviewFetchEvent> {
  final PostsRepository postsRepository;

  PostsPreviewSyncBloc({required this.postsRepository}) : super(null);

  @override
  Future<BuiltList<Post>> fetch(PostsPreviewFetchEvent fetchDataEvent) async {
    return postsRepository.getUserPostsPreview(fetchDataEvent.userId);
  }
}

class PostsPreviewFetchEvent extends SyncBlocFetchData {
  final String userId;

  PostsPreviewFetchEvent({
    required this.userId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
