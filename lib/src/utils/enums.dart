import 'package:reg_page/src/utils/urls.dart';

enum BaseUrl {
  empty(''),
  musictools(Urls.musicUrl),
  jhg(Urls.jhgUrl),
  evolo(Urls.evoloUrl);

  final String url;
  const BaseUrl(this.url);
  
  @override
  String toString() => url;

  static BaseUrl fromString(String url) => BaseUrl.values
      .firstWhere((e) => e.url == url, orElse: () => BaseUrl.empty);

  bool isEqual(String other) => url == other;
}
