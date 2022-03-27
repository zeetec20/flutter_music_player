import 'package:cached_network_image/cached_network_image.dart';
import 'package:fita_audio_player/models/Artist.dart';
import 'package:fita_audio_player/pages/artist_page.dart';
import 'package:fita_audio_player/provider/app_provider.dart';
import 'package:fita_audio_player/provider/audio_provider.dart';
import 'package:fita_audio_player/provider/search_provider.dart';
import 'package:fita_audio_player/services/audio_service.dart';
import 'package:fita_audio_player/utils/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPage extends StatelessWidget {
  final Function(int) changePage;

  DashboardPage(this.changePage);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget artistWidget(
        context,
        String name,
        String? image,
        AppProvider appProvider,
        AudioProvider audioProvider,
        SearchProvider searchProvider) {
      Size size = MediaQuery.of(context).size;
      Widget loadingImage() {
        return Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: 140,
              child: Row(),
            ),
            baseColor: Color.fromARGB(255, 95, 125, 156),
            highlightColor: Color.fromARGB(255, 65, 95, 124));
      }

      return Expanded(
          child: Container(
        decoration: BoxDecoration(
            color: ColorTheme.color2,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 6))
            ]),
        margin: EdgeInsets.only(
            left: size.width * 0.025, right: size.width * 0.025, top: 20),
        child: GestureDetector(
          onTap: () {
            if (image != null)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: appProvider,
                    child: ChangeNotifierProvider.value(
                      value: audioProvider,
                      child: ChangeNotifierProvider.value(
                        value: searchProvider,
                        child: ArtistPage(Artist(name, image)),
                      ),
                    ),
                  ),
                ),
              );
          },
          child: Column(
            children: [
              image != null
                  ? CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, image) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(image: image),
                          ),
                        );
                      },
                      placeholder: (context, progress) {
                        return loadingImage();
                      },
                    )
                  : loadingImage(),
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorTheme.color3),
                    )),
                    FaIcon(
                      FontAwesomeIcons.play,
                      size: 18,
                      color: ColorTheme.color3,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: ColorTheme.color1,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 15,
                        left: size.width * 0.05,
                        right: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                              color: ColorTheme.color3,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            changePage(1);
                          },
                          child: Icon(
                            Icons.search_rounded,
                            size: 30,
                            color: ColorTheme.color3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    margin: EdgeInsets.only(
                        top: 20,
                        left: size.width * 0.05,
                        right: size.width * 0.05),
                    decoration: BoxDecoration(
                        color: ColorTheme.color2,
                        image: DecorationImage(
                            image: AssetImage('assets/images/dashboard.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8, right: 15),
                                child: Text(
                              'Listen your favorite music',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: ColorTheme.color3,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900),
                            )),
                            Container(
                              margin: EdgeInsets.only(top: 13),
                              child: TextButton(
                                onPressed: () {
                                  changePage(1);
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.white.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                          offset: Offset(0, 6))
                                    ]),
                                    child: Text(
                                      'Get Your Music',
                                      style: TextStyle(
                                          color: ColorTheme.color3,
                                          fontWeight: FontWeight.bold),
                                    )),
                                style: TextButton.styleFrom(
                                    backgroundColor: ColorTheme.color4,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 40,
                        left: size.width * 0.05,
                        right: size.width * 0.05),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Popular Artist',
                      style: TextStyle(
                          color: ColorTheme.color3,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureProvider<List<Artist>?>(
                    create: (_) => AudioService.getPopularArtist(),
                    initialData: null,
                    builder: (context, child) {
                      List<Artist>? popularArtist =
                          Provider.of<List<Artist>?>(context);
                      List<List<Artist>> refactorPopularArtist = [];
                      (popularArtist ?? []).asMap().entries.forEach((data) {
                        if (((data.key + 1) % 2) == 0)
                          return refactorPopularArtist[
                                  refactorPopularArtist.length - 1]
                              .add(data.value);
                        return refactorPopularArtist.add([data.value]);
                      });

                      return Container(
                        margin: EdgeInsets.only(
                            left: size.width * 0.025,
                            right: size.width * 0.025),
                        child: Consumer<AudioProvider>(
                            builder: (context, audioProvider, child) {
                          return Column(
                            children: [
                              ...refactorPopularArtist.map((popularArtist) {
                                return Consumer2<AppProvider, SearchProvider>(
                                    builder: (context, appProvider,
                                        searchProvider, child) {
                                  return Row(
                                    children: popularArtist.map((artist) {
                                      String name = artist.name;
                                      String url = artist.image;
                                      return FutureProvider<String?>(
                                        create: (_) =>
                                            AudioService.getImageArtist(url),
                                        initialData: null,
                                        builder: (context, child) {
                                          return artistWidget(
                                              context,
                                              name,
                                              Provider.of<String?>(context),
                                              appProvider,
                                              audioProvider,
                                              searchProvider);
                                        },
                                      );
                                    }).toList(),
                                  );
                                });
                              }).toList(),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: audioProvider.isPlayed ||
                                          audioProvider.isPaused
                                      ? 160
                                      : 0)
                            ],
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
