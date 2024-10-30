import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main_feature/data/local/dao/conversation_dao.dart';
import '../../main_feature/data/remote/api/yeebot_api.dart';
import '../../main_feature/data/remote/api/yeebot_api_impl.dart';
import '../../main_feature/data/repository/yeebot_repo_impl.dart';
import '../../main_feature/domain/repository/yeebot_repo.dart';
import '../data/database_instance.dart';

final locator = GetIt.instance;

void setupBlocInheritanceDependencies() {}

void setupAppDependencies() async {
  // ###################### MAIN FEATURE :

  // SHARED PREFERENCES :

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // SHPREFS :
  locator.registerLazySingleton<SharedPreferences>(() => prefs);


  // LOCAL AND REMOTE :

  // DATABASE :
  locator.registerLazySingleton<AppLocalDatabase>(() => AppLocalDatabase());

  // DAOS :
  locator.registerLazySingleton<ConversationDao>(() => ConversationDaoImpl());
  // locator.registerLazySingleton<CurrentDestsDao>(() => CurrentDestsDaoImpl());

  // APIS :
  locator.registerLazySingleton<YeebotApi>(() => YeebotApiImpl());
  // REPOS :
  locator.registerLazySingleton<YeebotRepo>(() => YeebotRepoImpl());

  // ###################### FEATURE MAIN :

  // APIS :
  // locator.registerLazySingleton<YeebusGraphQLApi>(() => YeebusGraphQLApi());
  // locator.registerLazySingleton<GooglePlacesApi>(() => GooglePlacesApiImpl());
  //
  // // REPOSITORIES :
  // locator.registerLazySingleton<GooglePlacesRepo>(() => GooglePlacesRepoImpl());
  // locator.registerLazySingleton<CurrentDestsRepo>(() => CurrentDestsRepoImpl());

  // USE CASES :
  //    locator.registerLazySingleton<UpdateUserLocationUseCase>(() => UpdateUserLocationUseCase());
  //    locator.registerLazySingleton<GetBusesNearbyUseCase>(() => GetBusesNearbyUseCase());
  //    locator.registerLazySingleton<MultimodalSearchUseCase>(() => MultimodalSearchUseCase());

  // GLOBAL BLOCS :
  // locator.registerLazySingleton<MapBloc>(() => MapBloc());

  // locator.registerLazySingleton<MoveDynamicMarkerUseCase>(() => MoveDynamicMarkerUseCase());
}
