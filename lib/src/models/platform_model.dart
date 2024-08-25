import 'package:reg_page/src/utils/res/constant.dart';
import 'package:reg_page/src/utils/res/urls.dart';

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
      baseUrl: Urls.jhgUrl,
    ));
    list.add(PlatformModel(
      platform: Constant.evoloUrlText,
      baseUrl: Urls.evoloUrl,
    ));
    list.add(PlatformModel(
      platform: Constant.musicToolUrlText,
      baseUrl: Urls.musicUrl,
    ));
    return list;
  }
}
