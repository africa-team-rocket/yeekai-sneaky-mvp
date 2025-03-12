import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:yeebus_filthy_mvp/map_feature/domain/model/gift.dart';
import 'package:yeebus_filthy_mvp/map_feature/domain/use_cases/get_all_gifts_from_remote.dart';
import 'package:yeebus_filthy_mvp/map_feature/domain/use_cases/sync_gifts_use_case.dart';

import '../../../../core/commons/theme/app_colors.dart';
import '../../../../core/commons/utils/app_constants.dart';
import '../../../../core/commons/utils/firebase_engine.dart';
import '../../../../core/commons/utils/resource.dart';
import '../../../domain/model/bus.dart';
import '../../../domain/model/main_place.dart';
import '../../../domain/model/place.dart';
import '../../../domain/model/stop.dart';
import '../../../domain/model/user_position.dart';
import '../../../domain/use_cases/add_search_hit_to_cache.dart';
import '../../../domain/use_cases/algolia_search_use_case.dart';
import '../../../domain/use_cases/get_all_gifts_from_cache.dart';
import '../../../domain/use_cases/get_buses_nearby_use_case.dart';
import '../../../domain/use_cases/get_search_history_from_cache.dart';
import '../../../domain/use_cases/update_location_use_case.dart';
import '../map_screen.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState>{

  // static MapBloc? _instance;
  // static MapBloc get instance {
  //   if (_instance == null) _instance = MapBloc();
  //   return _instance!;
  // }

  final _updateLocationUseCase = UpdateUserLocationUseCase();
  final _getBusesNearbyUseCase = GetBusesNearbyUseCase();
  final _addSearchHitToCacheUseCase = AddSearchHitToCacheUseCase();
  final _getSearchHistoryFromCacheUseCase = GetSearchHistoryUseCase();
  // Peut-être que les use case n'ont pas nécessairement besoin d'être des singletons
  final _algoliaSearchUseCase = MultimodalSearchUseCase();
  final _getAllGiftsFromRemoteUseCase = GetAllGiftsFromRemoteUseCase();
  final _getAllGiftsFromCacheUseCase = GetAllGiftsFromCacheUseCase();
  final _syncGifts = SyncGiftsUseCase();
  // final _algoliaSearchUseCase = locator.get<MultimodalSearchUseCase>();
  // Les mécanismes de fermeture et d'ouverture ne sont pas encore au point pour le update user position
  // tu dois aussi le mettre en place plus proprement pour get buses nearby
  @override
  Future<void> close() {
   _algoliaSearchUseCase.closeStream();
   // _getBusesNearbyUseCase.closeStream();
   _updateLocationUseCase.closeStream();
    return super.close();
  }

  MapBloc():super(const MapState()){
    // Search section :
    on<UpdatePrompt>(_updatePrompt);
    on<AddSearchHitToCache>(_addSearchHitToCache);
    on<UpdateSearchMode>(_updateSearchMode);
    on<UpdateSearchFilterMode>(_updateSearchFilterMode);
    on<GetSearchHits>(_getSearchHits);
    on<GetSearchHistory>(_getSearchHistory);
    on<ApplyAlgoliaState>(_applyAlgoliaState);

    on<GetUserLocationUpdates>(_getLocation);
    on<GetBusesNearby>(_getBusesNearby);
    on<SetSelectedMapEntity>(_setSelectedMapEntity);
    on<UpdateMarkersSet>(_updateMarkersSet);
    on<UpdatePolylinesSet>(_updatePolylinesSet);
    on<SetGoogleMapController>(_setGoogleMapController);


    on<GetGifts>(_getGifts);



    add(GetGifts(isConnectedToInternet: true));
    // Search section :
    // Cet évènement est ce qui ouvre le stream ou en tout cas qui l'écoute, j'ai un doute parce que
    // si on le met là, le stream sera constamment ouvert même quand on ne recherche pas.
    // Et puis, pourquoi ne pas le récupérer directement dans updatePrompt ? Il faudra y réfléchir
    add(GetSearchHits());

    add(GetUserLocationUpdates());
    // add(const GetBusesNearby(LatLng(0,0)));
    // add(const SetSelectedMapEntity(null));
    add(UpdateMarkersSet(newMarker: Marker(
        markerId: const MarkerId("place_1"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700029517700326, -17.451019219831917),
        onTap: () {
          add(const SetSelectedMapEntity(Place(
                entityName: 'Ecole supérieure multinationale des télécommunications (ESMT)',
                placeName:
                    'Ecole supérieure multinationale des télécommunications (ESMT)',
                entityPosition: LatLng(14.700029517700326, -17.451019219831917),
              )));
        }
    ), newMarkerSubset: null));
  }

  // Gifts section :

  void _getGifts(GetGifts event, Emitter<MapState> emit) async {
    // emit(state.copyWith(isLoading: true)); // Indique le début du chargement.

    await for (final resource in _syncGifts.execute()) {
      switch (resource.type) {
        case ResourceType.success:
          debugPrint("Cadeaux récupérés avec succès : ${resource.data}");

          // Met à jour le state avec la liste des cadeaux.
          emit(state.copyWith(
            gifts: resource.data,
            giftLoading: false, // Fin du chargement.
          ));
          debugPrint("Voici les cadeaux du state :" + state.gifts.toString());
          break;

        case ResourceType.error:
          debugPrint("Erreur lors de la récupération des cadeaux : ${resource.message}");

          // Met à jour le state en cas d'erreur.
          // Gérer l'affichage d'un snackbar en cas d'erreur ici
          emit(state.copyWith(
            // errorMessage: resource.message,
            giftLoading: false,
          ));
          break;

        case ResourceType.loading:
          debugPrint("Chargement des cadeaux en cours...");
          emit(state.copyWith(
            giftLoading: false,
          ));
          break;
      }
    }
  }


  // Search section :
  void _updatePrompt(UpdatePrompt event, Emitter<MapState> emit) async {

    // NewPrompt sert-il à quelque chose ?
    emit(state.copyWith(userPrompt: event.newPrompt));

    if(event.newPrompt != "" && event.newPrompt.isNotEmpty) {
      _algoliaSearchUseCase.applySearchState(
              (state) =>
              state.copyWith(
                // query: event.newPrompt,
                // page: 0,
              ),
          event.newPrompt
      );
    }

    debugPrint("On teste ce qui se passe sur l'updatePrompt :");

  }

  void _addSearchHitToCache(AddSearchHitToCache event, Emitter<MapState> emit) async {



    await for (final resource in _addSearchHitToCacheUseCase.execute(event.searchHitEntity)){
      switch (resource.type) {
        case ResourceType.success:
          debugPrint("Gg tu as ajouté à l'historique !");
          // emit(state.copyWith(sea))
          Future.delayed(Duration(milliseconds: 500),(){
            add(GetSearchHistory());
          });

          break;
        case ResourceType.error:
        // Tu devras gérer ce cas plus tard.
          debugPrint("Oops, erreur lors de la récupération des hits :/ ${resource.message} ");

          break;
        case ResourceType.loading:

          debugPrint("Oops, loading askip");
          break;
      }
    }

  }



  void _applyAlgoliaState(ApplyAlgoliaState event, Emitter<MapState> emit) async {

    _algoliaSearchUseCase.applySearchState(
        event.stateUpdater,
      "wakagoro"
    );

    debugPrint("On teste ce qui se passe sur l'apply algolia state");

  }

  void _updateSearchMode(UpdateSearchMode event, Emitter<MapState> emit) async {
    // if(event.newSearchMode!){
    //   emit(state.copyWith(userPrompt: ""));
    // }
    emit(state.copyWith(isSearchModeEnabled: event.newSearchMode));
    // Quand on active le search mode, on récupère la liste initiale.
    if(event.newSearchMode) {
      add(GetSearchHistory());
    }
  }

  void _updateSearchFilterMode(UpdateSearchFilterMode event, Emitter<MapState> emit) async {
    // if(event.newSearchMode!){
    //   emit(state.copyWith(userPrompt: ""));
    // }
    emit(state.copyWith(searchFilter: event.newSearchFilterMode));
  }


  // Pour l'instant j'écouterai le stream comme ça, tu peux me noter tes inquétudes
  // pour plus part :
  // - Il s'ouvre dès qu'on charge la page, il faudra pouvoir la fermer si besoin
  void _getSearchHits(GetSearchHits event, Emitter<MapState> emit) async {
    await for (final resource in _algoliaSearchUseCase.execute()){
      switch (resource.type) {
        case ResourceType.success:
            debugPrint("Gg on a récupéré les hits :");
            debugPrint(resource.data.toString());
            emit(state.copyWith(searchHitsPage: resource.data,searchLoading: state.searchLoading.copyWith(isSuggestionsLoading: false)));

            // emit(state.copyWith(sea))

          break;
        case ResourceType.error:
          // Tu devras gérer ce cas plus tard.
          debugPrint("Oops, erreur lors de la récupération des hits :/ ${resource.message} ");
          emit(state.copyWith(searchLoading: state.searchLoading.copyWith(isSuggestionsLoading: false)));


          break;
        case ResourceType.loading:
          debugPrint("Oops, loading askip");
          emit(state.copyWith(searchLoading: state.searchLoading.copyWith(isSuggestionsLoading: true)));

          break;
      }
    }
  }

  void _getSearchHistory(GetSearchHistory event, Emitter<MapState> emit) async {
    await for (final resource in _getSearchHistoryFromCacheUseCase.execute()){
      switch (resource.type) {
        case ResourceType.success:
          debugPrint("Gg on a récupéré la history :");
          debugPrint(resource.data.toString());
          emit(state.copyWith(searchHistory: resource.data, searchLoading: state.searchLoading.copyWith(isHistoryLoading: false)));
          // emit(state.copyWith(sea))

          break;
        case ResourceType.error:
        // Tu devras gérer ce cas plus tard.
          emit(state.copyWith(searchLoading: state.searchLoading.copyWith(isHistoryLoading: false)));

          debugPrint("Oops, erreur lors de la récupération de la history :/ ${resource.message} ");

          break;
        case ResourceType.loading:
          debugPrint("Oops, loading askip pour l'history ;)");
          emit(state.copyWith(searchLoading: state.searchLoading.copyWith(isHistoryLoading: true)));

          break;
      }
    }
  }

  // ----
  void _getBusesNearby(GetBusesNearby event, Emitter<MapState> emit) async {
    await for (final resource in _getBusesNearbyUseCase.execute(event.userPos, this)) {
      switch (resource.type) {
        case ResourceType.success:
          var busesNearby = resource.data;
          if(busesNearby != null){
            emit(state.copyWith(busesNearby: busesNearby));
            add(UpdateMarkersSet(newMarker: null, newMarkerSubset: busesNearby.map((e) => e.busMarker).toSet()));
          }

          break;
        case ResourceType.error:
          break;
        case ResourceType.loading:
          break;
      }
    }
  }

  void _getLocation(GetUserLocationUpdates event, Emitter<MapState> emit) async {
    await for (final resource in _updateLocationUseCase.execute()) {
      switch (resource.type) {
        case ResourceType.success:
          var posInfo = resource.data;
          if(posInfo != null){
            var newUserPos = UserPosition(
            // + 0.0015
                userPos: LatLng(posInfo.position.latitude, posInfo.position.longitude),
                userBearing: posInfo.bearing,
                userMarker: Marker(
                  flat: true,
                  markerId: AppConstants.userPosId,

                  position: LatLng(posInfo.position.latitude, posInfo.position.longitude),
                  icon: await BitmapDescriptor.fromAssetImage(
                      const ImageConfiguration(),
                      Platform.isIOS ? 'assets/icons/user_position_small.png' :'assets/icons/user_map_position.png'
                  ),
                  anchor: const Offset(0.5,0.4),
                  rotation: posInfo.bearing,
                ),
                accuracy: posInfo.position.accuracy);
            emit(state.copyWith(userCurrentLocation: newUserPos));
            add(UpdateMarkersSet(newMarker: newUserPos.userMarker,newMarkerSubset: null));


          }
          break;
        case ResourceType.error:
          break;
        case ResourceType.loading:
          break;
      }
    }

  }

  void _setSelectedMapEntity(SetSelectedMapEntity event, Emitter<MapState> emit) async {

    debugPrint("New map entity : ${event.newMapEntity}, is it null ? ${event.newMapEntity == null}");
    // Future.delayed(const Duration(milliseconds: 250), (){
      add(const UpdateSearchMode(newSearchMode: false));
    // });

    if(event.newMapEntity != null){


        // emit(state.copyWith(cachedPlace: state.selectedEntity));
        Marker newMarker;
        if(event.newMapEntity is Place) {

          newMarker = Marker(
              markerId: const MarkerId("place_1"),
              anchor: const Offset(0.5, 0.5),
              position: event.newMapEntity!.entityPosition,
              onTap: () {
                 add(SetSelectedMapEntity(event.newMapEntity));
              }
          );

          emit(state.copyWith(selectedEntity: event.newMapEntity));
          add(UpdateMarkersSet(newMarker: newMarker, newMarkerSubset: null));

        }else if(event.newMapEntity is Stop){

          newMarker = Marker(
              markerId: const MarkerId("stop_1"),
              anchor: const Offset(0.5, 0.5),
              position: event.newMapEntity!.entityPosition,
              icon: await BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                  Platform.isIOS ? "assets/icons/bus_stop_small.png" : "assets/icons/bus_stop.png",
              ),
              onTap: () {
                add(SetSelectedMapEntity(event.newMapEntity));
              }
          );

          emit(state.copyWith(selectedEntity: event.newMapEntity));
          add(UpdateMarkersSet(newMarker: newMarker, newMarkerSubset: null));
        }else if(event.newMapEntity is Bus){

          Polyline newPolyline = Polyline(
              polylineId: PolylineId("selected_line_polyline"),
              points: (event.newMapEntity as Bus).line.onwardShape,
              color: AppColors.primaryVar0,
              width: 5
          );

          newMarker = Marker(
              markerId: const MarkerId("bus_1"),
              anchor: const Offset(0.5, 0.5),
              position: event.newMapEntity!.entityPosition,
              icon: await BusMarkerIcon(
                lineNumber: (event.newMapEntity! as Bus).line.lineNumber,
                state: (event.newMapEntity! as Bus).state,
              ).toBitmapDescriptor(logicalSize: const Size(72, 72), imageSize: const Size(72, 72)),
              onTap: () {
                add(SetSelectedMapEntity(event.newMapEntity));
              }
          );

          emit(state.copyWith(selectedEntity: event.newMapEntity));
          add(UpdateMarkersSet(newMarker: newMarker, newMarkerSubset: null));
          add(UpdatePolylinesSet(newPolyline: newPolyline, newPolylineSubset: null));

          // Tu viendras ajouter la line après.
        }else if(event.newMapEntity is MainPlace || event.newMapEntity is GiftMapEntity){


          FirebaseEngine.logCustomEvent("selected_map_entity", {"entity_id": event.newMapEntity!.entityName});

          debugPrint("added a MainPlace or Gift from bloc");
          emit(state.copyWith(selectedEntity: event.newMapEntity));


        }


    }else{
      // debugPrint("new cached place is ${state.cachedEntity}");

      emit(state.resetState(resetSelectedEntity: true));
    }

    // Si dans le futur tu prévois de retirer le marqueur après la recherche, il faudra y remédier.

  }

  void _setGoogleMapController(SetGoogleMapController event, Emitter<MapState> emit) async {

    // Attention, ceci n'est pas une bonne pratique de " separation of concerns. "
      emit(state.copyWith(gMapController: event.mapController));
      // debugPrint("Added mapController here ${state.gMapController}");

  }

  void _updatePolylinesSet(UpdatePolylinesSet event, Emitter<MapState> emit) async {
    final List<Polyline> newSet = List.from(state.polylinesSet); // Create a copy of the current list

    // Check if an old version of the marker is present
    if (event.newPolyline != null) {
      final oldPolylineIndex = newSet.indexWhere((polyline) => polyline.polylineId == event.newPolyline!.polylineId);
      if (oldPolylineIndex != -1) {
        newSet.removeAt(oldPolylineIndex);
      }
      newSet.add(event.newPolyline!);
    }

    // Add new subset markers
    if (event.newPolylineSubset != null) {

      for(var newPolyline in event.newPolylineSubset!){
        final oldPolylineIndex = newSet.indexWhere((polyline) => polyline.polylineId == newPolyline.polylineId);
        if (oldPolylineIndex != -1) {
          newSet.removeAt(oldPolylineIndex);
        }
        newSet.add(newPolyline);
      }
      // newSet.addAll(event.newMarkerSubset!);
    }

    emit(state.copyWith(polylinesSet: newSet.toSet()));
  }


  void _updateMarkersSet(UpdateMarkersSet event, Emitter<MapState> emit) async {
    final List<Marker> newSet = List.from(state.markersSet); // Create a copy of the current list

    // Check if an old version of the marker is present
    if (event.newMarker != null) {
      final oldMarkerIndex = newSet.indexWhere((marker) => marker.markerId == event.newMarker!.markerId);
      if (oldMarkerIndex != -1) {
        newSet.removeAt(oldMarkerIndex);
      }
      newSet.add(event.newMarker!);
    }

    // Add new subset markers
    if (event.newMarkerSubset != null) {

     for(var newMarker in event.newMarkerSubset!){
       final oldMarkerIndex = newSet.indexWhere((marker) => marker.markerId == newMarker.markerId);
       if (oldMarkerIndex != -1) {
         newSet.removeAt(oldMarkerIndex);
       }
       newSet.add(newMarker);
     }
      // newSet.addAll(event.newMarkerSubset!);
    }

    emit(state.copyWith(markersSet: newSet.toSet()));
  }


  // void _updateMarkersSet(UpdateMarkersSet event, Emitter<MapState> emit) async {
  //
  //   final List<Marker> newSet = state.markersSet.toList();
  //
  //   if(event.newMarker != null)
  //     newSet.add(event.newMarker!);
  //   if(event.newMarkerSubset != null)
  //     newSet.addAll(event.newMarkerSubset!.toList());
  //
  //   emit(state.copyWith(markersSet: newSet.toSet()));
  //
  // }

}
