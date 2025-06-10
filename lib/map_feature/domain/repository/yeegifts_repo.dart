import '../../../core/commons/utils/resource.dart';
import '../model/gift.dart';

abstract class YeegiftsRepo {

  // Récupérer tous les cadeaux depuis le remote
  Future<Resource<List<Gift>>> fetchGiftsFromRemote();

  // Récupérer les cadeaux par événement depuis le remote
  Future<Resource<List<Gift>>> fetchGiftsByEventFromRemote(GiftEvent event);

  // Récupérer un cadeau par son id depuis le remote
  Future<Resource<Gift>> fetchGiftByIdFromRemote(String giftId);

  // Mettre à jour un cadeau sur le remote
  Future<Resource<String>> updateGiftFromRemote(String giftId, Gift gift);

  // Toggle l'attribut 'wasFound' d'un cadeau sur le remote
  Future<Resource<String>> toggleGiftWasFoundFromRemote(String giftId);

  /// TODO LATER, ADD OFFLINE MODE :

  // Ajouter les méthodes de traitement en local plus tard ici :

    // Une méthode pour récupérer la liste en local
    Future<Resource<List<Gift>>> fetchGiftsFromCache();

    // Une méthode pour récupérer la liste en local par événement (NO NEED FOR NOW)

    // Une méthode pour récupérer un gift par ID en local (NO NEED FOR NOW)

    // Méthode de synchronisation :
    Future<Resource<String>> updateGiftsCache(List<Gift> remoteResponse);


// Une méthode pour override tout le contenu local par le contenu à jour provenant de l'API

}
