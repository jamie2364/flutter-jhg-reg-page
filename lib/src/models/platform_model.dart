import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/utils/app_urls.dart';

class PlatformModel {
  String platform;
  String baseUrl;

  PlatformModel({
    required this.platform,
    required this.baseUrl,
  });

  static List<PlatformModel> getList() {
    var list = <PlatformModel>[];
    list.add(PlatformModel(
      platform: Constant.jamieUrlText,
      baseUrl: AppUrls.jamieUrl,
    ));
    list.add(PlatformModel(
      platform: Constant.evoloUrlText,
      baseUrl: AppUrls.evoloUrl,
    ));
    list.add(PlatformModel(
      platform: Constant.musicToolUrlText,
      baseUrl: AppUrls.musicUrl,
    ));
    return list;
  }
}
