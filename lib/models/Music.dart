import 'package:hive/hive.dart';
part 'Music.g.dart';

@HiveType(typeId: 1)
class Music {
  Music(
    this.id,
    this.artist,
    this.cover,
    this.url,
    this.title,
    this.trackTimeMillis,
    this.artistUrl,
  );
  @HiveField(1)
  int id;

  @HiveField(2)
  String title;

  @HiveField(3)
  String artist;

  @HiveField(5)
  String cover;

  @HiveField(6)
  String url;

  @HiveField(7)
  String artistUrl;

  @HiveField(8)
  int trackTimeMillis;
}
