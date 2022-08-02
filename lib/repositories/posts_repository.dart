import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/api/comments.dart';
import 'package:test_project/network/api/posts.dart';
import 'package:test_project/network/models/comment.dart';
import 'package:test_project/network/models/post.dart';

abstract class PostsRepository {
  Future<BuiltList<Post>> getUserPosts(String userId);
  Future<BuiltList<Post>> getUserPostsPreview(String userId);
  Future<BuiltList<Comment>> getPostComments(String postId);
  Future<Comment> sendPostComments({
    required String postId,
    required String name,
    required String email,
    required String comment,
  });
}

class PostsRepositoryImpl extends PostsRepository {
  final PostsApi postsApi;
  final CommentsApi commentsApi;

  PostsRepositoryImpl()
      : postsApi = PostsApiImpl(),
        commentsApi = CommentsApiImpl();

  @override
  Future<BuiltList<Post>> getUserPosts(String userId) {
    return postsApi.getUserPosts(userId);
  }

  @override
  Future<BuiltList<Post>> getUserPostsPreview(String userId) async {
    final allPosts = await postsApi.getUserPosts(userId);
    if (allPosts.isEmpty) {
      return BuiltList();
    }
    return allPosts
        .getRange(0, allPosts.length >= 3 ? 3 : allPosts.length)
        .toBuiltList();
  }

  @override
  Future<BuiltList<Comment>> getPostComments(String postId) {
    return commentsApi.getPostComments(postId);
  }

  @override
  Future<Comment> sendPostComments({
    required String postId,
    required String name,
    required String email,
    required String comment,
  }) {
    return commentsApi.sendPostComments(
      postId: postId,
      name: name,
      email: email,
      comment: comment,
    );
  }
}
