import 'package:reg_page/src/constant.dart';
import 'package:reg_page/src/models/platform_model.dart';

class PlatformUtils {
  PlatformUtils._();

  static List<PlatformModel> getList() {
    var list = <PlatformModel>[];
    list.add(PlatformModel(
        platform: Constant.jamieUrlText,
        baseUrl: Constant.jamieUrl,
        loginUrl: Constant.loginUrl,
        subscriptionURL: Constant.subscriptionUrl));
    list.add(PlatformModel(
        platform: Constant.evoloUrlText,
        baseUrl: Constant.evoloUrl,
        loginUrl: Constant.evoloLoginUrl,
        subscriptionURL: Constant.subscriptionUrlEvolo));
    list.add(PlatformModel(
        platform: Constant.musicToolUrlText,
        baseUrl: Constant.musicUrl,
        loginUrl: Constant.musicLoginUrl,
        subscriptionURL: Constant.subscriptionUrlMusicTool));

    return list;
  }
}
