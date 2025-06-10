import 'package:yeebus_filthy_mvp/map_feature/data/local/gifts_dao.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../../domain/model/gift.dart';
import '../../domain/repository/yeegifts_repo.dart';
import '../remote/api/yeegifts_api.dart';

class YeegiftsRepoImpl extends YeegiftsRepo {
  final YeegiftsApi _yeegiftsApi = locator.get<YeegiftsApi>();
  final YeegiftsDao _yeegiftsDao = locator.get<YeegiftsDao>();

  @override
  Future<Resource<List<Gift>>> fetchGiftsFromCache() async {

      final gifts = await _yeegiftsDao.getAllGifts();
      return Resource.success(gifts);

  }

  @override
  Future<Resource<String>> updateGiftsCache(List<Gift> remoteResponse) async {

        await _yeegiftsDao.updateAllGifts(remoteResponse);
        return Resource.success("Cache mis à jour avec succès.");

  }

  @override
  Future<Resource<List<Gift>>> fetchGiftsFromRemote() async {
    final response = await _yeegiftsApi.fetchGifts();
    if (response.data != null) {
      final gifts = response.data!.map((giftJson) => Gift.fromJson(giftJson)).toList();
      return Resource.success(gifts);
    } else {
      return Resource.error(response.message ?? "Erreur lors de la récupération des cadeaux.");
    }
  }

  @override
  Future<Resource<List<Gift>>> fetchGiftsByEventFromRemote(GiftEvent event) async {
    final response = await _yeegiftsApi.fetchGiftsByEvent(event.toString().split('.').last);
    if (response.data != null) {
      final gifts = response.data!.map((giftJson) => Gift.fromJson(giftJson)).toList();
      return Resource.success(gifts);
    } else {
      return Resource.error(response.message ?? "Erreur lors de la récupération des cadeaux pour l'événement.");
    }
  }

  @override
  Future<Resource<Gift>> fetchGiftByIdFromRemote(String giftId) async {
    final response = await _yeegiftsApi.fetchGiftById(giftId);
    if (response.data != null) {
      final gift = Gift.fromJson(response.data!);
      return Resource.success(gift);
    } else {
      return Resource.error(response.message ?? "Erreur lors de la récupération du cadeau.");
    }
  }

  @override
  Future<Resource<String>> updateGiftFromRemote(String giftId, Gift gift) async {
    final response = await _yeegiftsApi.updateGift(giftId, gift.toJson());
    return response;
  }

  @override
  Future<Resource<String>> toggleGiftWasFoundFromRemote(String giftId) async {
    final response = await _yeegiftsApi.toggleGiftWasFound(giftId);
    return response;
  }


}
