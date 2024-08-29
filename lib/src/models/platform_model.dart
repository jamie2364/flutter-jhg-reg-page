import 'package:reg_page/src/utils/res/constants.dart';
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
      platform: Constants.jamieUrlText,
      baseUrl: Urls.jhgUrl,
    ));
    list.add(PlatformModel(
      platform: Constants.evoloUrlText,
      baseUrl: Urls.evoloUrl,
    ));
    list.add(PlatformModel(
      platform: Constants.musicToolUrlText,
      baseUrl: Urls.musicUrl,
    ));
    return list;
  }
}
