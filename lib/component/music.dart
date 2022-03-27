import 'package:cached_network_image/cached_network_image.dart';
import 'package:fita_audio_player/models/Music.dart';
import 'package:fita_audio_player/provider/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

Widget musicWidget(context, Music music, List<Music> listMusic, SourceMusic source) {
  Size size = MediaQuery.of(context).size;
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    width: size.width * 0.9,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CachedNetworkImage(
          imageUrl: music.cover,
          imageBuilder: (context, image) {
            return Container(
              margin: EdgeInsets.only(right: 6),
              width: 45,
              height: 45,
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
            return Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(right: 6),
                  width: 45,
                  height: 45,
                  child: Row(),
                ),
                baseColor: Color.fromARGB(255, 95, 125, 156),
                highlightColor: Color.fromARGB(255, 65, 95, 124));
          },
        ),
        Expanded(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 3),
                child: Text(
                  music.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                music.artist,
                style: TextStyle(
                    color: Color.fromARGB(255, 194, 194, 194), fontSize: 12),
              )
            ],
          ),
        )),
        IconButton(
          onPressed: () async =>
              await Provider.of<AudioProvider>(context, listen: false)
                  .playSource(music, listMusic, source),
          icon:
              Consumer<AudioProvider>(builder: (context, audioProvider, child) {
            return Icon(
              audioProvider.music != null && audioProvider.music!.id == music.id
                  ? Icons.music_note_rounded
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34,
            );
          }),
        )
      ],
    ),
  );
}
