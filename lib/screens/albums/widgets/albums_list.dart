import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_project/dto/album_preview_dto.dart';

class Albums extends StatelessWidget {
  final BuiltList<AlbumPreviewDto> albums;
  final Function(AlbumPreviewDto previewDto) onAlbumTap;

  const Albums({
    super.key,
    required this.albums,
    required this.onAlbumTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        childAspectRatio: 9 / 10,
        crossAxisCount: 2,
        children: albums
            .map(
              (album) => InkWell(
                onTap: () => onAlbumTap(album),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: CachedNetworkImageProvider(
                            album.thumbnailUrl ??
                                'https://via.placeholder.com/150x150',
                          ), // for test project it's ok
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Text(
                            album.title,
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
