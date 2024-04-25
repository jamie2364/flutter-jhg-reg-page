import 'dart:io';

import 'package:reg_page/reg_page.dart';

File getAsset(String path) => File(
    "${StringsDownloadService().dir?.path}/assets/$path");

