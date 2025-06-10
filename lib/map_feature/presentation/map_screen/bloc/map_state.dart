
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/model/bus_nearby.dart';
import '../../../domain/model/gift.dart';
import '../../../domain/model/hits_page.dart';
import '../../../domain/model/map_entity.dart';
import '../../../domain/model/search_hit_entity.dart';
import '../../../domain/model/user_position.dart';

class MapState {
  // Search section :
  final String userPrompt;
  final bool isSearchModeEnabled;
  final HitsPage? searchHitsPage;
  final List<SearchHitEntity> searchHistory;
  final FilterValues searchFilter;
  final SearchLoading searchLoading;

  final Set<Marker> markersSet;
  final Set<Polyline> polylinesSet;
  final UserPosition? userCurrentLocation;
  final MapEntity? selectedEntity;
  final MapEntity? cachedEntity;
  final List<BusNearby> busesNearby;
  final GoogleMapController? gMapController;

  // Gifts section
  final List<Gift> gifts;
  final bool giftLoading;

  const MapState({
    // Search section
    this.userPrompt = "",
    this.isSearchModeEnabled = false,
    this.searchHitsPage,
    this.searchFilter = FilterValues.all,
    this.searchLoading = const SearchLoading(),
    this.searchHistory = const [],

    this.gMapController,
    this.userCurrentLocation,
    this.selectedEntity,
    this.cachedEntity,
    this.busesNearby = const [],
    this.markersSet = const {},
    this.polylinesSet = const {},

    // Gifts section
    this.gifts = const [],
    this.giftLoading = true
  });

  MapState copyWith({
    // Search section :
    String? userPrompt,
    bool? isSearchModeEnabled,
    // Il faudra ajouter le cas où ça a été mal chargé pour qu'on puisse le constater dans la vue.
    HitsPage? searchHitsPage,
    List<SearchHitEntity>? searchHistory,
    SearchLoading? searchLoading,

    GoogleMapController? gMapController,
    UserPosition? userCurrentLocation,
    MapEntity? selectedEntity,
    MapEntity? cachedEntity,
    List<BusNearby>? busesNearby,
    Set<Marker>? markersSet,
    Set<Polyline>? polylinesSet,
    FilterValues? searchFilter,

    // Gifts section :
    List<Gift>? gifts,
    bool? giftLoading,

  }) {
    return MapState(
      // Search mode :
      userPrompt: userPrompt ?? this.userPrompt,
      isSearchModeEnabled: isSearchModeEnabled ?? this.isSearchModeEnabled,
      searchHitsPage: searchHitsPage ?? this.searchHitsPage,
      searchFilter: searchFilter ?? this.searchFilter,
      searchHistory: searchHistory ?? this.searchHistory,
      searchLoading: searchLoading ?? this.searchLoading,

      gMapController: gMapController ?? this.gMapController,
      userCurrentLocation: userCurrentLocation ?? this.userCurrentLocation,
      busesNearby: busesNearby ?? this.busesNearby,
      selectedEntity: selectedEntity ?? this.selectedEntity,
      cachedEntity: cachedEntity ?? this.cachedEntity,
      markersSet: markersSet ?? this.markersSet,
      polylinesSet: polylinesSet ?? this.polylinesSet,

      // Gifts section :
      gifts: gifts ?? this.gifts,
      giftLoading : giftLoading ?? this.giftLoading
    );
  }

  /// Cette méthode permet de reset le state aux valeurs d'origine. Pour l'instant
  /// Elle ne prend en compte que selectedPlace.
  MapState resetState({
    bool resetSelectedEntity = false,
    bool resetCachedEntity = false,
    bool resetMarkersSet = false,
    bool resetPolylinesSet = false,
  }) {
    return MapState(
      userCurrentLocation: userCurrentLocation,
      busesNearby: busesNearby,
      selectedEntity: resetSelectedEntity ? null : this.selectedEntity,
      cachedEntity: resetCachedEntity ? null : this.cachedEntity,
      markersSet: resetMarkersSet ? {} : markersSet,
      polylinesSet: resetPolylinesSet ? {} : polylinesSet,
      searchHitsPage: searchHitsPage,
      gifts: gifts,
      searchFilter: searchFilter
    );
  }

  List<SearchHitEntity> get filteredSearchHits {
    // Filtrer la liste en fonction de la valeur de searchFilter
    if(searchHitsPage == null) {
      return List.empty();
    }

    return searchHitsPage!.items.where((item) {
      if (searchFilter == FilterValues.stop) {
        return item.entityType == 'stop';
      } else if (searchFilter == FilterValues.places) {
        return item.entityType == 'place';
      } else if (searchFilter == FilterValues.routes) {
        return item.entityType == 'route';
      }
      // Pour FilterValues.all, ne pas filtrer, retourner tous les éléments.
      return true;
    }).toList();
  }



}



enum FilterValues { stop, routes, places, all }

class SearchLoading {
  final bool isSuggestionsLoading;
  final bool isHistoryLoading;

  const SearchLoading({
    this.isSuggestionsLoading = false,
    this.isHistoryLoading = false,
  });

  SearchLoading copyWith({
    bool? isSuggestionsLoading,
    bool? isHistoryLoading,
  }) {
    return SearchLoading(
      isSuggestionsLoading: isSuggestionsLoading ?? this.isSuggestionsLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    );
  }
}
