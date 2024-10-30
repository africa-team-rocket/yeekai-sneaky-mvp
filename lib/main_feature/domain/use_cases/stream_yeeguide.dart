import 'dart:async';
import 'dart:developer';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../model/yeeguide_response.dart';
import '../repository/yeebot_repo.dart';


class StreamYeeguideUseCase {
  final YeebotRepo _yeebotRepo = locator.get<YeebotRepo>();

  Stream<Resource<YeeguideResponse>> execute(
      String yeeguideId, String message) async* {
    yield Resource.loading();

    final responseStream = _yeebotRepo.streamYeeguide(yeeguideId, message);

    await for (final chunk in responseStream) {
      if (chunk.output != null) {
        final output = chunk.output;
        for (int i = 0; i < output!.length; i++) {
          final letter = output[i];
          yield Resource.success(YeeguideResponse(
              metadata: chunk.metadata, output: letter, isOver: chunk.isOver));
        }
      } else {
        yield Resource.success(
            YeeguideResponse(metadata: chunk.metadata, isOver: chunk.isOver));
      }
    }
  }
}
