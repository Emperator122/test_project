import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/http_service/http_service.dart';
import 'package:test_project/network/models/album.dart';
import 'package:test_project/network/models/photo.dart';

abstract class AlbumsApi {
  Future<BuiltList<Album>> getUserAlbums(String userId);
  Future<BuiltList<Photo>> getAlbumPhotos(String albumId);
}

class AlbumsApiImpl extends AlbumsApi {

  @override
  Future<BuiltList<Photo>> getAlbumPhotos(String albumId) async {
    final httpService = HttpService();

    final response = await httpService.makeRequest(uri: 'photos?albumId=$albumId');

    final decodedJson = response as List<dynamic>?;
    final posts = decodedJson?.map((user) => Photo.fromJson(user)).toBuiltList();
    return posts ?? BuiltList();
  }

  @override
  Future<BuiltList<Album>> getUserAlbums(String userId) async {
    final httpService = HttpService();

    final response = await httpService.makeRequest(uri: 'albums?userId=$userId');

    final decodedJson = response as List<dynamic>?;
    final posts = decodedJson?.map((user) => Album.fromJson(user)).toBuiltList();
    return posts ?? BuiltList();
  }
}
