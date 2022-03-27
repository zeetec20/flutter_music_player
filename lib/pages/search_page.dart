import 'package:fita_audio_player/component/music.dart';
import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/provider/audio_provider.dart';
import 'package:fita_audio_player/provider/search_provider.dart';
import 'package:fita_audio_player/utils/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorTheme.color1,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Consumer<SearchProvider>(builder: (context, searchProvider, child) {
              List<Music> listMusic = searchProvider.search ?? [];
              return Opacity(
                opacity: listMusic.isEmpty ? 1 : 0.6,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/search_image.png'),
                          fit: BoxFit.cover)),
                  child: Row(),
                ),
              );
            }),
            Consumer<SearchProvider>(builder: (context, searchProvider, child) {
              List<Music> listMusic = searchProvider.search ?? [];
              return ListView(
                children: [
                  Column(
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                        child: listMusic.isEmpty
                            ? Container(
                                key: UniqueKey(),
                                margin:
                                    EdgeInsets.only(top: size.height * 0.37),
                                child: Text(
                                  'Search music for your moods.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorTheme.color3,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ))
                            : SizedBox(
                                key: UniqueKey(),
                              ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 350),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 15, right: 15, top: 3),
                        margin: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            top: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              )
                            ],
                            borderRadius: BorderRadius.circular(11)),
                        child: TextField(
                          onSubmitted: (keyword) async {
                            if (!searchProvider.loadingSearch)
                              await searchProvider.searchMusic(keyword);
                          },
                          textInputAction: TextInputAction.search,
                          cursorColor: ColorTheme.color4,
                          controller: searchProvider.searchController,
                          decoration: InputDecoration(
                              hintText: 'Search music...',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () async {
                                    if (!searchProvider.loadingSearch) {
                                      await searchProvider.searchMusic(
                                          searchProvider.searchController.text);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    }
                                  },
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: ColorTheme.color4,
                                    size: 30,
                                  ))),
                        ),
                      )
                    ],
                  ),
                  listMusic.isEmpty
                      ? SizedBox()
                      : Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            ...listMusic
                                .map((music) => musicWidget(context, music,
                                    listMusic, SourceMusic.search))
                                .toList(),
                            Consumer<AudioProvider>(
                                builder: (context, audioProvider, child) {
                              return AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: audioProvider.isPlayed ||
                                          audioProvider.isPaused
                                      ? 200
                                      : 0);
                            })
                          ],
                        )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
