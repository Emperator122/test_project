import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/comment.dart';
import 'package:test_project/repositories/posts_repository.dart';

class CommentsSyncBloc
    extends BaseSyncBloc<BuiltList<Comment>, CommentFetchEvent> {
  final PostsRepository postsRepository;

  CommentsSyncBloc({required this.postsRepository}) : super(null);

  @override
  Future<BuiltList<Comment>> fetch(CommentFetchEvent fetchDataEvent) async {
    return postsRepository.getPostComments(fetchDataEvent.postId);
  }
}

class CommentFetchEvent extends SyncBlocFetchData {
  final String postId;

  CommentFetchEvent({
    required this.postId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
