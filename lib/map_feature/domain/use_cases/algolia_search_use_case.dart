
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/commons/utils/resource.dart';
import '../../presentation/search_screen/bloc/search_state.dart';
import '../model/hits_page.dart';
import '../model/search_hit_entity.dart';

// Création des instances de SearchHitEntity
var stop1 = SearchHitStop(
  'stop',
  1,
  'Arrêt Dardanelles',
  14.6928,
  -17.4467,
);

var stop2 = SearchHitStop(
  'stop',
  2,
  'Arrêt Colobane',
  14.6919,
  -17.4375,
);

var stop3 = SearchHitStop(
  'stop',
  3,
  'Arrêt Liberté 6',
  14.6993,
  -17.4647,
);

var place1 = SearchHitPlace(
  'place',
  'Cité Assemblée',
  'Proche de l\'Assemblée Nationale',
  'place_id_1',
  'reference_1',
  'Cité Assemblée Nationale, Dakar',
);

var place2 = SearchHitPlace(
  'place',
  'Sicap Foire',
  'Près du Parc des Expositions',
  'place_id_2',
  'reference_2',
  'Sicap Foire, Dakar',
);

var route1 = SearchHitRoute(
  'route',
  'route_id_1',
  'agency_id_1',
  'Ligne 47',
  'De Liberté 6 à HLM Grand Yoff',
);

var route2 = SearchHitRoute(
  'route',
  'route_id_2',
  'agency_id_2',
  'Ligne 12',
  'De Parcelles Assainies à Plateau',
);

// Création des pages de HitsPage
var hitsPage1 = HitsPage(
  [stop1, place1, route1],
  1,
  2,
);

var hitsPage2 = HitsPage(
  [stop2, place2, route2],
  2,
  3,
);

var hitsPage3 = HitsPage(
  [stop3],
  3,
  null, // Indique la dernière page
);

// Liste de HitsPage
var hitsPages = [hitsPage1, hitsPage2, hitsPage3];


class MultimodalSearchUseCase {

  String queryState = "";

  StreamController<List<SearchHitPlace>> _dataStreamController = StreamController<List<SearchHitPlace>>();

  Stream<List<SearchHitPlace>> get _placesStream => _dataStreamController.stream.asBroadcastStream();

// À appeler chaque fois que queryState change
  void updateData(List<SearchHitPlace> newData) {
  _dataStreamController.sink.add(newData);
  }

// À appeler lors de la fermeture de l'application ou du composant
  void closeStream() {
    // Fermer le stream de places
    _dataStreamController.close();

    // Fermer les streams du searcher
    // _stopsAndRoutesSearcher.dispose();
  }



  // Ces informations aussi doivent être cachés somewhere.
  // Flemme pour l'instant mais ce truc doit retourner dans la couche data sinon tu
  // vas l'instancier trop de fois pour rien.
  // final _stopsAndRoutesSearcher = HitsSearcher(applicationID: 'DN8EN2C9XE',
  //     apiKey: '407ebbb4f64d7a098b6a1b6464a20ab2',
  //     indexName: 'dev_routes_and_stops');

  // final _placesSearcher = locator.get<GooglePlacesRepo>();

  // Stream<HitsPage> get _stopsAndRoutesSearchPage => _stopsAndRoutesSearcher.responses.map(HitsPage.fromResponse);
  Stream<HitsPage> get _stopsAndRoutesSearchPage => Stream.fromIterable(hitsPages);
  // Stream<HitsPage> get _placesSearchPage => _placesSearcher.autocompletePlaces(query: _stopsAndRoutesSearcher.snapshot().query?? "").map(HitsPage.fromResponse);


  Stream<Resource<HitsPage>> execute() {

    try {
      // Vous pouvez simplement retourner le Stream `_searchPage`.

      // Combiner les deux streams en un seul
      final combinedStream = Rx.combineLatest2<HitsPage, List<SearchHitPlace>, HitsPage>(
        _stopsAndRoutesSearchPage,
        _placesStream,
            (stopsAndRoutes, places) {
          // Fusionnez les résultats des deux flux en une seule liste
          //     final mergedItems = sortSearchHits([...stopsAndRoutes.items, ...places], queryState);
              final mergedItems = [...stopsAndRoutes.items, ...places];
          return HitsPage(mergedItems, stopsAndRoutes.pageKey, stopsAndRoutes.nextPageKey);
        },
      );

      return combinedStream.map((page) {
        debugPrint("Ici le use case, voici ce qu'on a : $page");
        return Resource.success(page);
      }).onErrorReturnWith((error, stackTrace) => Resource.error('An error occurred : $error'));
      // return  _stopsAndRoutesSearchPage.map((page) {
      //
      //   debugPrint("Ici le use case, voici ce qu'on a : $page");
      //   // return Resource.success(page);
      //   return Resource.success(page);
      // })
    } catch (e) {
      return Stream.value(Resource.error('An error occurred : $e'));
    }

  }

  // Cette fonction vous permet de mettre à jour l'état du `_productsSearcher`.
  Future<void> applySearchState(SearchState Function(SearchState) stateUpdater, String query) async {
    // debugPrint("Apply State a été appelé : $stateUpdater");
    // _stopsAndRoutesSearcher.applyState(stateUpdater);
    queryState = query;
    // List<SearchHitPlace> newPlaces = await _placesSearcher.autocompletePlaces(query: query);
    // updateData(newPlaces);
  }


  void dispose() {
    // _stopsAndRoutesSearcher.dispose();
  }
}

handleSuccess(HitsPage page) async*{
  debugPrint("Ici le use case, voici ce qu'on a : $page");

  yield Resource.success(page);
}

handleError(dynamic e) async*{
  yield Resource.error('An error occurred : $e');
}



// List<SearchHitEntity> sortSearchHits(List<SearchHitEntity> hits, String prompt) {
//   // Utilisez FuzzyWuzzy pour attribuer un score de correspondance à chaque entité.
//   debugPrint("On sort avec : $prompt");
//   hits.sort((a, b) {
//     final scoreA = ratio(a.toString(), prompt);
//     final scoreB = ratio(b.toString(), prompt);
//     return scoreB.compareTo(scoreA); // Tri décroissant par score.
//   });
//
//   return hits;
// }
