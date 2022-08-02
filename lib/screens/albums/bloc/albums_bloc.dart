import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/repositories/albums_repository.dart';

class AlbumsSyncBloc
    extends BaseSyncBloc<BuiltList<AlbumPreviewDto>, AlbumsFetchEvent> {
  final AlbumsRepository albumsRepository;

  AlbumsSyncBloc({required this.albumsRepository}) : super(null);

  @override
  Future<BuiltList<AlbumPreviewDto>> fetch(AlbumsFetchEvent fetchDataEvent) async {
    return albumsRepository.getUserAlbumsPreview(fetchDataEvent.userId);
  }
}

class AlbumsFetchEvent extends SyncBlocFetchData {
  final String userId;

  AlbumsFetchEvent({
    required this.userId,
    bool clearData = false,
  }) : super(clearData: clearData);
}
