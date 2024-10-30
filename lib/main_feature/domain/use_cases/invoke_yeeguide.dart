
import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../model/yeeguide_response.dart';
import '../repository/yeebot_repo.dart';

class InvokeYeeguideUseCase {
  final YeebotRepo _yeebotRepo = locator.get<YeebotRepo>();

  Stream<Resource<YeeguideResponse>> execute(String yeeguideId, String message) async* {
    yield Resource.loading();

    final response = await _yeebotRepo.invokeYeeguide(yeeguideId, message);

    if (response.data != null) {
      final yeeguideResponse = response.data!;
      yield Resource.success(yeeguideResponse);
    } else {
      if (response.type == ResourceType.error) {
        yield Resource.error(response.message ?? "");
      } else {
        yield Resource.success(YeeguideResponse());
      }
    }
  }
}