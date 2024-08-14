import 'package:reg_page/src/utils/app_urls.dart';

enum BaseUrl {
  empty(''),
  musictools(AppUrls.musicUrl),
  jhg(AppUrls.jhgUrl),
  evolo(AppUrls.evoloUrl);

  final String url;
  const BaseUrl(this.url);
  @override
  String toString() => url;

  static BaseUrl fromString(String url) {
    return BaseUrl.values
        .firstWhere((e) => e.url == url, orElse: () => BaseUrl.empty);
  }

  // Method to compare enum values
  bool isEqual(String other) {
    return url == other;
  }
}
