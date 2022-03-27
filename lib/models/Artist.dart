class Artist {
  final String name;
  final String image;
  String get keywordSearch => name.toLowerCase().replaceAll(' ', '+');

  Artist(this.name, this.image);
}
