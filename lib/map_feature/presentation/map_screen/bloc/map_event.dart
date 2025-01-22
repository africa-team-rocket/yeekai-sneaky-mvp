
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/model/map_entity.dart';
import '../../../domain/model/search_hit_entity.dart';
import '../../search_screen/bloc/search_state.dart';
import 'map_state.dart';

abstract class MapEvent{
  const MapEvent();
}

class SetSelectedMapEntity extends MapEvent{
  final MapEntity? newMapEntity;
  const SetSelectedMapEntity(this.newMapEntity);
}

class UpdateMarkersSet extends MapEvent{
  final Marker? newMarker;
  final Set<Marker>? newMarkerSubset;
  UpdateMarkersSet({required this.newMarker, required this.newMarkerSubset});
}

class GetGifts extends MapEvent{
  final bool? isConnectedToInternet;
  GetGifts({required this.isConnectedToInternet});
}

class UpdatePolylinesSet extends MapEvent{
  final Polyline? newPolyline;
  final Set<Polyline>? newPolylineSubset;
  UpdatePolylinesSet({required this.newPolyline, required this.newPolylineSubset});
}

class GetUserLocationUpdates extends MapEvent{

}




class GetBusesNearby extends MapEvent{
  final LatLng userPos;
  const GetBusesNearby(this.userPos);
}

class SetGoogleMapController extends MapEvent{
  final GoogleMapController mapController;
  const SetGoogleMapController(this.mapController);
}

// Search section :

class UpdatePrompt extends MapEvent{
  final String newPrompt;
  const UpdatePrompt({required this.newPrompt});
}

class UpdateSearchMode extends MapEvent{
  final bool newSearchMode;
  const UpdateSearchMode({required this.newSearchMode});
}

class UpdateSearchFilterMode extends MapEvent{
  final FilterValues newSearchFilterMode;
  const UpdateSearchFilterMode({required this.newSearchFilterMode});
}


class AddSearchHitToCache extends MapEvent{
  final SearchHitEntity searchHitEntity;
  const AddSearchHitToCache({required this.searchHitEntity});
}

class GetSearchHits extends MapEvent{

}

class GetSearchHistory extends MapEvent{

}

class ApplyAlgoliaState extends MapEvent{
  final SearchState Function(SearchState) stateUpdater;
  const ApplyAlgoliaState({required this.stateUpdater});
}