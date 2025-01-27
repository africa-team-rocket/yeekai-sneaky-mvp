
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../core/commons/utils/resource.dart';
import '../model/search_hit_entity.dart';

class GetSearchHistoryUseCase{

  // final _searchRepo = locator.get<GooglePlacesRepo>();

  List<SearchHitEntity> searchHits = [
    SearchHitStop(
      'stop',
      1,
      'Arrêt Dardanelles',
      14.6928,
      -17.4467,
    ),
    SearchHitStop(
      'stop',
      2,
      'Arrêt Colobane',
      14.6919,
      -17.4375,
    ),
    SearchHitPlace(
      'place',
      'Cité Assemblée',
      'Proche de l\'Assemblée Nationale',
      'place_id_1',
      'reference_1',
      'Cité Assemblée Nationale, Dakar',
    ),
    SearchHitPlace(
      'place',
      'Sicap Foire',
      'Près du Parc des Expositions',
      'place_id_2',
      'reference_2',
      'Sicap Foire, Dakar',
    ),
    SearchHitRoute(
      'route',
      'route_id_1',
      'agency_id_1',
      'Ligne 47',
      'De Liberté 6 à HLM Grand Yoff',
    ),
  ];




  Stream<Resource<List<SearchHitEntity>>> execute() async*{

    yield Resource.loading();

    // Ici on récupère obligatoirement que par liste de 10, tu passeras ça depuis le bloc après
    // List<SearchHitEntity> responseList = await _searchRepo.getSearchHitCache(6);
    List<SearchHitEntity> responseList =  searchHits;

    yield Resource.success(responseList);

  }

}