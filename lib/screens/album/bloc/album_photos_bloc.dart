import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/photo.dart';
import 'package:test_project/repositories/albums_repository.dart';

class AlbumPhotosSyncBloc
    extends BaseSyncBloc<BuiltList<Photo>, AlbumPhotosFetchEvent> {
  final AlbumsRepository albumsRepository;

  AlbumPhotosSyncBloc({required this.albumsRepository}) : super(null);

  @override
  Future<BuiltList<Photo>> fetch(AlbumPhotosFetchEvent fetchDataEvent) async {
    return albumsRepository.getAlbumPhotos(fetchDataEvent.albumId);
  }
}

class AlbumPhotosFetchEvent extends SyncBlocFetchData {
  final String albumId;

  AlbumPhotosFetchEvent({
    required this.albumId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
