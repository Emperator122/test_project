import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/api/posts.dart';
import 'package:test_project/network/models/post.dart';

abstract class PostsRepository {
  Future<BuiltList<Post>> getUserPosts(String userId);
  Future<BuiltList<Post>> getUserPostsPreview(String userId);
}

class PostsRepositoryImpl extends PostsRepository {
  final PostsApi postsApi;

  PostsRepositoryImpl() : postsApi = PostsApiImpl();

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
}
