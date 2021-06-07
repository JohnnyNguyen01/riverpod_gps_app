class Assets {
  static final Assets _singleton = Assets._internal();

  factory Assets() {
    return _singleton;
  }

  Assets._internal();

  static const miniDachsundImg = 'assets/images/cute_mini_dachshund.jpeg';
}
