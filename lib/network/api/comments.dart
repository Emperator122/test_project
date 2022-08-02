import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/http_service/http_service.dart';
import 'package:test_project/network/models/comment.dart';

abstract class CommentsApi {
  Future<BuiltList<Comment>> getPostComments(String postId);
  Future<Comment> sendPostComments({
    required String postId,
    required String name,
    required String email,
    required String comment,
  });
}

class CommentsApiImpl extends CommentsApi {
  @override
  Future<BuiltList<Comment>> getPostComments(String postId) async {
    final httpService = HttpService();

    final response =
        await httpService.makeRequest(uri: 'posts/$postId/comments');

    final decodedJson = response as List<dynamic>?;
    final posts =
        decodedJson?.map((user) => Comment.fromJson(user)).toBuiltList();
    return posts ?? BuiltList();
  }

  @override
  Future<Comment> sendPostComments({
    required String postId,
    required String name,
    required String email,
    required String comment,
  }) async {
    final httpService = HttpService();

    final response = await httpService.makeRequest(
      uri: 'comments',
      httpMethod: HttpMethod.post,
      body: {
        'postId': int.parse(postId),
        'name': name,
        'email': email,
        'body': comment,
      },
    );

    final createdComment = Comment.fromJson(response);
    return createdComment;
  }
}
