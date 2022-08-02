import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/comment.dart';
import 'package:test_project/repositories/posts_repository.dart';

class SendCommentSyncBloc
    extends BaseSyncBloc<Comment, SendCommentFetchEvent> {
  final PostsRepository postsRepository;

  SendCommentSyncBloc({required this.postsRepository}) : super(null);

  @override
  Future<Comment> fetch(SendCommentFetchEvent fetchDataEvent) async {
    return postsRepository.sendPostComments(
      postId: fetchDataEvent.postId,
      name: fetchDataEvent.name,
      email: fetchDataEvent.email,
      comment: fetchDataEvent.comment,
    );
  }
}

class SendCommentFetchEvent extends SyncBlocFetchData {
  final String postId;
  final String name;
  final String email;
  final String comment;

  SendCommentFetchEvent({
    required this.postId,
    required this.name,
    required this.email,
    required this.comment,
    bool clearData = false,
  }) : super(clearData: clearData);
}
