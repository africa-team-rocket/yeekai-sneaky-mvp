import 'package:flutter/cupertino.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../model/gift.dart';
import '../repository/yeegifts_repo.dart';

// Après nous ajouterons directement la synchronisation ici
class GetAllGiftsFromCacheUseCase {
  final YeegiftsRepo _yeegiftsRepo = locator.get<YeegiftsRepo>();

  Stream<Resource<List<Gift>>> execute() async* {
    try {
      yield Resource.loading();
      final giftsResource = await _yeegiftsRepo.fetchGiftsFromCache();
      debugPrint("We're in gifts cache UseCase bro : " + giftsResource.toString());

      if (giftsResource.data != null) {
        yield Resource.success(giftsResource.data!);
        debugPrint("Cadeaux récupérés from UseCase cache");
      } else {
        yield Resource.error(giftsResource.message ?? 'Une erreur s\'est produite lors de la récupération des cadeaux (cache), liste vide');
      }
    } catch (e) {
      yield Resource.error('Une erreur inattendue est survenue lors de la récupération des cadeaux (cache): $e');
    }
  }
}
