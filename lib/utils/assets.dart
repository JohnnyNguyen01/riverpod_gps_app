class Assets {
  static final Assets _singleton = Assets._internal();

  factory Assets() {
    return _singleton;
  }

  Assets._internal();

  static const miniDachsundImg = 'assets/images/cute_mini_dachshund.jpeg';
  static const mapMarker = 'assets/images/map_marker_30.png';
  static const tarzanDrawerPhoto = 'assets/images/tarzan_drawer_photo.jpg';
}
