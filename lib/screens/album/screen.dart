import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/dto/album_preview_dto.dart';
import 'package:test_project/network/models/photo.dart';
import 'package:test_project/repositories/albums_repository.dart';

import 'bloc/album_photos_bloc.dart';

class AlbumVM extends DisposableVM {
  late final AlbumPhotosSyncBloc albumPhotosSyncBloc;
  late final PageController pageController;
  late final BehaviorSubject<double> listenablePageController;

  AlbumVM(String albumId) {
    albumPhotosSyncBloc =
        AlbumPhotosSyncBloc(albumsRepository: AlbumsRepositoryImpl());
    pageController = PageController();

    listenablePageController = BehaviorSubject<double>();
    listenablePageController.add(0);

    pageController.addListener(() {
      listenablePageController.add(pageController.page ?? 0);
    });

    albumPhotosSyncBloc.add(AlbumPhotosFetchEvent(albumId: albumId));

    add(() {
      albumPhotosSyncBloc.close();
      pageController.dispose();
      listenablePageController.close();
    });
  }

  BuiltList<Photo> get photos {
    assert(albumPhotosSyncBloc.state.data != null,
        'no data in albumPhotosSyncBloc');
    return albumPhotosSyncBloc.state.data!;
  }

  bool get albumsSyncing =>
      albumPhotosSyncBloc.state.syncing || !albumPhotosSyncBloc.state.hadSync;

  void setPage(double page) {
    pageController.jumpToPage(page.round());
  }
}

class AlbumScreen extends StatefulWidget {
  final AlbumPreviewDto album;

  const AlbumScreen({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlbumScreenState();
}

class AlbumScreenState extends State<AlbumScreen> {
  late final AlbumVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = AlbumVM(widget.album.albumId.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos of ${widget.album.title} album'),
      ),
      body: BlocBuilder(
          bloc: _vm.albumPhotosSyncBloc,
          builder: (context, _) {
            if (_vm.albumsSyncing) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_vm.albumPhotosSyncBloc.state.hasOnlyError) {
              return Center(
                child: Text(
                  'Ошибка синхронизации.\n${_vm.albumPhotosSyncBloc.state.lastSyncError}',
                ),
              );
            }

            return Stack(
              children: [
                PageView(
                  controller: _vm.pageController,
                  children: _vm.photos
                      .map(
                        (photo) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(photo.url),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Text(
                                photo.title,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                StreamBuilder<double>(
                  stream: _vm.listenablePageController,
                  builder: (context, snapshot) {
                    final currentPage = snapshot.data ?? 0;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 80,
                        child: Slider(
                          max: _vm.photos.length * 1.0,
                          divisions: _vm.photos.length,
                          value: currentPage,
                          onChanged: (value) {
                            _vm.setPage(value);
                          },
                          label: '${(currentPage + 1).round()}',
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
