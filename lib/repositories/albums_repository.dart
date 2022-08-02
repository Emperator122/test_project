import 'package:built_collection/built_collection.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/network/api/albums.dart';
import 'package:test_project/network/models/album.dart';
import 'package:test_project/network/models/photo.dart';

abstract class AlbumsRepository {
  Future<BuiltList<Album>> getUserAlbums(String userId);
  Future<BuiltList<Photo>> getAlbumPhotos(String albumId);
  Future<BuiltList<AlbumPreviewDto>> getUserAlbumsPreview(String userId, {int? count});
  Future<BuiltList<Photo>> getAlbumPhotosPreview(String albumId, int count);
}

class AlbumsRepositoryImpl extends AlbumsRepository {
  final AlbumsApi albumsApi;

  AlbumsRepositoryImpl() : albumsApi = AlbumsApiImpl();

  @override
  Future<BuiltList<Photo>> getAlbumPhotos(String albumId) {
    return albumsApi.getAlbumPhotos(albumId);
  }

  @override
  Future<BuiltList<Photo>> getAlbumPhotosPreview(
      String albumId, int count) async {
    final allPhotos = await albumsApi.getAlbumPhotos(albumId);
    if (allPhotos.isEmpty) {
      return BuiltList();
    }
    return allPhotos
        .getRange(0, allPhotos.length >= count ? count : allPhotos.length)
        .toBuiltList();
  }

  @override
  Future<BuiltList<Album>> getUserAlbums(String userId) {
    return albumsApi.getUserAlbums(userId);
  }

  @override
  Future<BuiltList<AlbumPreviewDto>> getUserAlbumsPreview(String userId, {int? count}) async {
    final allAlbums = await albumsApi.getUserAlbums(userId);
    if (allAlbums.isEmpty) {
      return BuiltList();
    }

    final sliceSize = count ?? allAlbums.length;

    final albumsSlice = allAlbums
        .getRange(0, allAlbums.length >= sliceSize ? sliceSize : allAlbums.length)
        .toBuiltList();

    final result = <AlbumPreviewDto>[];
    for (final album in albumsSlice) {
      final previews = await getAlbumPhotosPreview(album.id.toString(), 1);
      result.add(AlbumPreviewDto.fromApiData(
          album, previews.isNotEmpty ? previews.first : null));
    }
    return result.build();
  }
}
