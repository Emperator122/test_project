import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/repositories/albums_repository.dart';

class AlbumsPreviewSyncBloc
    extends BaseSyncBloc<BuiltList<AlbumPreviewDto>, AlbumsPreviewFetchEvent> {
  final AlbumsRepository albumsRepository;

  AlbumsPreviewSyncBloc({required this.albumsRepository}) : super(null);

  @override
  Future<BuiltList<AlbumPreviewDto>> fetch(AlbumsPreviewFetchEvent fetchDataEvent) async {
    return albumsRepository.getUserAlbumsPreview(fetchDataEvent.userId, count: 3);
  }
}

class AlbumsPreviewFetchEvent extends SyncBlocFetchData {
  final String userId;

  AlbumsPreviewFetchEvent({
    required this.userId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
