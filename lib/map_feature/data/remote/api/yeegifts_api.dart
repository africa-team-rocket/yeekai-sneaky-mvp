import '../../../../core/commons/utils/resource.dart';

abstract class YeegiftsApi {
  static const String API_BASE_URL = "https://yeekai-backend-production.up.railway.app/v1";

  Future<Resource<List<Map<String, dynamic>>>> fetchGifts();

  // Endpoints à éliminer aussi ? :
  Future<Resource<List<Map<String, dynamic>>>> fetchGiftsByEvent(String event);
  Future<Resource<Map<String, dynamic>>> fetchGiftById(String giftId);

  // Endpoint à éliminer :
  Future<Resource<String>> updateGift(String giftId, Map<String, dynamic> payload);
  // Future<Resource<String>> addGift(Map<String, dynamic> payload);
  Future<Resource<String>> toggleGiftWasFound(String giftId);
}
