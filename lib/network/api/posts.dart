import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/http_service/http_service.dart';
import 'package:test_project/network/models/post.dart';

abstract class PostsApi {
  Future<BuiltList<Post>> getUserPosts(String userId);
}

class PostsApiImpl extends PostsApi {
  @override
  Future<BuiltList<Post>> getUserPosts(String userId) async {
    final httpService = HttpService();

    final response = await httpService.makeRequest(uri: 'posts?userId=$userId');

    final decodedJson = response as List<dynamic>?;
    final posts = decodedJson?.map((user) => Post.fromJson(user)).toBuiltList();
    return posts ?? BuiltList();
  }
}
