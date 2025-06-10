
import 'package:flutter/cupertino.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../model/yeeguide_response.dart';
import '../repository/yeebot_repo.dart';

class CancelAiStreamUseCase {
  final YeebotRepo _yeebotRepo = locator.get<YeebotRepo>();

  Stream<Resource<String>> execute() async* {
    debugPrint("Cancel use case called");
    yield Resource.loading();

    _yeebotRepo.cancelStream();

    yield Resource.success("Annulé avec succès");

  }
}