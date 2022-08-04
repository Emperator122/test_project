import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:test_project/dto/album_preview_dto.dart';

class AlbumsPreview extends StatelessWidget {
  final BuiltList<AlbumPreviewDto> albums;
  final Function() onWatchAll;
  final Function(AlbumPreviewDto previewDto) onAlbumTap;

  const AlbumsPreview({
    super.key,
    required this.albums,
    required this.onWatchAll,
    required this.onAlbumTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User\'s Albums',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            GridView.count(
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2 - 10) / 215,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              children: albums
                  .map(
                    (album) => InkResponse(
                      onTap: () => onAlbumTap(album),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(album.thumbnailUrl ??
                              'https://via.placeholder.com/150x150'), // for test project it's ok
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Text(
                              album.title,
                              textAlign: TextAlign.justify,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            Center(
              child: ElevatedButton(
                onPressed: onWatchAll,
                child: const Text('Watch all'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
