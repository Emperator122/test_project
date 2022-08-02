import 'package:test_project/network/models/album.dart';
import 'package:test_project/network/models/photo.dart';

class AlbumPreviewDto {
  final int albumId;
  final String title;
  final String? thumbnailUrl;

  AlbumPreviewDto({
    required this.albumId,
    required this.title,
    this.thumbnailUrl,
  });

  AlbumPreviewDto.fromApiData(Album album, Photo? photo)
      : assert(
          album.id == (photo?.albumId ?? album.id),
          'wrong photo or album',
        ),
        albumId = album.id,
        title = album.title,
        thumbnailUrl = photo?.thumbnailUrl;
}
