import 'package:cached_network_image/cached_network_image.dart';
import 'package:fita_audio_player/component/music.dart';
import 'package:fita_audio_player/models/Artist.dart';
import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/provider/audio_provider.dart';
import 'package:fita_audio_player/services/audio_service.dart';
import 'package:fita_audio_player/utils/color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LibraryPage extends StatelessWidget {
  final Function(int) changePage;
  LibraryPage(this.changePage);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorTheme.color1,
      body: SafeArea(
        child: ListView(
          children: [
            FutureProvider<ValueListenable<Box<Music>>?>(
                create: (_) => AudioService.streamSavedMusic(),
                initialData: null,
                builder: (context, child) {
                  ValueListenable<Box<Music>>? music =
                      Provider.of<ValueListenable<Box<Music>>?>(context);
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      music != null
                          ? ValueListenableBuilder<Box<Music>>(
                              valueListenable: music,
                              builder: (context, listMusic, child) {
                                return Opacity(
                                  opacity:
                                      listMusic.values.length == 0 ? 1 : 0.6,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/search_image.png'),
                                            fit: BoxFit.cover)),
                                    child: Row(),
                                  ),
                                );
                              })
                          : Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/search_image.png'),
                                      fit: BoxFit.cover)),
                              child: Row(),
                            ),
                      Column(
                        children: [
                          music != null
                              ? ValueListenableBuilder<Box<Music>>(
                                  valueListenable: music,
                                  builder: (context, listMusic, child) {
                                    if (listMusic.isEmpty) return SizedBox();
                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 15,
                                          left: size.width * 0.05,
                                          right: size.width * 0.05),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Library Music',
                                            style: TextStyle(
                                                color: ColorTheme.color3,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : SizedBox(),
                          SizedBox(
                            height: 15,
                          ),
                          music != null
                              ? ValueListenableBuilder<Box<Music>>(
                                  valueListenable: music,
                                  builder: (context, listMusic, child) {
                                    List<Artist> listArtist = listMusic.values
                                        .map((music) => music.artist)
                                        .toSet()
                                        .map((e) {
                                          Music music = listMusic.values
                                              .where((element) =>
                                                  element.artist == e)
                                              .first;
                                          return {
                                            'artist': music.artist,
                                            'url': music.artistUrl
                                          };
                                        })
                                        .map((e) =>
                                            Artist(e['artist']!, e['url']!))
                                        .toList();
                                    return Column(
                                      children: [
                                        listArtist.length == 0
                                            ? Column(
                                                children: [
                                                  Container(
                                                    key: UniqueKey(),
                                                    margin: EdgeInsets.only(
                                                        top: size.height * 0.35,
                                                        left: size.width * 0.05,
                                                        right:
                                                            size.width * 0.05),
                                                    child: Text(
                                                      'Save your music and play anytime you want.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              ColorTheme.color3,
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.7,
                                                    margin: EdgeInsets.only(
                                                      top: 20,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.white
                                                              .withOpacity(0.1),
                                                          spreadRadius: 5,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 6),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        changePage(1);
                                                      },
                                                      child: Text(
                                                        'Search Music',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: ColorTheme
                                                                .color1,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                        ...listArtist.map((artist) {
                                          return FutureBuilder<String?>(
                                            future: AudioService.getImageArtist(
                                                artist.image),
                                            initialData: null,
                                            builder: (context, image) {
                                              return artistWidget(
                                                  context,
                                                  artist.name,
                                                  image.data,
                                                  listMusic.values.toList());
                                            },
                                          );
                                        }).toList(),
                                        Consumer<AudioProvider>(builder:
                                            (context, audioProvider, child) {
                                          return AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              height: audioProvider.isPlayed ||
                                                      audioProvider.isPaused
                                                  ? 200
                                                  : 0);
                                        })
                                      ],
                                    );
                                  })
                              : SizedBox()
                        ],
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}

Widget artistWidget(
    context, String name, String? image, List<Music> listMusic) {
  listMusic = listMusic.where((e) => e.artist == name).toList();
  Size size = MediaQuery.of(context).size;
  Widget loadingImage() {
    return Shimmer.fromColors(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(right: 6),
        width: 55,
        height: 55,
        child: Row(),
      ),
      baseColor: Color.fromARGB(255, 95, 125, 156),
      highlightColor: Color.fromARGB(255, 65, 95, 124),
    );
  }

  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(
            bottom: 15,
            left: size.width * 0.05,
            right: size.width * 0.05,
            top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image != null
                ? CachedNetworkImage(
                    imageUrl: image,
                    imageBuilder: (context, image) {
                      return Container(
                        margin: EdgeInsets.only(right: 6),
                        width: 55,
                        height: 55,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, progress) {
                      return loadingImage();
                    },
                  )
                : loadingImage(),
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${listMusic.length} Songs',
                    style: TextStyle(
                        color: Color.fromARGB(255, 194, 194, 194),
                        fontSize: 11),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            bottom: 20, left: size.width * 0.05, right: size.width * 0.05),
        height: 1.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.5)),
        child: Row(),
      ),
      ...listMusic
          .map((e) =>
              Consumer<AudioProvider>(builder: (context, audioProvider, child) {
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: UniqueKey(),
                  child:
                      musicWidget(context, e, listMusic, SourceMusic.library),
                  onDismissed: (direction) async {
                    if (audioProvider.sourceMusic == SourceMusic.library)
                      audioProvider.removeMusic(e);
                    await AudioService.remove(e);
                  },
                );
              }))
          .toList(),
    ],
  );
}
