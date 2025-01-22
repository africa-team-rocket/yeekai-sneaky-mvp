import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../model/gift.dart';
import '../repository/yeegifts_repo.dart';

class SyncGiftsUseCase {
  final YeegiftsRepo _yeegiftsRepo = locator.get<YeegiftsRepo>();

  // Stream pour surveiller l’état de la connectivité
  //final Stream<List<ConnectivityResult>> connectivityStream = Connectivity().onConnectivityChanged;


  Stream<Resource<List<Gift>>> execute() async* {
    try {
      // Étape 1 : Récupération du contenu en local
      yield Resource.loading();
      final giftsResourceLocal = await _yeegiftsRepo.fetchGiftsFromCache();
      if (giftsResourceLocal.data != null) {
        debugPrint("Contenu local récupéré avec succès.");
        yield Resource.success(giftsResourceLocal.data!);
      } else if (giftsResourceLocal.message != null) {
        debugPrint("Erreur lors de la récupération du contenu local : ${giftsResourceLocal.message}");
        yield Resource.error(giftsResourceLocal.message!);
      }


      // Étape 1.5 : Vérification de la connectivité avant l'appel remote
      // final connectivityResult = await Connectivity().checkConnectivity();
      // debugPrint("COnnectivity : " + connectivityResult.toString());
      // if (connectivityResult == ConnectivityResult.none) {
      //  debugPrint("Pas de connexion réseau disponible.");
      //  yield Resource.error("Aucune connexion réseau. Veuillez réessayer plus tard.");
      //  return;
      //}

      // TODO : AJOUTER UN TEST DE CONNECTIVITÉ JUSTE ICI (avec un message pour dire à la personne de se connecter)
      // Étape 2 : Récupération du contenu en remote
      final giftsResourceRemote = await _yeegiftsRepo.fetchGiftsFromRemote();
      if (giftsResourceRemote.data == null) {
        debugPrint("Erreur lors de la récupération du contenu remote : ${giftsResourceRemote.message}");
        yield Resource.error(giftsResourceRemote.message ?? "Erreur lors de la récupération des cadeaux depuis le remote.");
        return;
      }
      final remoteGifts = giftsResourceRemote.data!;
      debugPrint("Contenu remote récupéré avec succès.");

      // Étape 3 : Comparaison des contenus local et remote
      final localGifts = giftsResourceLocal.data ?? [];
      if (!_areGiftListsEqual(localGifts, remoteGifts)) {
        debugPrint("Les contenus local et remote sont différents. Synchronisation en cours...");

        // Étape 4 : Synchronisation avec le cache
        final syncResource = await _yeegiftsRepo.updateGiftsCache(remoteGifts);
        if (syncResource.data != null) {
          debugPrint("Synchronisation réussie : ${syncResource.data}");
        } else {
          debugPrint("Erreur lors de la synchronisation : ${syncResource.message}");
        }
      } else {
        debugPrint("Les contenus local et remote sont identiques. Aucune synchronisation nécessaire.");
      }

      // Étape 5 : Émission du contenu final (remote)
      yield Resource.success(remoteGifts);
    } catch (e) {
      debugPrint("Erreur inattendue : $e");
      yield Resource.error('Une erreur inattendue est survenue : $e');
    }
  }

  // Fonction utilitaire pour comparer deux listes de cadeaux
  bool _areGiftListsEqual(List<Gift> localGifts, List<Gift> remoteGifts) {
    if (localGifts.length != remoteGifts.length) return false;

    for (int i = 0; i < localGifts.length; i++) {
      if (localGifts[i] != remoteGifts[i]) return false;
    }
    return true;
  }
}
