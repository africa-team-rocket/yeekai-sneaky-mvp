import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:animated_marker/animated_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:yeebus_filthy_mvp/main_feature/presentation/profile_screen/profile_screen.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/map_screen/widgets/details_screen.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/map_screen/widgets/gifts_about_screen.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import '../../../core/commons/utils/firebase_engine.dart';
import '../../../core/commons/utils/raw_explandable_bottom_sheet.dart';
import '../../../core/presentation/app_global_widgets.dart';
import '../../../core/presentation/root_app_bar/root_app_bar.dart';
import '../../domain/model/bus.dart';
import '../../domain/model/gift.dart';
import '../../domain/model/line.dart';
import '../../domain/model/main_place.dart';
import '../../domain/model/map_entity.dart';
import '../../domain/model/place.dart';
import '../../domain/model/product.dart';
import '../../domain/model/search_hit_entity.dart';
import '../../domain/model/stop.dart';
import '../3d_view_screen/3d_view_screen.dart';
import '../search_screen/search_screen.dart';
import 'bloc/map_bloc.dart';
import 'bloc/map_event.dart';
import 'bloc/map_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    this.foundPlace,
    this.trafficMode,
    this.searchMode,
  }) : super(key: key);

  final Place? foundPlace;
  final bool? trafficMode;
  final bool? searchMode;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final GlobalKey<MapWState> mapKey = GlobalKey();
  // Je le déclare ici parce que c'est déjà stateful mais on verra dans le futur
  // ça fonctionne mais bon on pourra toujours y revenir, perso ça me va.

  final PagingController<int, SearchHitEntity> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController textEditingController = TextEditingController();
  late MapBloc mapBloc;


  onPop() {
    if (mapBloc.state.selectedEntity != null) {
      FirebaseEngine.pagesTracked("pop_from_selected_map_entity");
      mapBloc.add(SetSelectedMapEntity(null));
      return;
    }
    FirebaseEngine.pagesTracked("pop_from_map_screen");


    Navigator.of(context).maybePop();
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.other];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status : $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });

    if(_connectionStatus.first != ConnectivityResult.none && _connectionStatus.first != ConnectivityResult.other){
      mapBloc.add(GetGifts(isConnectedToInternet: true));
    }
    // ignore: avoid_print
    debugPrint('Connectivity changed: $_connectionStatus');
  }


  @override
  void initState() {
    // J'essaye d'update à partir d'ici mais je ne suis pas sur de si c'est convenable
    // on verra.

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);


    mapBloc = MapBloc();
    // _pagingController.addPageRequestListener(
    //         (pageKey) => mapBloc.add(ApplyAlgoliaState(stateUpdater: (state) => state.copyWith(
    //           page: pageKey,
    //         )))
    // );
    textEditingController.addListener(
      () {
        mapBloc.add(UpdatePrompt(newPrompt: textEditingController.text));
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // mapBloc.state.gMapController?.dispose();

    _connectivitySubscription.cancel();

    textEditingController.dispose();
    _pagingController.dispose();
    mapBloc.close();
    super.dispose();
  }

  int floorLevel = 0;
  MainPlace? detailsPage = null;
  bool showGiftsPage = false;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.searchMode != null && mapBloc.state.isSearchModeEnabled) {
          // Peut-être qu'autre chose qu'un push aurait été plus adapté ?
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.fade,
          //         duration: const Duration(milliseconds: 200),
          //         child: HomeScreen(rootContext: context,)));
          //
          // return false;
          debugPrint("Popped here !");

          return true;
        }

        if (widget.searchMode == null && mapBloc.state.isSearchModeEnabled) {
          mapBloc.add(const UpdateSearchMode(newSearchMode: false));

          return false;
        }

        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: BlocProvider(
          create: (_) {
            if (widget.searchMode == true) {
              mapBloc.add(const UpdateSearchMode(newSearchMode: true));
            }
            // mapBloc.add(const SetSelectedMapEntity(Place(
            //   placeName:
            //       'Ecole supérieure multinationale des télécommunications (ESMT)',
            //   entityPosition: LatLng(14.700029517700326, -17.451019219831917),
            // )));

            // mapBloc.add(const SetSelectedMapEntity(Stop(
            //     entityName: 'Arrêt Dardanelles',
            //     stopName: 'Arrêt Dardanelles',
            //     entityPosition: LatLng(14.695223067123997, -17.44946546833327))));

            return mapBloc;
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  top: false,
                  child: ExpandableBottomSheet(
                      key: key,
                      initialDraggableState: true,
                      isLazyModeEnabled: true,
                      onIsExtendedCallback: () => {
                            if (mapBloc.state.selectedEntity == null &&
                                mapBloc.state.isSearchModeEnabled == false)
                              {
                               // mapBloc.add(
                               //     const UpdateSearchMode(newSearchMode: true))
                              }
                          },
                      onIsContractedCallback: () => {
                            // mapBloc.state.selectedEntity == null
                            if (mapBloc.state.isSearchModeEnabled == true)
                              {
                               // mapBloc.add(const UpdateSearchMode(
                                //    newSearchMode: false)),
                               // mapBloc.add(UpdatePrompt(newPrompt: ""))
                              }
                          },
                      animationDurationExtend:
                          const Duration(milliseconds: 150),
                      animationDurationContract:
                          const Duration(milliseconds: 250),
                      animationCurveExpand: Curves.easeInOut,
                      animationCurveContract: Curves.easeInOut,

                      // Il faudra prendre en compte ceci pour l'animation des floating button
                      persistentContentHeight: 0,
                      initialPos:
                      //widget.searchMode == true ? 1.0 : 0.06,
                      1.0,
                      initialMaxExpandableHeight: 0.06,
                      initialMinExpandableHeight: 0.06,
                      background: GMap(
                          key: mapKey,
                          floorLevel: floorLevel,
                          isTrafficModeEnabled: widget.trafficMode ?? false),

                      // persistentHeader: const PersistentHeaderContent(),

                      expandableContent: BottomSheetExpandableContent(
                        bsKey: key,
                        pagingController: _pagingController,
                        toggleDetailsPage: (newDetailsPage) {
                          setState(() {
                            detailsPage = newDetailsPage;
                          });
                        }, toggleGiftsPage: () {
                          setState(() {
                            showGiftsPage = !showGiftsPage;
                          });
                      },
                      ),
                      lowerLeftFloatingButtons: FloatingButtonsContainer(
                          isUpper: false,
                          floatingButton1: MapFloatingButton(
                            iconUrl: "assets/icons/back_left_icon_black.png",
                            isUpper: false,
                            onTap: () {
                              mapBloc.add(const SetSelectedMapEntity(null));
                            },
                          )),
                      lowerRightFloatingButtons: FloorFloatingButton(
                          updateFloorLevel: (level) {
                            setState(() {
                              floorLevel = level;
                            });

                            print("Yahallooo, new floor : " +
                                floorLevel.toString());
                          },
                          initialFloorLevel: floorLevel),
                      upperRightFloatingButtons: FloatingButtonsContainer(
                        isUpper: true,
                        floatingButton2: MapFloatingButton(
                          iconUrl: "assets/icons/3d_view.png",
                          isUpper: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("unavailable_map_level_mode", {});
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    duration: const Duration(milliseconds: 500),
                                    child: ThreeDViewScreen(title: 'Test',)));

                          },
                        ),
                      ),
                      upperLeftFloatingButtons: FloatingButtonsContainer(
                        floatingButton2: MapFloatingButton(
                          iconUrl: "assets/icons/more_fav_white.png",
                          isUpper: true,
                          backgroundColor: AppColors.primaryVar0,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("unavailable_map_more_mode", {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );
                          },
                        ),
                        floatingButton1: MapFloatingButton(
                          iconUrl: "assets/icons/map_settings_white.png",
                          backgroundColor: AppColors.primaryVar0,
                          isUpper: true,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("unavailable_map_settings_mode", {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );
                          },
                        ),
                        isUpper: true,
                        // isUpperButtonActive: mapBloc.state.selectedEntity == null || mapBloc.state.isSearchModeEnabled,
                        // bsKey: key,
                      ),
                      topBar: BlocBuilder<MapBloc, MapState>(
                          builder: (context, mapState) {
                        return BsTopBar(
                          isActive: mapBloc.state.isSearchModeEnabled,
                          rootContext: context,
                          textValue: mapBloc.state.userPrompt,
                          selectedEntityTitle:
                              mapBloc.state.selectedEntity is MainPlace
                                  ? (mapBloc.state.selectedEntity as MainPlace)
                                      .placeName
                                  : mapBloc.state.selectedEntity?.entityName,
                          onTap: () {
                            FirebaseEngine.logCustomEvent("unavailable_map_search_mode", {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              buildCustomSnackBar(
                                context,
                                "Fonctionnalité disponible prochainement 😉",
                                SnackBarType.info,
                                showCloseIcon: false,
                              ),
                            );
                            // mapBloc.add(const UpdateSearchMode(newSearchMode: true));
                          },
                          onCancelSearch: () {
                            // mapBloc.add(const UpdateSearchMode(newSearchMode: false));
                            if (mapBloc.state.selectedEntity != null) {
                              mapBloc.add(const SetSelectedMapEntity(null));
                            } else {
                              mapBloc.add(const UpdatePrompt(newPrompt: ""));
                            }
                            textEditingController.clear();
                          },
                          onSubmitValue: (String text) {
                            mapBloc.add(AddSearchHitToCache(
                                searchHitEntity:
                                    mapBloc.state.filteredSearchHits.first));
                            var searchHitEntity =
                                mapBloc.state.searchHitsPage?.items.first;
                            if (searchHitEntity != null) {
                              if (searchHitEntity.entityType == "place") {
                                context
                                    .read<MapBloc>()
                                    .add(const SetSelectedMapEntity(Place(
                                      entityName:
                                          'Ecole supérieure multinationale des télécommunications (ESMT)',
                                      placeName:
                                          'Ecole supérieure multinationale des télécommunications (ESMT)',
                                      entityPosition: LatLng(14.700029517700326,
                                          -17.451019219831917),
                                    )));
                              } else if (searchHitEntity.entityType == "stop") {
                                context.read<MapBloc>().add(
                                      const SetSelectedMapEntity(
                                        Stop(
                                            entityName: 'Arrêt Dardanelles',
                                            stopName: 'Arrêt Dardanelles',
                                            entityPosition: LatLng(
                                                14.695223067123997,
                                                -17.44946546833327)),
                                      ),
                                    );
                              } else {
                                context.read<MapBloc>().add(
                                      const SetSelectedMapEntity(Bus(
                                          entityName:
                                              "Ligne 001 - Dakar Dem Dikk",
                                          state: BusState.UNKNOWN,
                                          capacity: 45,
                                          line: Line(
                                            arrival: 'LECLERC',
                                            departure: 'PARCELLES ASSAINIES',
                                            lineNumber: "001",
                                            description:
                                                'Cette ligne couvre la distance PARCELLES ASSAINIES-LECLERC',
                                            rating: 5,
                                            fareRange: '200-300',
                                            onwardShape: [
                                              LatLng(14.76033717791818,
                                                  -17.438687495664922),
                                              LatLng(14.763940762120395,
                                                  -17.441183406746163),
                                              LatLng(14.762826227208505,
                                                  -17.446516269735618),
                                              LatLng(14.75983177074642,
                                                  -17.44810450812752),
                                              LatLng(14.758248455408173,
                                                  -17.44776497933181),
                                              LatLng(14.756328841098107,
                                                  -17.44733680657224),
                                              LatLng(14.754299800845413,
                                                  -17.446884226197255),
                                              LatLng(14.750523231135967,
                                                  -17.446540219732984),
                                              LatLng(14.750049793921685,
                                                  -17.44799082092741),
                                              LatLng(14.7502938867721,
                                                  -17.44962752085666),
                                              LatLng(14.750618183071591,
                                                  -17.451216308405563),
                                              LatLng(14.751908674768655,
                                                  -17.45432092949277),
                                              LatLng(14.751323779488551,
                                                  -17.45614723355753),
                                              LatLng(14.750277612687961,
                                                  -17.45788510152128),
                                              LatLng(14.746394954969995,
                                                  -17.466588512861758),
                                              LatLng(14.744905821864554,
                                                  -17.46887636539269),
                                              LatLng(14.740497732127464,
                                                  -17.471505759915615),
                                              LatLng(14.735673214191454,
                                                  -17.473247964998105),
                                              LatLng(14.729655629460476,
                                                  -17.472863237737428),
                                              LatLng(14.72590576002534,
                                                  -17.471812771657483),
                                              LatLng(14.722566078908324,
                                                  -17.471226477452866),
                                              LatLng(14.719750523903995,
                                                  -17.47138906188038),
                                              LatLng(14.712284520605824,
                                                  -17.471902590631213),
                                              LatLng(14.709249652444962,
                                                  -17.471284811984475),
                                              LatLng(14.70503495422966,
                                                  -17.470293948214813),
                                              LatLng(14.700211986761264,
                                                  -17.468850235517714),
                                              LatLng(14.695885291241627,
                                                  -17.465384372683875),
                                              LatLng(14.69356583153468,
                                                  -17.46262004957258),
                                              LatLng(14.691573627552767,
                                                  -17.460203620061222),
                                              LatLng(14.689322117315578,
                                                  -17.457816311477483),
                                              LatLng(14.686677185172137,
                                                  -17.45551296891371),
                                              LatLng(14.683540150827751,
                                                  -17.452373935181324),
                                              LatLng(14.68151197255026,
                                                  -17.450238695218715),
                                              LatLng(14.679699854072759,
                                                  -17.4482861599848),
                                              LatLng(14.678560024739568,
                                                  -17.447046170035282),
                                              LatLng(14.675097340711405,
                                                  -17.443518609858753),
                                              LatLng(14.670725088433215,
                                                  -17.440326509804457),
                                              LatLng(14.669173822827892,
                                                  -17.43795000330283),
                                              LatLng(14.6693667259859,
                                                  -17.434781353950044),
                                              LatLng(14.669498559521607,
                                                  -17.432615841203198),
                                              LatLng(14.669904854641885,
                                                  -17.43170395936341),
                                              LatLng(14.6742458189469,
                                                  -17.43261082618835),
                                              LatLng(14.673962216827931,
                                                  -17.43167132154245),
                                              LatLng(14.671892986596275,
                                                  -17.42734131811217),
                                              LatLng(14.67212311504506,
                                                  -17.42733760332219),
                                            ],
                                            lineId: 1,
                                          ),
                                          isAccessible: false,
                                          entityPosition: LatLng(
                                              14.67212311504506,
                                              -17.42733760332219))),
                                      // Ajoutez d'autres éléments de la liste ici
                                    );
                              }
                            }
                            // mapBloc.add(const UpdateSearchMode(newSearchMode: true));
                          },
                          onBackPressed: onPop,
                          onTextChanged: (String value) {
                            mapBloc.add(UpdatePrompt(newPrompt: value));
                          },
                          bsKey: key,
                          textEditingController: textEditingController,
                        );
                      })),
                ),
              ),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: showGiftsPage
                      ? Container(
                    width: 1.sw,
                    height: 1.sh,
                    child: GiftsAboutScreen(
                        closeGiftsPage: () {
                          setState(() {
                            showGiftsPage = false;
                          });
                        }),
                  )
                      : null),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: detailsPage != null
                      ? Container(
                          width: 1.sw,
                          height: 1.sh,
                          child: DetailsScreen(
                              placeDetails: detailsPage!,
                              closeDetails: () {
                                setState(() {
                                  detailsPage = null;
                                });
                              }),
                        )
                      : null),
              AnimatedPositioned(
                bottom:
                // -80,
               _connectionStatus.first == ConnectivityResult.none ? -9 : -70,
                duration: Duration(milliseconds: 200),
                child: Material(child: Container(
                  width: 1.sw,
                    height: 0 + MediaQuery.of(context).padding.top,
                    color: Colors.redAccent,
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text("Vous n'êtes pas connecté à internet",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                      ],
                    )),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GMap extends StatefulWidget {
  const GMap(
      {Key? key, required this.isTrafficModeEnabled, required this.floorLevel})
      : super(key: key);

  final bool isTrafficModeEnabled;
  final int floorLevel;

  @override
  State<GMap> createState() => MapWState();
}

class MapWState extends State<GMap> {
  // final Completer<GoogleMapController> gMapCompleter = Completer<GoogleMapController>();
  late GoogleMapController googleMapController;
  late String mapStyle = "";
  EdgeInsets mapPadding = const EdgeInsets.only(bottom: 300);
  Set<Marker> _levelOneMarkers = {};
  Set<Marker> _levelOneMarkers2 = {};
  Set<Marker> _levelTwoMarkers = {};
  Set<Marker> _levelTwoMarkers2 = {};
  Set<Marker> _levelThreeMarkers = {};
  Set<Marker> _levelThreeMarkers2 = {};
  Set<Polygon> _baseBuildingPolygons = {
    // Escaliers 3 (à côté bureau surveillant) :

    Polygon(
      polygonId: const PolygonId('Escaliers 3'),
      points: [
        const LatLng(14.6996326, -17.4513697),
        const LatLng(14.699596, -17.451356),
        const LatLng(14.699608, -17.451318),
        const LatLng(14.6996441, -17.4513326),
        const LatLng(14.6996326, -17.4513697),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 4 ? (À coté salle HA4) :

    Polygon(
      polygonId: const PolygonId('Escaliers'),
      points: [
        const LatLng(14.6996381, -17.451198),
        const LatLng(14.6996451, -17.451178),
        const LatLng(14.6996871, -17.451191),
        const LatLng(14.6996801, -17.451212),
        const LatLng(14.6996381, -17.451198),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 5 (coin prière) :

    Polygon(
      polygonId: PolygonId('escaliers e5'),
      points: [
        LatLng(14.6995702, -17.4510165),
        LatLng(14.6995897, -17.4509553),
        LatLng(14.6996435, -17.4509756),
        LatLng(14.6996223, -17.4510356),
        LatLng(14.699608, -17.4510288),
        LatLng(14.6996025, -17.4510218),
        LatLng(14.6995891, -17.4510229),
        LatLng(14.6995702, -17.4510165),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 6 (HA1) :

    Polygon(
      polygonId: PolygonId('escaliers_E6'),
      points: [
        LatLng(14.699836, -17.451114),
        LatLng(14.6998177, -17.451108),
        LatLng(14.69984, -17.451043),
        LatLng(14.699858, -17.451049),
        LatLng(14.699836, -17.451114),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 8 (toilettes vers labo 2)
    Polygon(
      polygonId: PolygonId('escalier_8'),
      points: [
        LatLng(14.7000111, -17.4514888),
        LatLng(14.7000694, -17.4515105),
        LatLng(14.7000581, -17.4515425),
        LatLng(14.6999985, -17.4515228),
        LatLng(14.7000111, -17.4514888),
      ],
      fillColor: const Color(0XFFF2F3F7),
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
    ),

// Escaliers 7 (vers bureau Hervé)
    Polygon(
      polygonId: PolygonId('escaliers_7'),
      points: [
        LatLng(14.699721, -17.4515581),
        LatLng(14.6997293, -17.4515297),
        LatLng(14.699756, -17.4515405),
        LatLng(14.6997463, -17.4515668),
        LatLng(14.699721, -17.4515581),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

// Escaliers 8 (coin prière)
    Polygon(
      polygonId: PolygonId('escaliers_8'),
      zIndex: 0,
      points: [
        LatLng(14.700041, -17.4513004),
        LatLng(14.70002, -17.4513534),
        LatLng(14.7000028, -17.4513488),
        LatLng(14.699991, -17.4513571),
        LatLng(14.699977, -17.4513562),
        LatLng(14.6999639, -17.4513428),
        LatLng(14.6999634, -17.4513231),
        LatLng(14.6999751, -17.4513068),
        LatLng(14.6999927, -17.4513037),
        LatLng(14.700003, -17.4513164),
        LatLng(14.700012, -17.4512884),
        LatLng(14.700041, -17.4513004),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 9 : Polygone 18 (coin prière)
    Polygon(
      polygonId: PolygonId('esc_9_polygone_18'),
      zIndex: 0,
      points: [
        LatLng(14.6999949, -17.4513371),
        LatLng(14.6999897, -17.4513381),
        LatLng(14.6999862, -17.4513387),
        LatLng(14.6999829, -17.4513384),
        LatLng(14.69998, -17.4513374),
        LatLng(14.69998, -17.4513344),
        LatLng(14.6999794, -17.451331),
        LatLng(14.6999803, -17.451328),
        LatLng(14.6999826, -17.4513257),
        LatLng(14.6999842, -17.451323),
        LatLng(14.6999881, -17.451323),
        LatLng(14.6999927, -17.4513237),
        LatLng(14.6999972, -17.4513273),
        LatLng(14.6999949, -17.4513371),
      ],
      fillColor: const Color(0XFFDCDCDE).withOpacity(.6),
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
    ),

    // Main Building base :

    Polygon(
      polygonId: const PolygonId('MainBuilding1'),
      zIndex: -1,
      points: [
        const LatLng(14.6995949, -17.451557),
        const LatLng(14.6995097, -17.4515287),
        const LatLng(14.699502, -17.4515557),
        const LatLng(14.699409, -17.451522),
        const LatLng(14.699425, -17.45147),
        const LatLng(14.699443, -17.451415),
        const LatLng(14.699461, -17.451357),
        const LatLng(14.6994893, -17.451368),
        const LatLng(14.6995952, -17.4510516),
        const LatLng(14.6995914, -17.4510521),
        const LatLng(14.6995827, -17.4510449),
        const LatLng(14.6995812, -17.4510313),
        const LatLng(14.6995891, -17.4510229),
        const LatLng(14.6995702, -17.4510165),
        const LatLng(14.6995897, -17.4509553),
        const LatLng(14.699858, -17.451049),
        const LatLng(14.6998177, -17.4511704),
        const LatLng(14.699721, -17.4511399),
        const LatLng(14.6996387, -17.4513917),
        const LatLng(14.6999652, -17.4515071),
        const LatLng(14.6999937, -17.4514227),
        const LatLng(14.70002, -17.4513534),
        const LatLng(14.7000028, -17.4513488),
        const LatLng(14.699991, -17.4513571),
        const LatLng(14.699977, -17.4513562),
        const LatLng(14.6999639, -17.4513428),
        const LatLng(14.6999634, -17.4513231),
        const LatLng(14.6999751, -17.4513068),
        const LatLng(14.6999927, -17.4513037),
        const LatLng(14.700003, -17.4513164),
        const LatLng(14.700012, -17.4512884),
        const LatLng(14.699946, -17.4512642),
        const LatLng(14.6999528, -17.4512445),
        const LatLng(14.6999668, -17.4511978),
        const LatLng(14.7002214, -17.4512908),
        const LatLng(14.7001824, -17.451408),
        const LatLng(14.7001208, -17.4513892),
        const LatLng(14.7001025, -17.4514488),
        const LatLng(14.7000935, -17.4514455),
        const LatLng(14.7000155, -17.4516582),
        const LatLng(14.6996095, -17.4515191),
        const LatLng(14.6995949, -17.451557),
      ],
      strokeColor: const Color(0XFFD5D5D7),
      strokeWidth: 1,
      fillColor: const Color(0XFFF8F9FB),
    ),

    // Main Building 2 : (bat E)

    // Version Bat E only
    // Polygon(
    //   polygonId: PolygonId('Main building 2 (bat E)'),
    //   points: [
    //     LatLng(14.7001549, -17.4512144),
    //     LatLng(14.7001931, -17.4510934),
    //     LatLng(14.700308, -17.4511384),
    //     LatLng(14.7004012, -17.450841),
    //     LatLng(14.7001765, -17.4507615),
    //     LatLng(14.7001519, -17.4508304),
    //     LatLng(14.7000509, -17.4507924),
    //     LatLng(14.7000889, -17.4506834),
    //     LatLng(14.7001816, -17.4507187),
    //     LatLng(14.7002039, -17.4506514),
    //     LatLng(14.7004085, -17.4507223),
    //     LatLng(14.7004022, -17.450739),
    //     LatLng(14.7004292, -17.450749),
    //     LatLng(14.7004342, -17.4507326),
    //     LatLng(14.7005299, -17.4507654),
    //     LatLng(14.7003569, -17.4512894),
    //     LatLng(14.7001549, -17.4512144),
    //   ],
    //   strokeColor: const Color(0xFFD5D5D7),
    //   strokeWidth: 1,
    //   fillColor: const Color(0xFFF8F9FB),
    // ),

    // Version administration :
    Polygon(
      polygonId: PolygonId('Main building 2 (bat E)'),
      points: [
        LatLng(14.7001549, -17.4512144),
        LatLng(14.7001931, -17.4510934),
        LatLng(14.700308, -17.4511384),
        LatLng(14.7004012, -17.450841),
        LatLng(14.7001765, -17.4507615),
        LatLng(14.7001545, -17.4508311),
        LatLng(14.700171, -17.450837),
        LatLng(14.7000582, -17.4511724),
        LatLng(14.6999225, -17.4511184),
        LatLng(14.7000356, -17.450786),
        LatLng(14.7000509, -17.4507924),
        LatLng(14.7000889, -17.4506834),
        LatLng(14.7001816, -17.4507187),
        LatLng(14.7002039, -17.4506514),
        LatLng(14.7004085, -17.4507223),
        LatLng(14.7004022, -17.450739),
        LatLng(14.7004292, -17.450749),
        LatLng(14.7004342, -17.4507326),
        LatLng(14.7005299, -17.4507654),
        LatLng(14.7003569, -17.4512894),
        LatLng(14.7001549, -17.4512144),
      ],
      fillColor: const Color(0xFFF8F9FB),
      strokeColor: const Color(0xFFD5D5D7),
      zIndex: -999999,
      strokeWidth: 1,
    ),

    // ESCALIERS BAT A :

    Polygon(
      polygonId: const PolygonId('Bureau Mr Lemrabott (Secrétaire Général)'),
      points: const [
        LatLng(14.70014, -17.450827),
        LatLng(14.700171, -17.450837),
        LatLng(14.7001511, -17.4508963),
        LatLng(14.70012, -17.450885),
        LatLng(14.70014, -17.450827),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      zIndex: -999999,

      strokeWidth: 2,
    ),

    Polygon(
      polygonId: const PolygonId('Escaliers 2'),
      points: const [
        LatLng(14.7001, -17.451048),
        LatLng(14.7000896, -17.4510773),
        LatLng(14.7000599, -17.451064),
        LatLng(14.700069, -17.451036),
        LatLng(14.7001, -17.451048),
      ],
      fillColor: const Color(0XFFF2F3F7),
      strokeColor: const Color(0XFFDCDCDE),
      zIndex: -999999,
      strokeWidth: 2,
    ),


    // Escaliers 1 BAT E :

    Polygon(
      polygonId: PolygonId("Escaliers 1 Bat E"),
      points: [
        LatLng(14.7003434, -17.4511322),
        LatLng(14.7004009, -17.4511545),
        LatLng(14.7003927, -17.4511801),
        LatLng(14.7003346, -17.4511578),
        LatLng(14.7003434, -17.4511322),
      ],
      strokeWidth: 2,
      strokeColor: const Color(0XFFDCDCDE),
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Escaliers 2 BAT E :

    Polygon(
      polygonId: PolygonId("Escaliers 2 Bat E"),
      points: [
        LatLng(14.7004992, -17.4508565),
        LatLng(14.7004917, -17.4508795),
        LatLng(14.7004325, -17.4508604),
        LatLng(14.7004397, -17.4508365),
        LatLng(14.7004992, -17.4508565),
      ],
      strokeWidth: 2,
      strokeColor: const Color(0XFFDCDCDE),
      fillColor: const Color(0XFFF2F3F7),
    ),

  };
  Set<Polygon> _firstFloorPolygons = {

    // MainBYellowZone1 :
    Polygon(
      zIndex: 2,
      polygonId: const PolygonId('MainBYellowZone1'),
      points: [
        const LatLng(14.699409, -17.451522),
        const LatLng(14.699425, -17.45147),
        const LatLng(14.699461, -17.451357),
        const LatLng(14.6994893, -17.451368),
        const LatLng(14.6995187, -17.45128),
        const LatLng(14.6995624, -17.4512971),
        const LatLng(14.6995656, -17.451289),
        const LatLng(14.6995775, -17.4512939),
        const LatLng(14.6995748, -17.4513037),
        const LatLng(14.6996023, -17.4513153),
        const LatLng(14.699608, -17.451318),
        const LatLng(14.699596, -17.451356),
        const LatLng(14.6996326, -17.4513697),
        const LatLng(14.6996118, -17.451443),
        const LatLng(14.6995617, -17.4514263),
        const LatLng(14.6995487, -17.4514669),
        const LatLng(14.6996042, -17.4514833),
        const LatLng(14.6996006, -17.4514943),
        const LatLng(14.699559, -17.4514814),
        const LatLng(14.699541, -17.4515383),
        const LatLng(14.6995097, -17.4515287),
        const LatLng(14.699502, -17.4515557),
        const LatLng(14.699409, -17.451522),
      ],
      strokeColor: const Color(0XFFE6E1CE),
      strokeWidth: 2,
      fillColor: const Color(0XFFFDF9EE),
    ),

    // SecondYellowArea :
    //
    // Polygon(
    //   polygonId: PolygonId('2ndYellowArea'),
    //   points: [
    //     LatLng(14.6996381, -17.451198),
    //     LatLng(14.6996121, -17.4511887),
    //     LatLng(14.6996164, -17.451172),
    //     LatLng(14.6995618, -17.451155),
    //     LatLng(14.6995956, -17.451066),
    //     LatLng(14.6995586, -17.4510532),
    //     LatLng(14.6995897, -17.4509553),
    //     LatLng(14.6997402, -17.451009),
    //     LatLng(14.6997085, -17.4511214),
    //     LatLng(14.6996645, -17.4511064),
    //     LatLng(14.6996451, -17.451178),
    //     LatLng(14.6996381, -17.451198),
    //   ],
    //   strokeColor: const Color(0XFFE6E1CE),
    //   strokeWidth: 2,
    //   fillColor: const Color(0XFFFDF9EE),
    // ),

    // Upstairs 1 : (cour vers couloir, mini marches)
    Polygon(
      zIndex: 3,
      polygonId: const PolygonId('Upstairs1'),
      points: [
        const LatLng(14.6996023, -17.451315),
        const LatLng(14.6995748, -17.4513037),
        const LatLng(14.6995821, -17.4512825),
        const LatLng(14.699609, -17.4512942),
        const LatLng(14.6996023, -17.451315),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    // Entree :
    Polygon(
      polygonId: const PolygonId('Entree'),
      zIndex: 3,
      points: [
        const LatLng(14.6994699, -17.4514194),
        const LatLng(14.6994469, -17.4514107),
        const LatLng(14.6994635, -17.4513617),
        const LatLng(14.6994858, -17.4513701),
        const LatLng(14.6994699, -17.4514194),
      ],
      strokeColor: const Color(0XFFE6E1CE),
      strokeWidth: 2,
      fillColor: const Color(0XFFFDF9EE),
    ),

    // Lot 1 :

    // Toilettes étudiant H/F :

    // Escaliers 2 (avec portière fermée)
    Polygon(
      polygonId: const PolygonId('Escaliers 2'),
      points: [
        const LatLng(14.6995617, -17.4514263),
        const LatLng(14.6996044, -17.45144),
        const LatLng(14.6995936, -17.4514806),
        const LatLng(14.6995487, -17.4514669),
        const LatLng(14.6995617, -17.4514263),
      ],
      strokeColor: const Color(0XFFDCDCDE),
      strokeWidth: 2,
      fillColor: const Color(0XFFF2F3F7),
    ),

    Polygon(
      polygonId: PolygonId('toilettes_etudiant'),
      zIndex: 3,

      points: [
        LatLng(14.6995553, -17.4514941),
        LatLng(14.6996121, -17.4515107),
        LatLng(14.6995943, -17.4515563),
        LatLng(14.699541, -17.4515383),
        LatLng(14.6995553, -17.4514941),
      ],
      fillColor: Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

    // Toilettes admin :

    Polygon(
      polygonId: PolygonId('toilettes_admin'),
      zIndex: 3,
      points: [
        LatLng(14.6995624, -17.4514707),
        LatLng(14.6995553, -17.4514941),
        LatLng(14.699541, -17.4515383),
        LatLng(14.6995097, -17.4515287),
        LatLng(14.6995326, -17.45146),
        LatLng(14.6995624, -17.4514707),
      ],
      fillColor: Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: Color.fromRGBO(152, 159, 228, 1.0), // Rouge pour la bordure
      strokeWidth: 2,
    ),

    // Bureau amicale :

    Polygon(
      polygonId: PolygonId('bureau_amicale'),
      zIndex: 3,
      points: [
        LatLng(14.699409, -17.451522),
        LatLng(14.6994227, -17.4514757),
        LatLng(14.699516, -17.451505),
        LatLng(14.699500, -17.451554),
        LatLng(14.699409, -17.451522),
      ],
      fillColor: Color.fromRGBO(253, 232, 232, 1.0), // Vert clair
      strokeColor: Color.fromRGBO(199, 129, 129, 1.0),
      strokeWidth: 2,
      // fillColor: Color.fromRGBO(232, 253, 232, 1.0), // Vert clair
      // strokeColor: Color.fromRGBO(129, 199, 132, 1.0),
      // strokeWidth: 2,
      // fillColor: Color.fromRGBO(188, 248, 248, 1.0), // Bleu clair
      // strokeColor: Color.fromRGBO(127, 175, 208, 1.0),
      // strokeWidth: 2,
    ),

    // Lot 2 : Reprographie & 3 bureaux :

    // Reprographie :

    Polygon(
      polygonId: PolygonId('reprographie'),
      zIndex: 3,
      points: [
        LatLng(14.6994735, -17.4514257),
        LatLng(14.6995342, -17.4514466),
        LatLng(14.6995167, -17.4515016),
        LatLng(14.6994553, -17.4514827),
        LatLng(14.6994735, -17.4514257),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Bureau Mme Barro :

    Polygon(
      polygonId: PolygonId('bureau_mme_barro'),
      zIndex: 3,
      points: [
        LatLng(14.6995617, -17.4514263),
        LatLng(14.699573, -17.451388),
        LatLng(14.6996216, -17.4514054),
        LatLng(14.6996099, -17.4514427),
        LatLng(14.6995617, -17.4514263),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Bureau Surveillants :

    Polygon(
      polygonId: PolygonId('bureau_surveillant'),
      zIndex: 3,
      points: [
        LatLng(14.699573, -17.451388),
        LatLng(14.6995844, -17.451353),
        LatLng(14.6996326, -17.4513697),
        LatLng(14.6996216, -17.4514054),
        LatLng(14.699573, -17.451388),
      ],
      fillColor: Color.fromRGBO(217, 217, 217, 1.0), // Gris pâle
      strokeColor: Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Bureau HB1 :

    Polygon(
      polygonId: PolygonId('bureau_hb1'),
      zIndex: 3,
      points: [
        LatLng(14.6995194, -17.451279),
        LatLng(14.6995771, -17.451298),
        LatLng(14.6995641, -17.4513391),
        LatLng(14.699507, -17.451319),
        LatLng(14.6995194, -17.451279),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Lot 4 ? :

    // Salle HA5
    Polygon(
      polygonId: const PolygonId('Salle HA5'),
      zIndex: 3,
      points: [
        const LatLng(14.6995194, -17.451279),
        const LatLng(14.6995435, -17.451207),
        const LatLng(14.6996008, -17.4512257),
        const LatLng(14.6995771, -17.451298),
        const LatLng(14.6995194, -17.451279),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle HA3
    Polygon(
      polygonId: const PolygonId('Salle HA3'),
      zIndex: 3,
      points: [
        const LatLng(14.6995618, -17.451155),
        const LatLng(14.6995878, -17.4510733),
        const LatLng(14.6996421, -17.4510903),
        const LatLng(14.6996164, -17.451172),
        const LatLng(14.6995618, -17.451155),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle HA6
    Polygon(
      polygonId: const PolygonId('Salle HA6'),
      zIndex: 3,
      points: [
        const LatLng(14.6996023, -17.4513153),
        const LatLng(14.6996268, -17.451232),
        const LatLng(14.6996702, -17.451247),
        const LatLng(14.6996441, -17.4513326),
        const LatLng(14.6996023, -17.4513153),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Toilettes étudiant
    Polygon(
      polygonId: const PolygonId('Toilettes étudiant'),
      points: [
        const LatLng(14.699632, -17.451087),
        const LatLng(14.6995878, -17.4510733),
        const LatLng(14.6995955, -17.4510489),
        const LatLng(14.6996132, -17.451054),
        const LatLng(14.6996176, -17.4510437),
        const LatLng(14.6996443, -17.4510516),
        const LatLng(14.699632, -17.451087),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Salle HA1
    Polygon(
      polygonId: const PolygonId('Salle HA1'),
      points: [
        const LatLng(14.69984, -17.451043),
        const LatLng(14.69981, -17.45113),
        const LatLng(14.699663, -17.451074),
        const LatLng(14.699677, -17.4510321),
        const LatLng(14.6996295, -17.4510152),
        const LatLng(14.6996435, -17.4509756),
        const LatLng(14.699689, -17.450991),
        const LatLng(14.69984, -17.451043),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Tour mystère
    Polygon(
      polygonId: const PolygonId('Tour mystère'),
      points: [
        const LatLng(14.6996132, -17.451054),
        const LatLng(14.6995994, -17.45105),
        const LatLng(14.6995914, -17.4510521),
        const LatLng(14.6995827, -17.4510449),
        const LatLng(14.6995812, -17.4510313),
        const LatLng(14.6995913, -17.4510213),
        const LatLng(14.6996025, -17.4510218),
        const LatLng(14.699608, -17.4510288),
        const LatLng(14.6996197, -17.4510346),
        const LatLng(14.6996132, -17.451054),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle HA4
    Polygon(
      polygonId: const PolygonId('Salle HA4'),
      points: [
        const LatLng(14.6996445, -17.4511777),
        const LatLng(14.6996645, -17.4511064),
        const LatLng(14.6997085, -17.4511214),
        const LatLng(14.6996865, -17.4511907),
        const LatLng(14.6996445, -17.4511777),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle HA1
    Polygon(
      polygonId: const PolygonId('Salle HA1*'),
      zIndex: 4,
      points: [
        const LatLng(14.6995618, -17.451155),
        const LatLng(14.6996164, -17.451172),
        const LatLng(14.6996008, -17.4512257),
        const LatLng(14.6995435, -17.451207),
        const LatLng(14.6995618, -17.451155),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Salle MP-ISI2
    Polygon(
      polygonId: PolygonId('Salle_mp_isi2'),
      points: [
        LatLng(14.6998796, -17.4514888),
        LatLng(14.6999335, -17.4515072),
        LatLng(14.6999005, -17.4516182),
        LatLng(14.6998453, -17.4515988),
        LatLng(14.6998796, -17.4514888),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle MP-SSI2
    Polygon(
      polygonId: PolygonId('Salle_mp_ssi2'),
      points: [
        LatLng(14.6997876, -17.4515804),
        LatLng(14.6998229, -17.4514694),
        LatLng(14.6998796, -17.4514888),
        LatLng(14.6998453, -17.4515988),
        LatLng(14.6997876, -17.4515804),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Service technique
    Polygon(
      polygonId: PolygonId('service_technique'),
      points: [
        LatLng(14.7000202, -17.4514055),
        LatLng(14.7000364, -17.4513585),
        LatLng(14.7001208, -17.4513892),
        LatLng(14.7001074, -17.4514341),
        LatLng(14.7000202, -17.4514055),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Labo 1 (MP-TM)
    Polygon(
      polygonId: PolygonId('labo_1'),
      points: [
        LatLng(14.7000694, -17.4515105),
        LatLng(14.6999945, -17.4514818),
        LatLng(14.7000135, -17.4514218),
        LatLng(14.7000905, -17.4514538),
        LatLng(14.7000694, -17.4515105),
      ],
      fillColor: const Color.fromRGBO(232, 253, 232, 1.0),
      strokeColor: const Color.fromRGBO(129, 199, 132, 1.0),
      strokeWidth: 2,
    ),

// Toilettes (bloc principal)
    Polygon(
      polygonId: PolygonId('toilettes *'),
      points: [
        LatLng(14.7000581, -17.4515425),
        LatLng(14.7000478, -17.4515718),
        LatLng(14.7000004, -17.4515545),
        LatLng(14.70001, -17.4515268),
        LatLng(14.7000581, -17.4515425),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Toilettes homme
    Polygon(
      polygonId: PolygonId('toilettes_homme'),
      points: [
        LatLng(14.6996955, -17.4515497),
        LatLng(14.6997045, -17.4515214),
        LatLng(14.6997293, -17.4515297),
        LatLng(14.699721, -17.4515581),
        LatLng(14.6996955, -17.4515497),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Toilettes femme
    Polygon(
      polygonId: PolygonId('toilettes_femme'),
      points: [
        LatLng(14.6997463, -17.4515668),
        LatLng(14.6997576, -17.4515361),
        LatLng(14.6997973, -17.4515491),
        LatLng(14.6997876, -17.4515804),
        LatLng(14.6997463, -17.4515668),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Bureau Thierry
    Polygon(
      polygonId: PolygonId('bureau_thierry'),
      points: [
        LatLng(14.6997858, -17.4514918),
        LatLng(14.6998122, -17.4515018),
        LatLng(14.6998009, -17.4515375),
        LatLng(14.6997748, -17.4515268),
        LatLng(14.6997858, -17.4514918),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Infirmerie
    Polygon(
      polygonId: PolygonId('infirmery'),
      points: [
        LatLng(14.6999005, -17.4516182),
        LatLng(14.6999255, -17.4515372),
        LatLng(14.6999715, -17.4515535),
        LatLng(14.6999495, -17.4516102),
        LatLng(14.6999675, -17.4516162),
        LatLng(14.6999595, -17.4516382),
        LatLng(14.6999415, -17.4516322),
        LatLng(14.6999005, -17.4516182),
      ],
      fillColor: const Color.fromRGBO(188, 248, 248, 1.0),
      strokeColor: const Color.fromRGBO(127, 201, 208, 1.0),
      strokeWidth: 2,
    ),

// Labo 2
    Polygon(
      polygonId: PolygonId('labo_2'),
      points: [
        LatLng(14.6999595, -17.4516382),
        LatLng(14.6999895, -17.4515502),
        LatLng(14.7000478, -17.4515718),
        LatLng(14.7000155, -17.4516582),
        LatLng(14.6999595, -17.4516382),
      ],
      fillColor: const Color.fromRGBO(232, 253, 232, 1.0),
      strokeColor: const Color.fromRGBO(129, 199, 132, 1.0),
      strokeWidth: 2,
    ),

    // Bureau Hervé
    Polygon(
      polygonId: PolygonId('bureau_herve'),
      points: [
        LatLng(14.6997942, -17.4514604),
        LatLng(14.6998229, -17.4514694),
        LatLng(14.6998122, -17.4515018),
        LatLng(14.6997842, -17.4514914),
        LatLng(14.6997942, -17.4514604),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Laboratoire Cisco
    Polygon(
      polygonId: PolygonId('laboratoire_cisco'),
      points: [
        LatLng(14.6996429, -17.4514065),
        LatLng(14.6997299, -17.4514364),
        LatLng(14.6996952, -17.4515468),
        LatLng(14.6996095, -17.4515191),
        LatLng(14.6996429, -17.4514065),
      ],
      fillColor: Color.fromRGBO(232, 253, 232, 1.0), // Vert clair
      strokeColor: Color.fromRGBO(129, 199, 132, 1.0),
      strokeWidth: 2,
    ),

    // Salle Mystère 1
    Polygon(
      polygonId: PolygonId('Salle_mystere_1'),
      points: [
        LatLng(14.7000135, -17.4514218),
        LatLng(14.7000202, -17.4514055),
        LatLng(14.7001074, -17.4514341),
        LatLng(14.7001025, -17.4514488),
        LatLng(14.7000935, -17.4514455),
        LatLng(14.7000905, -17.4514538),
        LatLng(14.7000135, -17.4514218),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Salle Mystère 2
    Polygon(
      polygonId: PolygonId('Salle_mystere_2'),
      points: [
        LatLng(14.6999675, -17.4516162),
        LatLng(14.6999495, -17.4516102),
        LatLng(14.6999694, -17.4515522),
        LatLng(14.6999869, -17.4515591),
        LatLng(14.6999675, -17.45161692),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Resto
    Polygon(
      polygonId: PolygonId('resto'),
      points: [
        LatLng(14.70002, -17.4513534),
        LatLng(14.7000629, -17.4512324),
        LatLng(14.7001002, -17.4512434),
        LatLng(14.7001718, -17.4512709),
        LatLng(14.7002214, -17.4512908),
        LatLng(14.7001824, -17.451408),
        LatLng(14.7001208, -17.4513892),
        LatLng(14.70002, -17.4513534),
      ],
      fillColor: const Color.fromRGBO(255, 236, 179, 1.0), // Jaune clair
      strokeColor: const Color.fromRGBO(
          255, 193, 7, 1.0), // Jaune rappelant un restaurant
      strokeWidth: 2,
    ),

// Toilettes (mêmes couleurs que précédemment)
    Polygon(
      polygonId: PolygonId('toilettes'),
      points: [
        LatLng(14.7001002, -17.4512434),
        LatLng(14.7000897, -17.4512761),
        LatLng(14.7000536, -17.4512624),
        LatLng(14.7000265, -17.4512522),
        LatLng(14.7000377, -17.4512221),
        LatLng(14.7001002, -17.4512434),
      ],
      fillColor: Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Salle Amicale (mêmes couleurs que les Salles habituelles)
    Polygon(
      polygonId: PolygonId('salle_amicale'),
      points: [
        LatLng(14.7000377, -17.4512221),
        LatLng(14.7000197, -17.4512721),
        LatLng(14.6999528, -17.4512445),
        LatLng(14.6999668, -17.4511978),
        LatLng(14.7000377, -17.4512221),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Lot 5 (batiment E) :


    // E-11 ÉLECTRONIQUE (Mr Rabé)
    Polygon(
      polygonId: PolygonId('E-11 ÉLECTRONIQUE (Mr Rabé)'),
      points: [
        LatLng(14.7001314, -17.4508243),
        LatLng(14.7000509, -17.4507924),
        LatLng(14.7000889, -17.4506834),
        LatLng(14.7001816, -17.4507187),
        LatLng(14.7002039, -17.4506514),
        LatLng(14.7002374, -17.4506633),
        LatLng(14.7002052, -17.4507546),
        LatLng(14.7001614, -17.4507375),
        LatLng(14.7001314, -17.4508243),
        ],
      strokeColor: Color.fromRGBO(129, 199, 132, 1.0),
      fillColor: Color.fromRGBO(232, 253, 232, 1.0),
      strokeWidth: 2,
    ),

    // E-13 Commutateur
    Polygon(
      polygonId: PolygonId('E-13 COMMUTATEUR'),
      points: [
        LatLng(14.7002477, -17.4507639),
        LatLng(14.7002767, -17.4506773),
        LatLng(14.7004085, -17.4507223),
        LatLng(14.7004022, -17.450739),
        LatLng(14.7004292, -17.450749),
        LatLng(14.7004065, -17.4508185),
        LatLng(14.7002477, -17.4507639),
      ],
      strokeColor: Color.fromRGBO(129, 199, 132, 1.0),
      fillColor: Color.fromRGBO(232, 253, 232, 1.0),
      strokeWidth: 2,
    ),

    // E-15 LABO FEU Abdoulaye SADOU
    Polygon(
      polygonId: PolygonId('E-15 LABO FEU Abdoulaye SADOU'),
      points: [
        LatLng(14.7004917, -17.4508795),
        LatLng(14.7004454, -17.4510215),
        LatLng(14.7003702, -17.4509942),
        LatLng(14.7004146, -17.4508545),
        LatLng(14.7004917, -17.4508795),
      ],
      strokeColor: Color.fromRGBO(129, 199, 132, 1.0),
      fillColor: Color.fromRGBO(232, 253, 232, 1.0),
      strokeWidth: 2,
    ),

    // Polygon for E-16 Résezux locaux
    Polygon(
      polygonId: PolygonId("E-16 Résezux locaux"),
      points: [
        LatLng(14.7004454, -17.4510215),
        LatLng(14.7004009, -17.4511545),
        LatLng(14.7003265, -17.4511262),
        LatLng(14.7003702, -17.4509942),
        LatLng(14.7004454, -17.4510215),
      ],
      fillColor: const Color.fromRGBO(232, 253, 232, 1.0),
      strokeColor: const Color.fromRGBO(129, 199, 132, 1.0),
      strokeWidth: 2,
    ),
    // Polygon for E-17 Labo TP
    Polygon(
      polygonId: PolygonId("E-17 Labo TP"),
      points: [
        LatLng(14.7002594, -17.4511458),
        LatLng(14.7003454, -17.4511781),
        LatLng(14.7003274, -17.4512312),
        LatLng(14.7003705, -17.4512472),
        LatLng(14.7003569, -17.4512894),
        LatLng(14.7002288, -17.4512418),
        LatLng(14.7002594, -17.4511458),
      ],
      fillColor: const Color.fromRGBO(232, 253, 232, 1.0),
      strokeColor: const Color.fromRGBO(129, 199, 132, 1.0),
      strokeWidth: 2,
    ),
    // Polygon for E-18 Classe Lmen1
    Polygon(
      polygonId: PolygonId("E-18 Classe Lmen1"),
      points: [
        LatLng(14.7002594, -17.4511458),
        LatLng(14.7002288, -17.4512418),
        LatLng(14.7001549, -17.4512144),
        LatLng(14.7001864, -17.4511164),
        LatLng(14.7002594, -17.4511458),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // E14 - ???

  Polygon(
  polygonId: PolygonId("E14 - ???"),
  points: [
  LatLng(14.7004342, -17.4507326),
  LatLng(14.7005299, -17.4507654),
  LatLng(14.7005135, -17.4508133),
  LatLng(14.7004992, -17.4508565),
  LatLng(14.7004772, -17.4508489),
  LatLng(14.7004792, -17.4508408),
  LatLng(14.7004075, -17.4508165),
  LatLng(14.7004342, -17.4507326),
  ],
  strokeWidth: 2,
  strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
  fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
  ),

    // Toilettes 1
    Polygon(
      polygonId: PolygonId("Toilettes 1"),
      points: const [
        LatLng(14.7003927, -17.4511801),
        LatLng(14.7003705, -17.4512472),
        LatLng(14.7003274, -17.4512312),
        LatLng(14.7003454, -17.4511781),
        LatLng(14.7003293, -17.4511721),
        LatLng(14.7003346, -17.4511578),
        LatLng(14.7003927, -17.4511801),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// Toilettes 2
    Polygon(
      polygonId: PolygonId("Toilettes 2"),
      points: const [
        LatLng(14.7002122, -17.450736),
        LatLng(14.7002374, -17.4506633),
        LatLng(14.7002767, -17.4506773),
        LatLng(14.7002518, -17.4507513),
        LatLng(14.7002122, -17.450736),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),


    // Batiment A Etage 0 :

    // Accueil ESMT
    Polygon(
      polygonId: PolygonId('Accueil ESMT'),
      points: [
        LatLng(14.7000809, -17.450923),
        LatLng(14.7000446, -17.45091),
        LatLng(14.700052, -17.4508894),
        LatLng(14.7000791, -17.4508757),
        LatLng(14.7000886, -17.4508973),
        LatLng(14.7000809, -17.450923),
      ],
      strokeColor: const Color(0XFFE6E1CE),
      strokeWidth: 2,
      fillColor: const Color(0XFFFDF9EE),
    ),

    // Agents de liaison
    Polygon(
      polygonId: PolygonId('Agents de liaison'),
      points: [
        LatLng(14.7000564, -17.450996),
        LatLng(14.7000204, -17.4509813),
        LatLng(14.7000324, -17.4509457),
        LatLng(14.700068, -17.4509597),
        LatLng(14.7000564, -17.450996),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // grey fill
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0), // darker grey border
      strokeWidth: 2,
    ),


    // Bureau DEFR (M.Kora)
    Polygon(
      polygonId: PolygonId('Bureau DEFR (M.Kora)'),
      points: [
        LatLng(14.7000327, -17.4511024),
        LatLng(14.700016, -17.4511557),
        LatLng(14.6999551, -17.4511307),
        LatLng(14.6999724, -17.451078),
        LatLng(14.7000327, -17.4511024),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // grey fill
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0), // darker grey border
      strokeWidth: 2,
    ),


    // Bureau Mme Marthe
    Polygon(
      polygonId: PolygonId('Bureau Mme Marthe'),
      points: [
        LatLng(14.700083, -17.451098),
        LatLng(14.7000582, -17.4511724),
        LatLng(14.700016, -17.4511557),
        LatLng(14.7000327, -17.4511024),
        LatLng(14.7000534, -17.4511107),
        LatLng(14.7000606, -17.4510897),
        LatLng(14.700083, -17.451098),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // grey fill
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0), // darker grey border
      strokeWidth: 2,
    ),


// Bureau Mr Alpha Barry
    Polygon(
      polygonId: PolygonId('Bureau Mr Alpha Barry'),
      points: [
        LatLng(14.6999637, -17.4509957),
        LatLng(14.699982, -17.450945),
        LatLng(14.7000127, -17.450957),
        LatLng(14.699996, -17.451008),
        LatLng(14.6999637, -17.4509957),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // grey fill
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0), // darker grey border
      strokeWidth: 2,
    ),

// Bureau Mr BA & Mr Preira
    Polygon(
      polygonId: PolygonId('Bureau Mr BA & Mr Preira'),
      points: [
        LatLng(14.6999551, -17.4511307),
        LatLng(14.6999225, -17.4511184),
        LatLng(14.6999471, -17.451047),
        LatLng(14.699979, -17.45106),
        LatLng(14.6999551, -17.4511307),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // grey fill
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0), // darker grey border
      strokeWidth: 2,
    ),

    // Bureau Mr Boudal Niang
    Polygon(
      polygonId: const PolygonId('bureau_mr_boudal_niang'),
      points: const [
        LatLng(14.7000356, -17.450786),
        LatLng(14.7000896, -17.450807),
        LatLng(14.70008, -17.450832),
        LatLng(14.700063, -17.450826),
        LatLng(14.700053, -17.450856),
        LatLng(14.7000173, -17.4508407),
        LatLng(14.7000356, -17.450786),
      ],
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeWidth: 2,
    ),
    // Bureau Mr Doumbia
    Polygon(
      polygonId: const PolygonId('bureau_mr_doumbia'),
      points: const [
        LatLng(14.699979, -17.45106),
        LatLng(14.6999471, -17.451047),
        LatLng(14.6999637, -17.4509957),
        LatLng(14.699996, -17.451008),
        LatLng(14.699979, -17.45106),
      ],
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeWidth: 2,
    ),
    // Bureau Oumar Ndiaye
    Polygon(
      polygonId: const PolygonId('bureau_oumar_ndiaye'),
      points: const [
        LatLng(14.7001344, -17.4509447),
        LatLng(14.7001244, -17.4509743),
        LatLng(14.7000843, -17.4509587),
        LatLng(14.7000936, -17.4509293),
        LatLng(14.7001344, -17.4509447),
      ],
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeWidth: 2,
    ),



    Polygon(
      polygonId: const PolygonId('Escaliers 1'),
      points: const [
        LatLng(14.700145,-17.450915),
        LatLng(14.7001344,-17.4509447),
        LatLng(14.7001053,-17.450934),
        LatLng(14.7001142,-17.4509041),
        LatLng(14.700145,-17.450915),
      ],
      fillColor: const Color(0XFFF2F3F7),
      strokeColor: const Color(0XFFDCDCDE),
      zIndex: -999999,
      strokeWidth: 2,
    ),

    Polygon(
      polygonId: const PolygonId('Bureau Mme Diallo MDI'),
      points: const [
        LatLng(14.700068, -17.4509597),
        LatLng(14.7000324, -17.4509457),
        LatLng(14.7000446, -17.45091),
        LatLng(14.7000809, -17.450923),
        LatLng(14.700068, -17.4509597),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Bureau mme Garba
    Polygon(
      polygonId: const PolygonId('Bureau Mme Garba'),
      points: const <LatLng>[
        LatLng(14.7000419, -17.4510746),
        LatLng(14.7000327, -17.4511024),
        LatLng(14.6999858, -17.451084),
        LatLng(14.6999959, -17.4510556),
        LatLng(14.7000419, -17.4510746),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Mr Damoue

    Polygon(
      polygonId: const PolygonId('Bureau Mr Damoue'),
      points: const <LatLng>[
        LatLng(14.7000843, -17.4509587),
        LatLng(14.7001244, -17.4509743),
        LatLng(14.7001104, -17.451016),
        LatLng(14.70007, -17.4510013),
        LatLng(14.7000843, -17.4509587),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Mr DER

    Polygon(
      polygonId: const PolygonId('Bureau Mr DER'),
      points: const <LatLng>[
        LatLng(14.7000127, -17.450957),
        LatLng(14.699982, -17.450945),
        LatLng(14.699998, -17.450896),
        LatLng(14.7000284, -17.450907),
        LatLng(14.7000127, -17.450957),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Salle des profs

    Polygon(
      polygonId: const PolygonId('Salle des profs'),
      points: const <LatLng>[
        LatLng(14.7000411, -17.451043),
        LatLng(14.7000044, -17.451029),
        LatLng(14.7000204, -17.4509813),
        LatLng(14.7000564, -17.450996),
        LatLng(14.7000411, -17.451043),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Toilettes personnels homme

    Polygon(
      polygonId: const PolygonId('Toilettes personnel homme'),
      points: const <LatLng>[
        LatLng(14.70007, -17.4510013),
        LatLng(14.7001104, -17.451016),
        LatLng(14.7001, -17.451048),
        LatLng(14.7000603, -17.4510327),
        LatLng(14.70007, -17.4510013),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,

    ),


  };

  Set<Polygon> _secondFloorPolygons = {

    // - Batiment E

    // E25
    Polygon(
      polygonId: PolygonId('E25 LP3'),
      points: [
        LatLng(14.7003538, -17.4510508),
        LatLng(14.7004261, -17.4510785),
        LatLng(14.700400329017548, -17.45115391910076),
        LatLng(14.700329631346406, -17.45112575590611),
        LatLng(14.7003538, -17.4510508),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // E26
    Polygon(
      polygonId: PolygonId('Salle E26 LTI2A'),
      points: [
        LatLng(14.7002674, -17.4511494),
        LatLng(14.7003877, -17.4511951),
        LatLng(14.7003569, -17.4512894),
        LatLng(14.7002379, -17.4512452),
        LatLng(14.7002674, -17.4511494),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Salle mystère
    Polygon(
      polygonId: PolygonId('Salle mystère'),
      points: [
        LatLng(14.7004065, -17.4508185),
        LatLng(14.7004342, -17.4507326),
        LatLng(14.7004738, -17.4507466),
        LatLng(14.7004474, -17.4508318),
        LatLng(14.7004065, -17.4508185),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),


    // E 27
    Polygon(
      polygonId: PolygonId('E 27 Classe MMTD1 (en construction)'),
      points: [
        LatLng(14.7002379, -17.4512452),
        LatLng(14.7001549, -17.4512144),
        LatLng(14.7001857, -17.4511205),
        LatLng(14.7002674, -17.4511494),
        LatLng(14.7002379, -17.4512452),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // E-22
    Polygon(
      polygonId: PolygonId('E-22 LTI2B'),
      points: [
        LatLng(14.7004917, -17.4508795),
        LatLng(14.7004481, -17.4510124),
        LatLng(14.7003732, -17.4509864),
        LatLng(14.7004146, -17.4508545),
        LatLng(14.7004917, -17.4508795),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // E24
    Polygon(
      polygonId: PolygonId('E24 Lmen3 (spé MDI le mardi)'),
      points: [
        LatLng(14.7003732, -17.4509864),
        LatLng(14.7004481, -17.4510124),
        LatLng(14.7004261, -17.4510785),
        LatLng(14.7003538, -17.4510508),
        LatLng(14.7003732, -17.4509864),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // Terrasse

    Polygon(
      polygonId: PolygonId('Terrasse'),
      points: [
        LatLng(14.7004292, -17.450749),
        LatLng(14.7004065, -17.4508185),
        LatLng(14.7004166, -17.4508228),
        LatLng(14.7004094, -17.4508442),
        LatLng(14.7004012, -17.450841),
        LatLng(14.7001765, -17.4507615),
        LatLng(14.7001816, -17.4507187),
        LatLng(14.7002039, -17.4506514),
        LatLng(14.7004085, -17.4507223),
        LatLng(14.7004022, -17.450739),
        LatLng(14.7004292, -17.450749),
      ],
      fillColor: const Color(0XFFFDF9EE),
      strokeColor: const Color(0XFFE6E1CE),
      strokeWidth: 2,
    ),

    // Toilettes
    Polygon(
      polygonId: PolygonId('Toilettes 3 BATE E2'),
      points: [
        LatLng(14.7004573, -17.4507971),
        LatLng(14.7004738, -17.4507466),
        LatLng(14.7005299, -17.4507654),
        LatLng(14.7004992, -17.4508565),
        LatLng(14.700455, -17.4508418),
        LatLng(14.7004672, -17.4508007),
        LatLng(14.7004573, -17.4507971),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

    // - Étage admin

    // Resto
    Polygon(
      polygonId: PolygonId('resto_admin'),
      points: [
        LatLng(14.70002, -17.4513534),
        LatLng(14.7000629, -17.4512324),
        LatLng(14.7001002, -17.4512434),
        LatLng(14.7001718, -17.4512709),
        LatLng(14.7002214, -17.4512908),
        LatLng(14.7001824, -17.451408),
        LatLng(14.7001208, -17.4513892),
        LatLng(14.70002, -17.4513534),
      ],
      fillColor: const Color.fromRGBO(255, 236, 179, 1.0), // Jaune clair
      strokeColor: const Color.fromRGBO(
          255, 193, 7, 1.0), // Jaune rappelant un restaurant
      strokeWidth: 2,
    ),

    // Salle Amicale (mêmes couleurs que les Salles habituelles)
    Polygon(
      polygonId: PolygonId('salle_amicale'),
      points: [
        LatLng(14.7000377, -17.4512221),
        LatLng(14.7000197, -17.4512721),
        LatLng(14.6999528, -17.4512445),
        LatLng(14.6999668, -17.4511978),
        LatLng(14.7000377, -17.4512221),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// Toilettes (mêmes couleurs que précédemment)
    Polygon(
      polygonId: PolygonId('toilettes admin'),
      points: [
        LatLng(14.7001002, -17.4512434),
        LatLng(14.7000897, -17.4512761),
        LatLng(14.7000536, -17.4512624),
        LatLng(14.7000265, -17.4512522),
        LatLng(14.7000377, -17.4512221),
        LatLng(14.7001002, -17.4512434),
      ],
      fillColor: Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

    // - Spot détente
    Polygon(
      polygonId: PolygonId('Spot détente'),
      points: [
        LatLng(14.6997776, -17.451529),
        LatLng(14.6997517, -17.451521),
        LatLng(14.6997688, -17.4514594),
        LatLng(14.6997951, -17.4514671),
        LatLng(14.6997776, -17.451529),
      ],
      fillColor: const Color(0XFFFDF9EE), // Couleur de fond
      strokeColor: const Color(0XFFE6E1CE), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

    // - Toilettes 2 (femmes 2F)
    Polygon(
      polygonId: PolygonId('Toilettes 2 (femmes 2F)'),
      points: [
        LatLng(14.699721, -17.451558),
        LatLng(14.69969, -17.4515464),
        LatLng(14.6996991, -17.4515167),
        LatLng(14.6997309, -17.4515254),
        LatLng(14.699721, -17.451558),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

    // - Toilettes 3 (homme 2F)
    Polygon(
      polygonId: PolygonId('Toilettes 3 (homme 2F)'),
      points: [
        LatLng(14.6997463, -17.4514664),
        LatLng(14.6997345, -17.4515101),
        LatLng(14.6997028, -17.4515007),
        LatLng(14.6997148, -17.4514557),
        LatLng(14.6997463, -17.4514664),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// - Salle informatique (SES F2)
    Polygon(
      polygonId: PolygonId('Salle informatique (SES F2)'),
      points: [
        LatLng(14.7000488, -17.4515688),
        LatLng(14.700016, -17.451658),
        LatLng(14.6999399, -17.4516321),
        LatLng(14.6999682, -17.4515395),
        LatLng(14.7000488, -17.4515688),
      ],
      fillColor: const Color.fromRGBO(188, 248, 248, 1.0), // Couleur de fond
      strokeColor:
          const Color.fromRGBO(127, 201, 208, 1.0), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

// - Salle mystère
    Polygon(
      polygonId: PolygonId('Salle mystère 1'),
      points: [
        LatLng(14.6996114, -17.4512107),
        LatLng(14.699551, -17.451186),
        LatLng(14.6995568, -17.4511663),
        LatLng(14.699618, -17.451187),
        LatLng(14.6996114, -17.4512107),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// - Salle mystère
    Polygon(
      polygonId: PolygonId('Salle mystère 2'),
      points: [
        LatLng(14.6996358, -17.4511727),
        LatLng(14.6996302, -17.4511929),
        LatLng(14.6995568, -17.4511663),
        LatLng(14.6995622, -17.4511486),
        LatLng(14.6996358, -17.4511727),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Salle de conférence
    Polygon(
      polygonId: PolygonId('Salle de conférence'),
      points: [
        LatLng(14.69969, -17.4515464),
        LatLng(14.69961, -17.451519),
        LatLng(14.6996346, -17.4514291),
        LatLng(14.6997148, -17.4514557),
        LatLng(14.6997028, -17.4515007),
        LatLng(14.6997256, -17.4515074),
        LatLng(14.6997203, -17.451523),
        LatLng(14.6996991, -17.4515167),
        LatLng(14.69969, -17.4515464),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // Couleur de fond
      strokeColor:
          const Color.fromRGBO(182, 182, 182, 1.0), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

// - Salle HA8
    Polygon(
      polygonId: PolygonId('Salle HA8'),
      points: [
        LatLng(14.6997086, -17.451117),
        LatLng(14.699687, -17.451191),
        LatLng(14.6995622, -17.4511486),
        LatLng(14.6995894, -17.4510723),
        LatLng(14.6997086, -17.451117),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// - Salle de classe HB6
    Polygon(
      polygonId: PolygonId('Salle de classe HB6'),
      points: [
        LatLng(14.6994723, -17.4514183),
        LatLng(14.6995173, -17.4512849),
        LatLng(14.6995913, -17.4513113),
        LatLng(14.6995487, -17.4514467),
        LatLng(14.6994723, -17.4514183),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Salle de classe

    Polygon(
      polygonId: PolygonId('Salle de classe mystère 1'),
      points: [
        LatLng(14.699819, -17.451106),
        LatLng(14.699731, -17.451074),
        LatLng(14.699751, -17.451013),
        LatLng(14.69984, -17.451044),
        LatLng(14.699819, -17.451106),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // Couleur de fond
      strokeColor:
          const Color.fromRGBO(182, 182, 182, 1.0), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

    // - Salle de classe

    Polygon(
      polygonId: PolygonId('Salle de classe mystère 2'),
      points: [
        LatLng(14.6999989, -17.4514111),
        LatLng(14.70002, -17.451353),
        LatLng(14.700121, -17.451389),
        LatLng(14.700102, -17.451449),
        LatLng(14.6999989, -17.4514111),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Bureau mystère

    Polygon(
      polygonId: PolygonId('Bureau mystère'),
      points: [
        LatLng(14.7000384, -17.4515002),
        LatLng(14.700011, -17.451489),
        LatLng(14.7000195, -17.4514634),
        LatLng(14.700048, -17.4514751),
        LatLng(14.7000384, -17.4515002),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Incubateur
    Polygon(
      polygonId: PolygonId('Incubateur'),
      points: [
        LatLng(14.699594, -17.451556),
        LatLng(14.6995369, -17.4515364),
        LatLng(14.6995726, -17.4514205),
        LatLng(14.6996319, -17.4514422),
        LatLng(14.69961, -17.451519),
        LatLng(14.699594, -17.451556),
      ],
      fillColor: const Color(0xFFF7C8ED), // Rose clair
      strokeColor: const Color(0xFFE17FCC),
      strokeWidth: 2,
    ),

// - Toilettes 1 (F2)
    Polygon(
      polygonId: PolygonId('Toilettes 1 (F2)'),
      points: [
        LatLng(14.700058, -17.451542),
        LatLng(14.7000488, -17.4515688),
        LatLng(14.7000088, -17.4515548),
        LatLng(14.7000178, -17.4515285),
        LatLng(14.700058, -17.451542),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0),
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// - Salle de classe
    Polygon(
      polygonId: PolygonId('Salle de classe mystère 3'),
      points: [
        LatLng(14.6999402, -17.4516318),
        LatLng(14.6998449, -17.4515995),
        LatLng(14.6998762, -17.4514968),
        LatLng(14.6999712, -17.4515308),
        LatLng(14.6999402, -17.4516318),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Bureau M.Doudou Faye
    Polygon(
      polygonId: PolygonId('Bureau M.Doudou Faye'),
      points: [
        LatLng(14.7000844, -17.4514701),
        LatLng(14.7000534, -17.4514581),
        LatLng(14.7000624, -17.4514341),
        LatLng(14.700094, -17.451446),
        LatLng(14.7000844, -17.4514701),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // Couleur de fond
      strokeColor:
          const Color.fromRGBO(182, 182, 182, 1.0), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

// - Bureau Mme Rita
    Polygon(
      polygonId: PolygonId('Bureau Mme Rita'),
      points: [
        LatLng(14.7000534, -17.4514581),
        LatLng(14.700027, -17.4514481),
        LatLng(14.7000344, -17.4514238),
        LatLng(14.7000624, -17.4514341),
        LatLng(14.7000534, -17.4514581),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

// - Gymnase
    Polygon(
      polygonId: PolygonId('Gymnase'),
      points: [
        LatLng(14.6994723, -17.4514183),
        LatLng(14.6995632, -17.4514526),
        LatLng(14.6995369, -17.4515364),
        LatLng(14.69951, -17.451529),
        LatLng(14.699502, -17.451556),
        LatLng(14.699434, -17.4515321),
        LatLng(14.6994723, -17.4514183),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Bibliothèque
    Polygon(
      polygonId: PolygonId('Bibliothèque'),
      points: [
        LatLng(14.699693, -17.451111),
        LatLng(14.6995894, -17.4510723),
        LatLng(14.699595, -17.451052),
        LatLng(14.6995736, -17.4510447),
        LatLng(14.6996011, -17.4509583),
        LatLng(14.699751, -17.451013),
        LatLng(14.699731, -17.451074),
        LatLng(14.69971, -17.451067),
        LatLng(14.699693, -17.451111),
      ],
      fillColor: const Color(0xFFC2AEA9), // Couleur de fond
      strokeColor: const Color(0xFF452B24), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

// - Bureau chef département FOAD
    Polygon(
      polygonId: PolygonId('Bureau chef département FOAD'),
      points: [
        LatLng(14.7000693, -17.451512),
        LatLng(14.7000384, -17.4515002),
        LatLng(14.700048, -17.4514751),
        LatLng(14.7000788, -17.4514864),
        LatLng(14.7000693, -17.451512),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),

    // - Salle de classe mystère (côté SES)
    Polygon(
      polygonId: PolygonId('Salle de classe mystère (côté SES)'),
      points: [
        LatLng(14.6998449, -17.4515995),
        LatLng(14.6997656, -17.4515721),
        LatLng(14.6997951, -17.4514671),
        LatLng(14.6998773, -17.4514938),
        LatLng(14.6998449, -17.4515995),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0), // Couleur de fond
      strokeColor:
          const Color.fromRGBO(182, 182, 182, 1.0), // Couleur de bordure
      strokeWidth: 2, // Épaisseur de la bordure
    ),

// - Toilettes 4 (mixtes 2F)
    Polygon(
      polygonId: PolygonId('Toilettes 4 (mixtes 2F)'),
      points: [
        LatLng(14.699644, -17.451333),
        LatLng(14.69959, -17.451311),
        LatLng(14.6996098, -17.451254),
        LatLng(14.6996618, -17.4512727),
        LatLng(14.699644, -17.451333),
      ],
      fillColor: const Color.fromRGBO(223, 227, 255, 1.0), // Violet clair
      strokeColor: const Color.fromRGBO(152, 159, 228, 1.0),
      strokeWidth: 2,
    ),

// - Salle de classe mystère (côté HA8)
    Polygon(
      polygonId: PolygonId('Salle de classe mystère (côté HA8)'),
      points: [
        LatLng(14.6995913, -17.4513113),
        LatLng(14.6995173, -17.4512849),
        LatLng(14.699551, -17.451186),
        LatLng(14.6996238, -17.4512143),
        LatLng(14.6995913, -17.4513113),
      ],
      fillColor: const Color.fromRGBO(217, 217, 217, 1.0),
      strokeColor: const Color.fromRGBO(182, 182, 182, 1.0),
      strokeWidth: 2,
    ),
  };
  double zoomLevel = 17;

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

// Map pour stocker les objets Uint8List avec leur nom comme clé
  Map<String, Uint8List> imageByteMap = {};
  Map<String, BitmapDescriptor> icons = {};

  Future<void> loadImagesAsUint8List() async {
    // Liste des noms de fichiers dans le dossier assets/map_icons/
    List<String> imageNames = [
      "labo.png",
      "ne_venez_pas_ici.png",
      "point_priere.png",
      "random_gifts.png",
      "easter_egg_gifts.png",
      "st_valentine_gifts.png",
      "christmas_gifts.png",
      "salle_amicale.png",
      "salle_biblio.png",
      "salle_conference.png",
      "salle_cyber_HA8.png",
      "salle_dar.png",
      "salle_gymnase.png",
      "salle_ha_.png",
      "salle_ha?.png",
      "salle_ha1.png",
      "salle_ha3.png",
      "salle_ha4.png",
      "salle_ha5.png",
      "salle_ha6.png",
      "salle_hb2.png",
      "salle_hb3.png",
      "salle_hb6.png",
      "salle_HA7.png",
      "salle_HA8.png",
      "salle_incubateur.png",
      "salle_infirmerie.png",
      "salle_mp_isi2.png",
      "salle_mp_ssi2.png",
      "salle_mystere_2.png",
      "salle_mystere.png",
      "salle_reprographie.png",
      "exit.png",
      "bat_e.png",
      "salle_restaurant.png",
      "sortie_batiment.png",
      "toilette_mixte_locked.png",
      "toilette_mixte.png",
      "toilettes_femme.png",
      "toilettes_homme.png",
    ];

    // Parcourir chaque image et la convertir en Uint8List
    for (String imageName in imageNames) {
      try {
        // Charger l'image en tant que ByteData
        ByteData data = await rootBundle.load('assets/map_icons/$imageName');
        // Convertir le ByteData en Uint8List
        Uint8List bytes = data.buffer.asUint8List();
        // Ajouter le Uint8List à la map avec le nom de l'image comme clé
        imageByteMap[imageName] = bytes;

        icons[imageName] = await BitmapDescriptor.fromBytes(
          bytes,
          size: Size(1, 1),
        );
        print(
            'Image: $imageName, Bytes: ${base64Encode(bytes).substring(0, 50)}...'); // Print une partie de l'encodage en base64 pour vérification
      } catch (e) {
        print('Erreur lors du chargement de l\'image: $imageName. Erreur: $e');
      }
    }

    print('Nombre total d\'images chargées : ${icons.length}');
  }

  BitmapDescriptor _getIconForEvent(GiftEvent event, Map<String, BitmapDescriptor> icons) {
    switch (event) {
      case GiftEvent.CHRISTMAS:
        return icons["christmas_gifts.png"] ?? BitmapDescriptor.defaultMarker;
      case GiftEvent.EASTER_EGG:
        return icons["easter_egg_gifts.png"]  ?? BitmapDescriptor.defaultMarker;
      case GiftEvent.ST_VALENTINE:
        return icons["st_valentine_gifts.png"] ?? BitmapDescriptor.defaultMarker;
      case GiftEvent.NEW_YEAR:
        // AJOUTER LES AUTRES EVENEMENTS PLUS TARD
      default:
        return icons["random_gifts.png"] ?? BitmapDescriptor.defaultMarker;
    }
  }


  @override
  void initState() {

    // ezz

    DefaultAssetBundle.of(context)
        .loadString("assets/mapstyles/light_mode.json")
        .then((value) {
      mapStyle = value;
    });

    loadImagesAsUint8List().then((value) {
      _initializeLevel1Markers();
      _initializeLevel1Markers2();
      _initializeLevel2Markers();
      _initializeLevel2Markers2();
      _initializeLevel3Markers();
      _initializeTextMarkersOfLevel1();
      _initializeTextMarkersOfLevel12();
    });
    super.initState();
  }

  Future<void> _initializeTextMarkersOfLevel1() async {
    List<Map<String, dynamic>> markerData = [

      // BAT A :

      {
        "markerId": "Bureau\nMr Boudal Niang",
        "rotation": -18.0,
        "position": LatLng(14.70004684043293, -17.450822666287422),
        "title": "Bureau\nMr Boudal Niang",
      },

      {
        "markerId": "Bureau\nMr Lemrabott",
        "rotation": -18.0,
        "position": LatLng(14.7001444552277, -17.450862899422646),
        "title": "Bureau\nMr Lemrabott",
      },

      {
        "markerId": "Bureau\nMr O.Ndiaye",
        "rotation": -18.0,
        "position": LatLng(14.700109106353576, -17.45095442980528),
        "title": "Bureau\nMr O.Ndiaye",
      },

      {
        "markerId": "Bureau\nMr Damoue",
        "rotation": -18.0,
        "position": LatLng(14.700096782891524, -17.450988963246342),
        "title": "Bureau\nMr Damoue",
      },

      {
        "markerId": "Bureau\nMme Marthe",
        "rotation": -18.0,
        "position": LatLng(14.70004716473465, -17.451136149466038),
        "title": "Bureau\nMme Marthe",
      },

      {
        "markerId": "Bureau\nMr Kora",
        "rotation": 73.0,
        "position": LatLng(14.699995600755758, -17.451119385659695),
        "title": "Bureau\nMr Kora",
      },

      {
        "markerId": "Bureau\nMr Preira & Mr Ba",
        "rotation": -18.0,
        "position": LatLng(14.69995117140569, -17.451089210808274),
        "title": "Bureau\nMr Preira & Mr Ba",
      },


      {
        "markerId": "Bureau\nMr Doumbia",
        "rotation": -18.0,
        "position": LatLng(14.699969332309005, -17.451029866933823),
        "title": "Bureau\nMr Doumbia",
      },

      {
        "markerId": "Bureau\nMr Alpha Barry",
        "rotation": -18.0,
        "position": LatLng(14.69998846611621, -17.450980581343174),
        "title": "Bureau\nMr Alpha Barry",
      },

      {
        "markerId": "Bureau\nMr DER",
        "rotation": -18.0,
        "position": LatLng(14.700002735395076, -17.45092827826738),
        "title": "Bureau\nMr DER",
      },

      {
        "markerId": "Salle\ndes profs",
        "rotation": 73.0,
        "position": LatLng(14.700031273950001, -17.45101746171713),
        "title": "Salle\ndes profs",
      },

      {
        "markerId": "Agents\nde liaison",
        "rotation": 73.0,
        "position": LatLng(14.700044246019184, -17.450973205268383),
        "title": "Agents\nde liaison",
      },

      {
        "markerId": "Bureau\nMme Diallo MDI",
        "rotation": 73.0,
        "position": LatLng(14.700055920880796, -17.450935654342175),
        "title": "Bureau\nMme Diallo\nMDI",
      },

      {
        "markerId": "Accueil\nESMT",
        "rotation": 73.0,
        "position": LatLng(14.700067595741782, -17.450902797281742),
        "title": "Accueil\nESMT",
      },

      {
        "markerId": "Bureau\nMme Garba",
        "rotation": 73.0,
        "position": LatLng(14.700010518637686, -17.45108049362898),
        "title": "Bureau\nMme Garba",
      },

      {
        "markerId": "Salle E13",
        "rotation": 73.0,
        "position": LatLng(14.700335468769655, -17.45076399296522),
        "title": "Salle E13\n(Commutateur)",
      },

      // BAT E :

      // Administration bientôt disponible
      // {
      //   "markerId": "Admin",
      //   "rotation": -5.0,
      //   "position": LatLng(14.700011491543004, -17.45103120803833),
      //   "title": "(Bientôt disponible)",
      // },

      {
        "markerId": "Salle E18",
        "rotation": -18.0,
        "position": LatLng(14.700207045422003, -17.45118040591478),
        "title": "Salle E18\n(LMEN 1)",
      },

      {
        "markerId": "Salle E14",
        "rotation": 73.0,
        "position": LatLng(14.700469405160389, -17.450793161988262),
        "title": "Salle E14\n(mystère)",
      },

      {
        "markerId": "Salle E17",
        "rotation": -18.0,
        "position": LatLng(14.70028098614654, -17.451208233833313),
        "title": "Salle E17\n(Labo TP)",
      },

      {
        "markerId": "Salle E16",
        "rotation": -18.0,
        "position": LatLng(14.700374709221931, -17.451071441173553),
        "title": "Salle E16\n(Réseaux locaux)",
      },

      {
        "markerId": "Salle E15",
        "rotation": -18.0,
        "position": LatLng(14.700419138485834, -17.450932636857033),
        "title": "Salle E15\n(Laboratoire Feu Abdoulaye SADOU)",
      },

      {
        "markerId": "Salle E13",
        "rotation": 73.0,
        "position": LatLng(14.700335468769655, -17.45076399296522),
        "title": "Salle E13\n(Commutateur)",
      },

      {
        "markerId": "Salle E11",
        "rotation": -18.0,
        "position": LatLng(14.700095809986601, -17.450751587748528),
        "title": "Salle E11\n(Électronique - Mr.Rabé)",
      },

      // BAT H :
      {
        "markerId": "Salle HA6",
        "rotation": -18.0,
        "position": LatLng(14.69963, -17.45128),
        "title": "Salle HA6",
      },
      {
        "markerId": "Salle HA4",
        "rotation": -18.0,
        "position": LatLng(14.69967, -17.45114),
        "title": "Salle HA4",
      },
      {
        "markerId": "Bureau HA1",
        "rotation": -18.0,
        "position": LatLng(14.69958114267191, -17.45119046419859),
        "title": "Bureau HA1",
      },

      {
        "markerId": "Bureau recouvrement",
        "rotation": 74.0,
        "position": LatLng(14.699544172194296, -17.45131216943264),
        "title": "Bureau\nrecouvrement",
      },

      {
        "markerId": "Bureausurveillants",
        "rotation": 70.0,
        "position": LatLng(14.6996, -17.45138),
        "title": "Bureau\nsurveillants",
      },

      {
        "markerId": "Bureau Mme Barro",
        "rotation": 70.0,
        "position": LatLng(14.69959, -17.45141),
        "title": "Bureau\nMme Barro",
      },
      {
        "markerId": "Bureau Mr Ouedraogo",
        "rotation": 10.0,
        "position": LatLng(14.6998, -17.45148),
        "title": "Bureau Mr\nOuedraogo",
      },
      {
        "markerId": "Bureau Mr Kondengar",
        "rotation": 10.0,
        "position": LatLng(14.69979, -17.45151),
        "title": "Bureau Mr\nKondengar",
      },
      {
        "markerId": "Salle MP-SSI2",
        "rotation": -20.0,
        "position": LatLng(14.69983, -17.45153),
        "title": "Salle MP-SSI2",
      },
      {
        "markerId": "Salle MP-ISI2",
        "rotation": -20.0,
        "position": LatLng(14.69988, -17.45155),
        "title": "Salle MP-ISI2",
      },
      {
        "markerId": "Salle HA1",
        "rotation": 73.0,
        "position": LatLng(14.69973, -17.45105),
        "title": "Salle HA1",
      },

      {
        "markerId": "Salle HA3",
        "rotation": -20.0,
        "position": LatLng(14.6996, -17.45112),
        "title": "Salle HA3",
      },

      {
        "markerId": "Salle HA5",
        "rotation": -20.0,
        "position": LatLng(14.69956, -17.45125),
        "title": "Salle HA5",
      },

      {
        "markerId": "Ne venez pas ici",
        "rotation": -20.0,
        "position": LatLng(14.699972251025462, -17.45158407837153),
        "title": "Ne venez pas ici",
      },
      {
        "markerId": "Salle mystère",
        "rotation": 75.0,
        "position": LatLng(14.700063055518143, -17.451431192457676),
        "title": "Salle mystère",
      },
      {
        "markerId": "Bureau service technique",
        "rotation": 75.0,
        "position": LatLng(14.70006775831137, -17.45139867067337),
        "title": "Bureau service technique",
      },
      {
        "markerId": "Salle mystère 2",
        "rotation": 73.0,
        "position": LatLng(14.69999689796291, -17.45123405009508),
        "title": "Salle mystère 2",
      },
      // Ajoute plus de markers ici si nécessaire
    ];

    for (var data in markerData) {
      Marker marker = await createTextMarker(
        data["markerId"],
        data["rotation"],
        data["position"],
        data["title"],
      );
      setState(() {
          debugPrint(marker.markerId.toString());
        _levelOneMarkers.add(marker);
      });
    }
  }

  Future<Marker> createTextMarker(
    String markerId,
    double rotation,
    LatLng position,
    String title,
  ) async {
    return Marker(
        markerId: MarkerId(markerId),
        anchor: const Offset(0.5, 0.5),
        zIndex: 2000,
        rotation: rotation,
        position: position,
        icon: await Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color.fromRGBO(75, 75, 75, 1.0),
              fontWeight: FontWeight.w600,
              fontSize: 30),
        ).toBitmapDescriptor(
            logicalSize: const Size(352, 352), imageSize: const Size(352, 352)),
        onTap: () {
          if (markerId == "Bureau Mr Kondengar") {
            context.read<MapBloc>().add(SetSelectedMapEntity(
                Office(
              hasDetails: true,
                  officeRole: "Responsable CISCO",
                  aboutOffice: "Bureau de Mr.Kondengar : Situé au bât..",
                  officeHours: [
                    "05:00 - 22:38",
                    "05:00 - 22:38",
                    "05:00 - 22:38",
                    "05:00 - 22:38",
                    "indisponible (congés)",
                    "indisponible (congés)",
                    "indisponible (congés)",
                  ],
                  servicesProvided: [
                    "Assistance pour les demandes de bourses et autres financements",
                    "Vérification des dossiers d'admission et suivi des candidatures",
                    "Gestion et délivrance des certificats académiques"
                  ],
                  responsables: [
                    Responsable(
                      fullName: "Thierry Kondengar",
                      email: "kondengar@esmt.sn",
                      description:
                          "Toujours à l'écoute, j'accompagne les étudiants dans leurs démarches et m'assure qu'ils aient toutes les ressources pour réussir. N'hésitez pas à venir me voir pour toute question ou besoin de conseil.",
                      photos: [],
                      // Liste de photos, à remplir si nécessaire
                      isTeacher: true,
                      phoneNumber: "+221 76 309 94 67",
                      linkedin: "/in/thierry-49",
                      position: "Assistant Labo CISCO",
                    ),
                  ],
                  placeName: "Bureau Mr.Kondengar",
                  shortDescription:
                      "Responsable CISCO, assistance pour les demandes de bourses et autres financements",
                  entityPosition: position,
                  // Position approximative; à ajuster si nécessaire
                  entityName: "Bureau Mr.Kondengar",
                  rating: "4.7/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ferme à 17h30",
                  about:
                      "N’hésitez pas à me contacter via Whatsapp si je ne suis pas joignable par appel téléphonique.",
                  isOpen: true,
                  photos: [
                    "assets/images/bureau_kondengar.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  // Ajouter les photos disponibles ici
                  placeType: "Bureau",
                )));
          } else {
            switch (markerId) {

              case "Bureau Mr Ouedraogo":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Office(
                      hasDetails: false,
                      officeRole: "Responsable",
                      aboutOffice: "Bureau de Mr.Ouedraogo : Situé au bât..",
                      officeHours: [
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "indisponible (congés)",
                        "indisponible (congés)",
                        "indisponible (congés)",
                      ],
                      servicesProvided: [
                        "Assistance pour les demandes de bourses et autres financements",
                        "Vérification des dossiers d'admission et suivi des candidatures",
                        "Gestion et délivrance des certificats académiques"
                      ],
                      responsables: [
                        Responsable(
                          fullName: "Thierry Kondengar",
                          email: "kondengar@esmt.sn",
                          description:
                          "Toujours à l'écoute, j'accompagne les étudiants dans leurs démarches et m'assure qu'ils aient toutes les ressources pour réussir. N'hésitez pas à venir me voir pour toute question ou besoin de conseil.",
                          photos: [],
                          // Liste de photos, à remplir si nécessaire
                          isTeacher: true,
                          phoneNumber: "+221 76 309 94 67",
                          linkedin: "/in/thierry-49",
                          position: "Assistant Labo CISCO",
                        ),
                      ],
                      placeName: "Bureau Mr.Ouedraogo",
                      shortDescription:
                      "Responsable, assistance pour les demandes de bourses et autres financements",
                      entityPosition: position,
                      // Position approximative; à ajuster si nécessaire
                      entityName: "Bureau Mr.Kondengar",
                      rating: "4.7/5",
                      floor: "Étage 0",
                      building: "Bat H",
                      timeDetail: "Ferme à 17h30",
                      about:
                      "N’hésitez pas à me contacter via Whatsapp si je ne suis pas joignable par appel téléphonique.",
                      isOpen: true,
                      photos: [
                        "assets/images/bureau_ouedraogo.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      // Ajouter les photos disponibles ici
                      placeType: "Bureau",
                    )));
                break;

              case "Bureau Mme Barro":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Office(
                      hasDetails: false,
                      officeRole: "Responsable scolarité",
                      aboutOffice: "Bureau des surveillants : Mr Diatta & Mr Diene",
                      officeHours: [
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "indisponible (congés)",
                        "indisponible (congés)",
                        "indisponible (congés)",
                      ],
                      servicesProvided: [
                        "(les informations ne sont pas à jour)"
                            "Assistance pour les demandes de bourses et autres financements",
                        "Vérification des dossiers d'admission et suivi des candidatures",
                        "Gestion et délivrance des certificats académiques"
                      ],
                      responsables: [
                        Responsable(
                          fullName: "Thierry Kondengar",
                          email: "kondengar@esmt.sn",
                          description:
                          "Toujours à l'écoute, j'accompagne les étudiants dans leurs démarches et m'assure qu'ils aient toutes les ressources pour réussir. N'hésitez pas à venir me voir pour toute question ou besoin de conseil.",
                          photos: [],
                          // Liste de photos, à remplir si nécessaire
                          isTeacher: true,
                          phoneNumber: "+221 76 309 94 67",
                          linkedin: "/in/thierry-49",
                          position: "Assistant Labo CISCO",
                        ),
                      ],
                      placeName: "Bureau surveillants",
                      shortDescription:
                      "Responsable CISCO, assistance pour les demandes de bourses et autres financements",
                      entityPosition: position,
                      // Position approximative; à ajuster si nécessaire
                      entityName: "Bureau Mme Barro",
                      rating: "4.7/5",
                      floor: "Étage 0",
                      building: "Bat H",
                      timeDetail: "Ferme à 17h30",
                      about:
                      "N’hésitez pas à me contacter via Whatsapp si je ne suis pas joignable par appel téléphonique.",
                      isOpen: true,
                      photos: [
                        "assets/images/bureau_surveillants.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      // Ajouter les photos disponibles ici
                      placeType: "Bureau",
                    )));
                break;

              case "Bureausurveillants":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Office(
                      hasDetails: false,
                      officeRole: "Responsables surveillance",
                      aboutOffice: "Bureau scolarité : Mme Barro",
                      officeHours: [
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "indisponible (congés)",
                        "indisponible (congés)",
                        "indisponible (congés)",
                      ],
                      servicesProvided: [
                        "(les informations ne sont pas à jour)"
                            "Assistance pour les demandes de bourses et autres financements",
                        "Vérification des dossiers d'admission et suivi des candidatures",
                        "Gestion et délivrance des certificats académiques"
                      ],
                      responsables: [
                        Responsable(
                          fullName: "Thierry Kondengar",
                          email: "kondengar@esmt.sn",
                          description:
                          "Toujours à l'écoute, j'accompagne les étudiants dans leurs démarches et m'assure qu'ils aient toutes les ressources pour réussir. N'hésitez pas à venir me voir pour toute question ou besoin de conseil.",
                          photos: [],
                          // Liste de photos, à remplir si nécessaire
                          isTeacher: true,
                          phoneNumber: "+221 76 309 94 67",
                          linkedin: "/in/thierry-49",
                          position: "Assistant Labo CISCO",
                        ),
                      ],
                      placeName: "Bureau surveillants",
                      shortDescription:
                      "Responsable CISCO, assistance pour les demandes de bourses et autres financements",
                      entityPosition: position,
                      // Position approximative; à ajuster si nécessaire
                      entityName: "Bureau scolarité : Mme Barro",
                      rating: "4.7/5",
                      floor: "Étage 0",
                      building: "Bat H",
                      timeDetail: "Ferme à 17h30",
                      about:
                      "N’hésitez pas à me contacter via Whatsapp si je ne suis pas joignable par appel téléphonique.",
                      isOpen: true,
                      photos: [
                        "assets/images/bureau_mme_barro.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      // Ajouter les photos disponibles ici
                      placeType: "Bureau",
                    )));
                break;

              case "Bureau recouvrement":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Office(
                      hasDetails: false,
                      officeRole: "Responsable recouvrement",
                      aboutOffice: "Bureau de Mme Khadidiatou Diop : Situé au bât..",
                      officeHours: [
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "05:00 - 22:38",
                        "indisponible (congés)",
                        "indisponible (congés)",
                        "indisponible (congés)",
                      ],
                      servicesProvided: [
                        "(les informations ne sont pas à jour)"
                        "Assistance pour les demandes de bourses et autres financements",
                        "Vérification des dossiers d'admission et suivi des candidatures",
                        "Gestion et délivrance des certificats académiques"
                      ],
                      responsables: [
                        Responsable(
                          fullName: "Thierry Kondengar",
                          email: "kondengar@esmt.sn",
                          description:
                          "Toujours à l'écoute, j'accompagne les étudiants dans leurs démarches et m'assure qu'ils aient toutes les ressources pour réussir. N'hésitez pas à venir me voir pour toute question ou besoin de conseil.",
                          photos: [],
                          // Liste de photos, à remplir si nécessaire
                          isTeacher: true,
                          phoneNumber: "+221 76 309 94 67",
                          linkedin: "/in/thierry-49",
                          position: "Assistant Labo CISCO",
                        ),
                      ],
                      placeName: "Bureau Mme Khadidiatou Diop",
                      shortDescription:
                      "Responsable CISCO, assistance pour les demandes de bourses et autres financements",
                      entityPosition: position,
                      // Position approximative; à ajuster si nécessaire
                      entityName: "Bureau Mme Khadidiatou Diop",
                      rating: "4.7/5",
                      floor: "Étage 0",
                      building: "Bat H",
                      timeDetail: "Ferme à 17h30",
                      about:
                      "N’hésitez pas à me contacter via Whatsapp si je ne suis pas joignable par appel téléphonique.",
                      isOpen: true,
                      photos: [
                        "assets/images/bureau_recouvrement.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      // Ajouter les photos disponibles ici
                      placeType: "Bureau",
                    )));
                break;

              case "Amicale":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Bureau amicale",
                      placeName: "Bureau amicale",
                      shortDescription: "Bureau de l'amicale",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.69973, -17.45105),
                      photos: [
                        "assets/images/bureau_amicale.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment H occupé par la classe HA1",
                      isOpen: true,
                      entityName: "Salle HA1",
                    )
                ));
                break;

              case "Salle E27":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E27",
                      shortDescription: "Salle en construction (MMTD1)",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "En construction",
                      entityPosition: LatLng(14.70021450435587, -17.4511881172657),
                      photos: [
                        "assets/images/salle_e27.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle E27 occupée par MMTD1, actuellement en construction.",
                      isOpen: false,
                      entityName: "Salle E27",
                    )
                ));
                break;

              case "Salle E26":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E26",
                      shortDescription: "Salle de classe occupée par LTI2A",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700309524665105, -17.45122231543064),
                      photos: [
                        "assets/images/salle_e26.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle E26 utilisée par la classe LTI2A.",
                      isOpen: true,
                      entityName: "Salle E26",
                    )
                ));
                break;

              case "Salle E25":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E25",
                      shortDescription: "Salle de classe occupée par LP3",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.70037924943911, -17.451102286577225),
                      photos: [
                        "assets/images/salle_e25.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle E25 utilisée par la classe LP3.",
                      isOpen: true,
                      entityName: "Salle E25",
                    )
                ));
                break;

              case "Salle E24":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E24",
                      shortDescription: "Salle de classe occupée par LMEN3",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700398058909201, -17.451035231351852),
                      photos: [
                        "assets/images/salle_e24.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle E24 utilisée par la classe LMEN3.",
                      isOpen: true,
                      entityName: "Salle E24",
                    )
                ));
                break;

              case "Salle E22-23":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E22-23",
                      shortDescription: "Salle de classe occupée par LTI2B",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700429840423974, -17.450936660170555),
                      photos: [
                        "assets/images/salle_e22_23.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle E22-23 utilisée par la classe LTI2B.",
                      isOpen: true,
                      entityName: "Salle E22-23",
                    )
                ));
                break;

              case "Salle mystere BATE E2 1":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle mystère",
                      shortDescription: "Salle mystérieuse au bâtiment E",
                      rating: "4.0",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Inconnu",
                      entityPosition: LatLng(14.70043827225364, -17.450782097876072),
                      photos: [
                        "assets/images/salle_mystere_bate_e2_1.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle mystérieuse, contenu et classe inconnus.",
                      isOpen: false,
                      entityName: "Salle mystère",
                    )
                ));
                break;


              case "Salle E11":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E11 - Électronique",
                      shortDescription: "Laboratoire d'electronique situé au bâtiment E (Mr Rabé).",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700095809986601, -17.450751587748528),
                      photos: [
                        "assets/images/salle_e11.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Laboratoire d'electronique situé au bâtiment E (Mr Rabé).",
                      isOpen: true,
                      entityName: "Salle E11",
                    )
                ));
                break;

              case "Salle E13":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E13",
                      shortDescription: "Salle de classe situé au bâtiment E, mystère, contenu inconnu",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700335468769655, -17.45076399296522),
                      photos: [
                        "assets/images/salle_e13.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E faisant office de Labo TP",
                      isOpen: true,
                      entityName: "Salle E13",
                    )
                ));
                break;

              case "Salle E14":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E14",
                      shortDescription: "Salle de classe situé au bâtiment E, mystère, contenu inconnu",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700469405160389, -17.450793161988262),
                      photos: [
                        "assets/images/salle_e14.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E faisant office de Labo TP",
                      isOpen: true,
                      entityName: "Salle E14",
                    )
                ));
                break;

              case "Salle E15":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Laboratoire",
                      placeName: "Salle E15",
                      shortDescription: "Laboratoire Feu Abdoulaye Sadou situé au bâtiment E, faisant office de Labo TP",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700419138485834, -17.450932636857033),
                      photos: [
                        "assets/images/salle_e15.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E faisant office de Labo TP",
                      isOpen: true,
                      entityName: "Salle E15",
                    )
                ));
                break;

              case "Salle E16":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E16",
                      shortDescription: "Salle de classe situé au bâtiment E, faisant office de Labo TP",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700374709221931, -17.451071441173553),
                      photos: [
                        "assets/images/salle_e16.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E faisant office de Labo TP",
                      isOpen: true,
                      entityName: "Salle E16",
                    )
                ));
                break;

              case "Salle E17":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E17",
                      shortDescription: "Salle de classe situé au bâtiment E, faisant office de Labo TP",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.70028098614654, -17.451208233833313),
                      photos: [
                        "assets/images/salle_e17.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E faisant office de Labo TP",
                      isOpen: true,
                      entityName: "Salle E17",
                    )
                ));
                break;

              case "Salle E18":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle E18",
                      shortDescription: "Salle de classe situé au bâtiment E occupé par la classe LMEN1",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment E",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.700207045422003, -17.45118040591478),
                      photos: [
                        "assets/images/salle_e18.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment E occupé par la classe LMEN1",
                      isOpen: true,
                      entityName: "Salle E18",
                    )
                ));
                break;

              case "Salle HA1":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HA1",
                      shortDescription: "Salle de classe situé au bâtiment H occupé par la classe LTI1",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.69973, -17.45105),
                      photos: [
                        "assets/images/salle_ha1.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment H occupé par la classe HA1",
                      isOpen: true,
                      entityName: "Salle HA1",
                    )
                ));
                break;

              case "Salle informatique DAR (SES)":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle informatique DAR (SES)",
                      shortDescription: "Salle dédiée aux cours d'informatique pour la section SES.",
                      rating: "4.3",
                      floor: "Étage 0",
                      building: "Bâtiment D",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699996573661137, -17.451602183282375),
                      photos: [
                        "assets/images/salle_dar.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle informatique DAR équipée pour les cours et travaux en informatique.",
                      isOpen: true,
                      entityName: "Salle informatique DAR (SES)",
                    )
                ));
                break;

              case "Salle de classe RT":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle de classe HB2",
                      shortDescription: "Salle de classe dédiée aux cours de la filière RT.",
                      rating: "4.1",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699910309367722, -17.45156731456518),
                      photos: [
                        "assets/images/salle_hb2.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour les cours de la filière RT.",
                      isOpen: true,
                      entityName: "Salle de classe HB2",
                    )
                ));
                break;

              case "Restaurant administration (Accès interdit)":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Restaurant",
                      placeName: "Restaurant administration",
                      shortDescription: "Restaurant réservé à l'administration.",
                      rating: "N/A",
                      floor: "Étage 0",
                      building: "Bâtiment principal",
                      timeDetail: "Accès interdit",
                      entityPosition: LatLng(14.700116565290788, -17.451326586306095),
                      photos: [
                        "assets/images/restaurant_admin.jpg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Restaurant réservé à l'administration, l'accès y est interdit pour les étudiants.",
                      isOpen: false,
                      entityName: "Restaurant admin",
                    )
                ));
                break;

              case "Salle de classe HB3":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle de classe HB3",
                      shortDescription: "Salle de classe située au bâtiment H, destinée aux cours généraux.",
                      rating: "4.0",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.69982599085251, -17.451537810266014),
                      photos: [
                        "assets/images/salle_hb3.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour les cours de la filière HB.",
                      isOpen: true,
                      entityName: "Salle de classe HB3",
                    )
                ));
                break;

              case "Gymnase":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Gymnase",
                      placeName: "Gymnase",
                      shortDescription: "Espace sportif pour les activités physiques et sportives.",
                      rating: "4.6",
                      floor: "Étage 0",
                      building: "Bâtiment Sportif",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699498769844816, -17.451488524675373),
                      photos: [
                        "assets/images/gymnase_esmt.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Gymnase pour les entraînements et compétitions sportives.",
                      isOpen: true,
                      entityName: "Gymnase",
                    )
                ));
                break;

              case "Salle de classe HB6":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle de classe HB6",
                      shortDescription: "Salle de classe située au bâtiment H pour divers cours.",
                      rating: "4.2",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699535091725156, -17.451366148889065),
                      photos: [
                        "assets/images/salle_hb6.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour les cours divers.",
                      isOpen: true,
                      entityName: "Salle de classe HB6",
                    )
                ));
                break;

              case "Salle de classe mystère (a côté HB6) HA7":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HA7",
                      shortDescription: "Salle mystère située près de HB6.",
                      rating: "3.8",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699569792087336, -17.451251484453678),
                      photos: [
                        "assets/images/salle_ha7.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour les cours.",
                      isOpen: true,
                      entityName: "Salle HA7",
                    )
                ));
                break;

              case "salle HA8?":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HA8",
                      shortDescription: "Salle de classe située au bâtiment H.",
                      rating: "4.1",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699631409539332, -17.451135143637657),
                      photos: [
                        "assets/images/salle_ha8.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour divers cours.",
                      isOpen: true,
                      entityName: "Salle HA8",
                    )
                ));
                break;

              case "salle HB1":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HB1",
                      shortDescription: "Salle de classe HB1 pour les cours divers.",
                      rating: "4.0",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.7000585152944, -17.451403364539146),
                      photos: [
                        "assets/images/salle_hb1.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe pour les étudiants de HB1.",
                      isOpen: false,
                      entityName: "Salle HB1",
                    )
                ));
                break;

              case "salle mystère admin":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle mystère",
                      placeName: "Salle mystère admin",
                      shortDescription: "Salle mystère pour l'administration.",
                      rating: "N/A",
                      floor: "Étage 0",
                      building: "Bâtiment administratif",
                      timeDetail: "Accès réservé",
                      entityPosition: LatLng(14.699995600755758, -17.451235055923462),
                      photos: [
                        "assets/images/salle_admin_mystere_resto.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle administrative dont l'accès est limité.",
                      isOpen: false,
                      entityName: "Salle mystère admin",
                    )
                ));
                break;

              case "salle HB9 - Cyber":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      
                      placeType: "Salle de classe",
                      placeName: "Salle Cyber - HB9",
                      shortDescription: "Salle HB9 dédiée aux cours de cyber.",
                      rating: "4.5",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.699784804489017, -17.451064065098763),
                      photos: [
                        "assets/images/salle_cyber.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle dédiée aux cours de cyber sécurité.",
                      isOpen: true,
                      entityName: "Salle Cyber - HB9",
                    )
                ));
                break;

              case "Salle HA3":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HA3",
                      shortDescription: "Salle de classe situé au bâtiment H occupé par la classe LMEN3",
                      rating: "4.2",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.6996, -17.45112),
                      photos: [
                        "assets/images/salle_ha3.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment H occupé par la classe LMEN3",
                      isOpen: true,
                      entityName: "Salle HA3",
                    )
                ));
                break;

              case "Salle HA5":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                    Classroom(
                      hasDetails: false,
                      placeType: "Salle de classe",
                      placeName: "Salle HA5",
                      shortDescription: "Salle de classe situé au bâtiment H occupé par la classe INGC3",
                      rating: "4.4",
                      floor: "Étage 0",
                      building: "Bâtiment H",
                      timeDetail: "Ouvert",
                      entityPosition: LatLng(14.69956, -17.45125),
                      photos: [
                        "assets/images/salle_ha5.jpeg",
                        "assets/images/place_placeholder.png",
                        "assets/images/esmt_3.png"
                      ],
                      about: "Salle de classe situé au bâtiment H occupé par la classe INGC3",
                      isOpen: true,
                      entityName: "Salle HA5",
                    )
                ));
                break;

              case "Salle HA6":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle HA6",
                        shortDescription:
                            "Salle de classe située au bâtiment H occupée par la classe MTM2",
                        rating: "4.2",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_ha6.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H occupée par la classe MTM2",
                        isOpen: true,
                        entityName: 'Salle HA6',
                      ),
                    ));
                break;

              case "Salle HA4":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle HA4",
                        shortDescription:
                            "Salle de classe située au bâtiment H occupée par la classe LMEN3",
                        rating: "4.1",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_ha4.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H occupée par la classe LMEN3",
                        isOpen: true,
                        entityName: 'Salle HA4',
                      ),
                    ));
                break;

              case "Bureau HA1":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Bureau",
                        placeName: "Bureau HA1",
                        shortDescription:
                            "Salle de classe située au bâtiment H, classe non spécifiée",
                        rating: "3.8",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/bureau_ha1.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H, classe non spécifiée",
                        isOpen: true,
                        entityName: 'Bureau HA1',
                      ),
                    ));
                break;

              case "Salle MP-SSI2":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle MP-SSI2",
                        shortDescription:
                            "Salle de classe située au bâtiment H occupée par la classe MP-SSI2",
                        rating: "4.0",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_mpssi2.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H occupée par la classe MP-SSI2",
                        isOpen: true,
                        entityName: 'Salle MP-SSI2',
                      ),
                    ));
                break;

              case "Salle MP-ISI2":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle MP-ISI2",
                        shortDescription:
                            "Salle de classe située au bâtiment H occupée par la classe MP-ISI2",
                        rating: "4.3",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_mpisi2.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H occupée par la classe MP-ISI2",
                        isOpen: true,
                        entityName: 'Salle MP-ISI2',
                      ),
                    ));
                break;

              case "Salle mystère":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle mystère",
                        shortDescription:
                            "Salle de classe située au bâtiment H, nom de la classe inconnu",
                        rating: "3.7",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_mystere_h1.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H, nom de la classe inconnu",
                        isOpen: true,
                        entityName: 'Salle mystère',
                      ),
                    ));
                break;

              case "Salle mystère 2":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                      Classroom(
                      hasDetails: false,
                        placeType: "Salle de classe",
                        placeName: "Salle mystère 2",
                        shortDescription: "Salle de classe située au bâtiment H, nom de la classe inconnu",
                        rating: "3.9",
                        floor: "Étage 0",
                        building: 'Bâtiment H',
                        timeDetail: 'Ouvert',
                        entityPosition: position,
                        photos: [
                          "assets/images/salle_finance_digit.jpeg",
                          "assets/images/place_placeholder.png",
                          "assets/images/esmt_3.png"
                        ],
                        about:
                            "Salle de classe située au bâtiment H, nom de la classe inconnu",
                        isOpen: true,
                        entityName: 'Salle mystère 2',
                      ),
                    ));
                break;

              case "Bureau service technique":
                context.read<MapBloc>().add(SetSelectedMapEntity(
                  Classroom(
                      hasDetails: false,
                    placeType: "Salle de classe",
                    placeName: "Bureau service technique",
                    shortDescription:
                    "Bureau service technique situé au batiment H",
                    rating: "3.7",
                    floor: "Étage 0",
                    building: 'Bâtiment H',
                    timeDetail: 'Ouvert',
                    entityPosition: position,
                    photos: [
                      "assets/images/bureau_service_technique.jpeg",
                      "assets/images/place_placeholder.png",
                      "assets/images/esmt_3.png"
                    ],
                    about:
                    "Salle de classe située au bâtiment H, nom de la classe inconnu",
                    isOpen: true,
                    entityName: 'Salle mystère',
                  ),
                ));
                break;

              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
                // Cas par défaut pour les markers qui ne sont pas des salles de classe
                break;
            }
          }
        });
  }

  Future<void> _initializeTextMarkersOfLevel12() async {
    List<Map<String, dynamic>> markerData = [

      // BAT E :

      {
        "markerId": "Salle E27",
        "rotation": -18.0,
        "position": LatLng(14.70021450435587, -17.4511881172657),
        "title": "Salle E27\n(MMTD1 - En construction)",
      },

      {
        "markerId": "Salle E26",
        "rotation": -18.0,
        "position": LatLng(14.700309524665105, -17.45122231543064),
        "title": "Salle E26\n(LTI2A)",
      },

      {
        "markerId": "Salle E25",
        "rotation": -18.0,
        "position": LatLng(14.70037924943911, -17.451102286577225),
        "title": "Salle E25\n(LP3)",
      },

      {
        "markerId": "Salle E24",
        "rotation": -18.0,
        "position": LatLng(14.700398058909201, -17.451035231351852),
        "title": "Salle E24\n(LMEN3)",
      },

      {
        "markerId": "Salle E22-23",
        "rotation": -18.0,
        "position": LatLng(14.700429840423974, -17.450936660170555),
        "title": "Salle E22-23\n(LTI2B)",
      },

      {
        "markerId": "Salle mystere BATE E2 1",
        "rotation": -18.0,
        "position": LatLng(14.70043827225364, -17.450782097876072),
        "title": "Salle mystère",
      },

      {
        "markerId": "Terrasse BATE E2 1",
        "rotation": 73.0,
        "position": LatLng(14.70030530874783, -17.45075024664402),
        "title": "Terrasse\n(accès interdit)",
      },
      // BAT H :


      {
        "markerId": "Salle informatique DAR (SES)",
        "position": LatLng(14.699996573661137, -17.451602183282375),
        "title": "Salle informatique DAR \n(SES)",
        "rotation": -20.0,
      },
      {
        "markerId": "Salle de classe RT",
        "position": LatLng(14.699910309367722, -17.45156731456518),
        "title": "Salle de classe HB2",
        "rotation": -20.0,
      },
      {
        "markerId": "Restaurant administration \n(Accès interdit)",
        "position": LatLng(14.700116565290788, -17.451326586306095),
        "title": "Restaurant admin",
        "rotation": -20.0,
      },
      {
        "markerId": "Salle de classe HB3",
        "position": LatLng(14.69982599085251, -17.451537810266014),
        "title": "Salle de classe HB3",
        "rotation": -20.0,
      },
      {
        "markerId": "Gymnase",
        "position": LatLng(14.699498769844816, -17.451488524675373),
        "title": "Gymnase",
        "rotation": -20.0,
      },
      {
        "markerId": "Salle de classe HB6",
        "position": LatLng(14.699535091725156, -17.451366148889065),
        "title": "Salle HB6",
        "rotation": -20.0,
      },
      {
        "markerId": "Salle de classe mystère (a côté HB6) HA7",
        "position": LatLng(14.699569792087336, -17.451251484453678),
        "title": "Salle HA7",
        "rotation": -20.0,
      },
      {
        "markerId": "salle HA8?",
        "position": LatLng(14.699631409539332, -17.451135143637657),
        "title": "Salle HA8",
        "rotation": 73.0,
      },
      {
        "markerId": "salle HB1",
        "position": LatLng(14.7000585152944, -17.451403364539146),
        "title": "Salle HB1",
        "rotation": 73.0,
      },
      {
        "markerId": "salle mystère admin",
        "position": LatLng(14.699995600755758, -17.451235055923462),
        "title": "Salle mystère",
        "rotation": 73.0,
      },
      {
        "markerId": "salle HB9 - Cyber",
        "position": LatLng(14.699784804489017, -17.451064065098763),
        "title": "Salle Cyber - HB9",
        "rotation": 73.0,
      },
      // Vous pouvez ajouter plus de marqueurs ici
    ];

    for (var data in markerData) {
      Marker marker = await createTextMarker(
        data["markerId"],
        data["rotation"],
        data["position"],
        data["title"],
      );
      setState(() {
        _levelOneMarkers2.add(marker);
      });
    }
  }

  Future<void> _initializeLevel1Markers() async {
    List<Marker> levelOneMarkers = [



      // BAT E :

      Marker(
        markerId: const MarkerId("Toilettes 1 BATE E1 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700361412871128, -17.45120957493782),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
            Restroom(
                      hasDetails: false,
              occupancyLevel: "Faible",
              urinalsAvailable: "Oui",
              cleanlinessLevel: "Très propre",
              placeName: "Toilettes 1 Batiment E (H/F)",
              shortDescription:
              "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
              entityPosition:
              LatLng(14.700361412871128, -17.45120957493782),
              entityName: "Toilettes mixte",
              rating: "4.5/5",
              floor: "Étage 0",
              building: "Bat E",
              timeDetail: "Ouvert H24",
              about:
              "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez de chaussée du bâtiment E, toujours prêtes à l'emploi.",
              isOpen: true,
              photos: [
                "assets/images/toilettes_e17.jpeg",
                "assets/images/place_placeholder.png",
                "assets/images/esmt_3.png"
              ],
              placeType: "Toilettes",
            ),
          ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 2 BATE E1 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700244340088812, -17.450708001852036),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
            Restroom(
                      hasDetails: false,
              occupancyLevel: "Faible",
              urinalsAvailable: "Oui",
              cleanlinessLevel: "Très propre",
              placeName: "Toilettes 2 Batiment E (H/F)",
              shortDescription:
              "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
              entityPosition:
              LatLng(14.700244340088812, -17.450708001852036),
              entityName: "Toilettes mixte",
              rating: "4.5/5",
              floor: "Étage 0",
              building: "Bat E",
              timeDetail: "Ouvert H24",
              about:
              "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez de chaussée du bâtiment E, toujours prêtes à l'emploi.",
              isOpen: true,
              photos: [
                "assets/images/toilettes_e11.jpeg",
                "assets/images/place_placeholder.png",
                "assets/images/esmt_3.png"
              ],
              placeType: "Toilettes",
            ),
          ));
        },
      ),


      // BAT H :

      // -- Another level

      Marker(
        markerId: const MarkerId("Toilettes 6 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700027706630838, -17.45155222713947),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 6 (H/F)",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.700027706630838, -17.45155222713947),
                  entityName: "Toilettes mixte",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_7_homme.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 7 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700059488199502, -17.451249808073044),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 7 (H/F)",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.700059488199502, -17.451249808073044),
                  entityName: "Toilettes mixte",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_7_bat_h.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 5 (F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700027706630838, -17.45155222713947),
        icon: icons["toilettes_femme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 7 (Femme)",
                  shortDescription:
                      "Sanitaires modernes, accessibles aux femmes. Ces toilettes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.700027706630838, -17.45155222713947),
                  entityName: "Toilettes femme",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes femme sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 5 (F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69977377821716, -17.45155993849039),
        icon: icons["toilettes_femme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 5 (Femme)",
                  shortDescription:
                      "Sanitaires modernes, accessibles aux femmes. Ces toilettes sont bien entretenues et offrent un accès universel.",
                  entityPosition: LatLng(14.69977377821716, -17.45155993849039),
                  entityName: "Toilettes femme",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes femme sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_5_bat_h.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 4 (H)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69970924208541, -17.451542168855667),
        icon: icons["toilettes_homme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 7 (Homme)",
                  shortDescription:
                      "Sanitaires modernes, accessibles aux hommes. Ces toilettes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.69970924208541, -17.451542168855667),
                  entityName: "Toilettes homme",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes homme sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_7_homme.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 3.5 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699574008018823, -17.451526410877705),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 7 (H/F)",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.699574008018823, -17.451526410877705),
                  entityName: "Toilettes mixte",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_7_bat_h.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 3 (ADMIN)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699535416027642, -17.45149791240692),
        icon: icons["toilette_mixte_locked.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 3 (ADMIN)",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.699535416027642, -17.45149791240692),
                  entityName: "Toilettes mixte (ADMIN)",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Accès interdit",
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: false,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 4 (F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699616167329145, -17.451066747307777),
        icon: icons["toilettes_femme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  placeName: "Toilettes 4 (H/F)",
                  shortDescription:
                      "Sanitaires modernes, accessibles aux femmes et hommes. Ces toilettes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.699616167329145, -17.451066747307777),
                  entityName: "Toilettes mixte)",
                  rating: "4.5/5",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment H, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes_4_bat_h.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),


    ];

    setState(() {
      _levelOneMarkers.addAll(levelOneMarkers);
      // _levelThreeMarkers.addAll(levelThreeMarkers);
    });
  }

  Future<void> _initializeLevel1Markers2() async {
    List<Marker> levelOneMarkers2 = [
      // -- Another level

      // BAT E :

      Marker(
        markerId: const MarkerId("Toilettes 3 BATE E1 (H/F)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700492754837532, -17.45080053806305),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
            Restroom(
                      hasDetails: false,
              occupancyLevel: "Faible",
              urinalsAvailable: "Oui",
              cleanlinessLevel: "Très propre",
              placeName: "Toilettes 3 Batiment E (H/F)",
              shortDescription:
              "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
              entityPosition:
              LatLng(14.700492754837532, -17.45080053806305),
              entityName: "Toilettes mixte",
              rating: "4.5/5",
              floor: "Étage 1",
              building: "Bat E",
              timeDetail: "Ouvert H24",
              about:
              "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au 1er étage du bâtiment E, toujours prêtes à l'emploi.",
              isOpen: true,
              photos: [
                "assets/images/school_toilets.jpg",
                "assets/images/place_placeholder.png",
                "assets/images/esmt_3.png"
              ],
              placeType: "Toilettes",
            ),
          ));
        },
      ),

      // BAT H :

      Marker(
        markerId: const MarkerId("Toilettes 1 (H/F) 2F"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.7000348412691, -17.451549880206585),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible", // Peut être ajusté
                  urinalsAvailable: "Oui", // Peut être ajusté
                  cleanlinessLevel: "Bonne", // Peut être ajusté
                  rating: "4.2/5", // Peut être ajusté
                  placeName: "Toilettes 1 (H/F) 2F", // Nom basé sur le MarkerId
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition: LatLng(14.7000348412691,
                      -17.451549880206585), // Position basée sur le Marker
                  entityName: "Toilettes mixte",
                  floor: "Étage 1", // Constante
                  building: "Bat H", // Constante
                  timeDetail: "Ouvert H24", // Constante
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/toilettes1_2f_bat_h.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes", // Constante
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 2 (F) 2F"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69971248510756, -17.451538480818275),
        icon: icons["toilettes_femme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Modéré",
                  urinalsAvailable: "Non",
                  cleanlinessLevel: "Propre",
                  rating: "4.0/5",
                  placeName: "Toilettes 2 (F) 2F",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, féminin. Ces toilettes féminines sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.69971248510756, -17.451538480818275),
                  entityName: "Toilettes femme",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes féminines sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: false,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 3 (H) 2F"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699726430102261, -17.451483830809593),
        icon: icons["toilettes_homme.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Faible",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Très propre",
                  rating: "4.5/5",
                  placeName: "Toilettes 3 (H) 2F",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, masculin. Ces toilettes masculines sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.699726430102261, -17.451483830809593),
                  entityName: "Toilettes homme",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes masculines sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: false,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 4 (H/F) 2F"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699630112329993, -17.45129305869341),
        icon: icons["toilette_mixte.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Élevé",
                  urinalsAvailable: "Oui",
                  cleanlinessLevel: "Correct",
                  rating: "3.8/5",
                  placeName: "Toilettes 4 (H/F) 2F",
                  shortDescription:
                      "Sanitaires modernes, accessibles à tous, mixtes. Ces toilettes mixtes sont bien entretenues et offrent un accès universel.",
                  entityPosition:
                      LatLng(14.699630112329993, -17.45129305869341),
                  entityName: "Toilettes mixte",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Ouvert H24",
                  about:
                      "Ces toilettes mixtes sont bien entretenues et offrent un accès universel. Elles se situent au rez-de-chaussée du bâtiment G, toujours prêtes à l'emploi.",
                  isOpen: true,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),

      Marker(
        markerId: const MarkerId("Toilettes 6 - 2n stair (ADMIN)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700061109707981, -17.451248802244663),
        icon: icons["toilette_mixte_locked.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
                Restroom(
                      hasDetails: false,
                  occupancyLevel: "Indisponible",
                  urinalsAvailable: "Non",
                  cleanlinessLevel: "Inconnu",
                  rating: "N/A",
                  placeName: "Toilettes 6 - 2n stair (ADMIN)",
                  shortDescription:
                      "Sanitaires administratifs, accès restreint, mixtes. Toilettes bien entretenues et accessibles uniquement au personnel.",
                  entityPosition:
                      LatLng(14.700061109707981, -17.451248802244663),
                  entityName: "Toilettes mixte - Accès limité",
                  floor: "Étage 0",
                  building: "Bat H",
                  timeDetail: "Accès interdit",
                  about:
                      "Ces toilettes administratives mixtes sont bien entretenues et offrent un accès limité au personnel. Situées au rez-de-chaussée du bâtiment G.",
                  isOpen: false,
                  photos: [
                    "assets/images/school_toilets.jpg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Toilettes",
                ),
              ));
        },
      ),
    ];

    setState(() {
      _levelOneMarkers2.addAll(levelOneMarkers2);
      // _levelThreeMarkers.addAll(levelThreeMarkers);
    });
  }

  Future<void> _initializeLevel2Markers() async {
    List<Marker> levelTwoMarkers = [
      // - Points de prière :

      Marker(
        markerId: const MarkerId("Point prière 1 (vers resto)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700017004673004, -17.451315186917782),
        icon: icons["point_priere.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Tu peux venir prier ici 🫡",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      //  ---- Another level

      Marker(
        markerId: const MarkerId("Reprographie"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69949649972709, -17.45146505534649),
        icon: icons["salle_reprographie.png"]!,
        onTap: () {

          context.read<MapBloc>().add(SetSelectedMapEntity(
              Classroom(
                hasDetails: false,
                placeType: "Salle de classe",
                placeName: "Reprographie",
                shortDescription: "Reprographie de l'ESMT : Pour toutes vos impressions et photocopies veuillez...",
                rating: "4.5",
                floor: "Étage 0",
                building: "Bâtiment H",
                timeDetail: "Ouvert",
                entityPosition: LatLng(14.69949649972709, -17.45146505534649),
                photos: [
                  "assets/images/reprographie_esmt.jpeg",
                  "assets/images/place_placeholder.png",
                  "assets/images/esmt_3.png"
                ],
                about: "Salle de classe situé au bâtiment H occupé par la classe HA1",
                isOpen: true,
                entityName: "Salle HA1",
              )
          ));

          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Amicale"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699460177840324, -17.451517023146152),
        icon: icons["salle_amicale.png"]!,
        onTap: () {
          context.read<MapBloc>().add(SetSelectedMapEntity(
              Classroom(
                hasDetails: false,
                placeType: "Bureau amicale",
                placeName: "Bureau amicale",
                shortDescription: "Bureau de l'amicale",
                rating: "4.5",
                floor: "Étage 0",
                building: "Bâtiment H",
                timeDetail: "Ouvert",
                entityPosition: LatLng(14.699460177840324, -17.451517023146152),
                photos: [
                  "assets/images/bureau_amicale.jpeg",
                  "assets/images/place_placeholder.png",
                  "assets/images/esmt_3.png"
                ],
                about: "Salle de classe situé au bâtiment H occupé par la classe HA1",
                isOpen: true,
                entityName: "Salle HA1",
              )
          ));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 3"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700041327303694, -17.451469749212265),
        icon: icons["labo.png"]!,
        onTap: () {
          context.read<MapBloc>().add(const SetSelectedMapEntity(MainPlace(
              photos: [
                "assets/images/labo_telecom_bath_1.jpeg",
                "assets/images/place_placeholder.png",
                "assets/images/esmt_2.png",
                "assets/images/esmt_3.png"
              ],
              placeType: "Laboratoire",
              placeName: "Laboratoire Télécom",
              entityPosition: LatLng(14.700041327303694, -17.451469749212265),
              entityName: "Labo1-HE0",
              shortDescription:
              'dédié à la pratique des technologies telecom avec des équipements Cisco.',
              floor: "Étage 0",
              rating: '4.7/5',
              building: 'Bat H',
              timeDetail: 'Ferme à 14h',
              about: 'Test',
              isOpen: true, hasDetails: false)));

          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 2"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700004681205748, -17.45160486549139),
        icon: icons["labo.png"]!,
        onTap: () {
          context.read<MapBloc>().add(const SetSelectedMapEntity(MainPlace(
              photos: [
                "assets/images/labo_1.jpeg",
                "assets/images/place_placeholder.png",
                "assets/images/esmt_2.png",
                "assets/images/esmt_3.png"
              ],
              placeType: "Laboratoire",
              placeName: "Laboratoire Télécom",
              entityPosition:
              LatLng(14.700004681205748, -17.45160486549139),
              entityName: "Labo1-HE0",
              shortDescription:
              'dédié à la pratique des technologies telecom avec des équipements Cisco.',
              floor: "Étage 0",
              rating: '4.7/5',
              building: 'Bat H',
              timeDetail: 'Ferme à 14h',
              about: 'Test',
              isOpen: true, hasDetails: false)));
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 1"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699664488374792, -17.451476454734802),
        icon: icons["labo.png"]!,
        onTap: () {
          debugPrint("Tapped on labo 1");
          context.read<MapBloc>().add(const SetSelectedMapEntity(MainPlace(
                  photos: [
                    "assets/images/labo_cisco.jpeg",
                    "assets/images/labo_1.jpeg",
                    "assets/images/place_placeholder.png",
                    "assets/images/esmt_2.png",
                    "assets/images/esmt_3.png"
                  ],
                  placeType: "Laboratoire",
                  placeName: "Laboratoire Cisco",
                  entityPosition:
                      LatLng(14.699664488374792, -17.451476454734802),
                  entityName: "Labo1-HE0",
                  shortDescription:
                      'dédié à la pratique des technologies réseau avec des équipements Cisco.',
                  floor: "Étage 0",
                  rating: '4.7/5',
                  building: 'Bat H',
                  timeDetail: 'Ferme à 14h',
                  about: 'Test',
                  isOpen: true, hasDetails: true)));
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Resto"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700116889592406, -17.451324239373207),
        icon: icons["salle_restaurant.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Le restaurant sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Infirmerie"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699935604915927, -17.451586090028286),
        icon: icons["salle_infirmerie.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "L'infirmerie sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      // BAT E :

      Marker(
        markerId: const MarkerId("Labo 4 BATE E17"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700309848966432, -17.451219968497753),
        icon: icons["labo.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 3 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 5 BATE E16"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700397086005616, -17.451080828905106),
        icon: icons["labo.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 4 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 6 BATE E15"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.70044800128748, -17.450945377349854),
        icon: icons["labo.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 5 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Labo 7 BATE E13"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700343900602972, -17.450743541121483),
        icon: icons["labo.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 6 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),
      Marker(
        markerId: const MarkerId("Labo 8 BATE E11"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700126294338954, -17.450763322412968),
        icon: icons["labo.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 7 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),
    ];

    setState(() {
      _levelTwoMarkers.addAll(levelTwoMarkers);
      // _levelThreeMarkers.addAll(levelThreeMarkers);
    });
  }

  Future<void> _initializeLevel2Markers2() async {
    List<Marker> levelTwoMarkers2 = [
      // - Points de prière :

      Marker(
        markerId: const MarkerId("Point prière 1 (vers resto)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700017004673004, -17.451315186917782),
        icon: icons["point_priere.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Tu peux venir prier ici 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Point prière 2 (vers 4 bureaux)"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700050407751775, -17.451514676213264),
        icon: icons["point_priere.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Tu peux venir prier ici 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      //  ---- Another level

      Marker(
        markerId: const MarkerId("Incubateur"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69958600720797, -17.451496236026287),
        icon: icons["salle_incubateur.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "L'incubateur sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Biblio"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699652164887663, -17.451038919389248),
        icon: icons["salle_biblio.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "La bibliothèque sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Conference"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.699667082793065, -17.45149288326502),
        icon: icons["salle_conference.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "La salle de conf' sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),
    ];

    setState(() {
      _levelTwoMarkers2.addAll(levelTwoMarkers2);
      // _levelThreeMarkers.addAll(levelThreeMarkers);
    });
  }

  Future<void> _initializeLevel3Markers() async {
    List<Marker> levelThreeMarkers = [
      // -- Sorties :

      Marker(
        markerId: const MarkerId("Exit 1 BAT E"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.700066622836733, -17.450779750943184),
        icon: icons["exit.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      Marker(
        markerId: const MarkerId("Exit 1 BAT H"),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(14.69948158181005, -17.451396994292736),
        icon: icons["exit.png"]!,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Ce lieu sera disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
          // add(SetSelectedMapEntity(event.newMapEntity));
        },
      ),

      // -- Batiments :

      // Marker(
      //   markerId: const MarkerId("Batiment E"),
      //   anchor: const Offset(0.5, 0.5),
      //   position: LatLng(14.700240772773133, -17.450975216925144),
      //   icon: icons["bat_e.png"]!,
      //   onTap: () {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       buildCustomSnackBar(
      //         context,
      //
      //         SnackBarType.info,
      //         showCloseIcon: false,
      //       ),
      //     );
      //     // add(SetSelectedMapEntity(event.newMapEntity));
      //   },
      // ),
    ];

    setState(() {
      _levelThreeMarkers.addAll(levelThreeMarkers);
      // _levelThreeMarkers.addAll(levelThreeMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: (previous, current) {
        // Il y'a un bug par ici, entre current et previous, on verra plus tard.
        return current.selectedEntity != previous.selectedEntity
            // && previous.selectedEntity == null
            ;
      },
      listener: (context, mapState) {
        // Future<double> currentZoom = googleMapController.getZoomLevel();

        // if (mapState.selectedEntity != null) {
        //   googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
        //       LatLng(
        //         mapState.selectedEntity!.entityPosition
        //             .latitude, // Ajustez cette valeur pour déplacer le marqueur vers le haut
        //         mapState.selectedEntity!.entityPosition.longitude,
        //       ),
        //       15.0));
        // } else {
        //   googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        //       const CameraPosition(
        //           target: LatLng(14.727627230807412, -17.46136180417954),
        //           zoom: 13.0)));
        // }

        // googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //         target: LatLng(
        //                 mapState.selectedEntity!.entityPosition
        //                     .latitude, // Ajustez cette valeur pour déplacer le marqueur vers le haut
        //                 mapState.selectedEntity!.entityPosition.longitude,
        //               ),
        //         zoom: 16.0)));

        googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(
              mapState.selectedEntity!.entityPosition
                  .latitude, // Ajustez cette valeur pour déplacer le marqueur vers le haut
              mapState.selectedEntity!.entityPosition.longitude,
            ),
            21.0));
      },
      builder: (context, mapState) {
        return GoogleMap(
          myLocationButtonEnabled: false,
          padding: const EdgeInsets.only(bottom: 300),
          zoomControlsEnabled: false,
          trafficEnabled: widget.isTrafficModeEnabled,
          compassEnabled: false,
          mapToolbarEnabled: false,
          polygons: {
            ..._baseBuildingPolygons,
            if (widget.floorLevel == 0) ..._firstFloorPolygons,
            if (widget.floorLevel == 1) ..._secondFloorPolygons,
            // ...secondFloorPolygons,
          },
          onTap: (value) {
            debugPrint("New tap :" + value.toString());
          },
          // polylines: mapState.polylinesSet,
          polylines: {

            // Escaliers 1 (Bat A) :

            Polyline(
              polylineId: PolylineId('Ligne 1 Escalier 1 Bat A'),
              points: [
                LatLng(14.7001297, -17.4509429),
                LatLng(14.70014, -17.4509124),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 3 Escalier 1 Bat A'),
              points: [
                LatLng(14.700124, -17.4509415),
                LatLng(14.7001344, -17.450911),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 4 Escalier 1 Bat A'),
              points: [
                LatLng(14.7001292, -17.45091),
                LatLng(14.7001185, -17.4509388),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 5 Escalier 1 Bat A'),
              points: [
                LatLng(14.7001136, -17.4509365),
                LatLng(14.7001243, -17.4509073),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 6 Escalier 1 Bat A'),
              points: [
                LatLng(14.7001085, -17.4509356),
                LatLng(14.7001192, -17.4509061),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 7 Escalier 1 Bat A'),
              points: [
                LatLng(14.7001396, -17.4509306),
                LatLng(14.7001101, -17.4509195),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 2 Escalier 2 Bat A'),
              points: [
                LatLng(14.7000895, -17.4510602),
                LatLng(14.700095, -17.4510461),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 3 Escalier 2 Bat A'),
              points: [
                LatLng(14.7000788, -17.4510729),
                LatLng(14.7000896, -17.4510438),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 4 Escalier 2 Bat A'),
              points: [
                LatLng(14.7000745, -17.4510698),
                LatLng(14.7000842, -17.451042),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 5 Escalier 2 Bat A'),
              points: [
                LatLng(14.7000693, -17.4510681),
                LatLng(14.7000793, -17.4510397),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 6 Escalier 2 Bat A'),
              points: [
                LatLng(14.7000644, -17.4510654),
                LatLng(14.7000744, -17.4510383),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('Ligne 7 Escalier 2 Bat A'),
              points: [
                LatLng(14.700093864176718, -17.451062723994255),
                LatLng(14.700063379819838, -17.45104931294918)
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 2
            Polyline(
              polylineId: PolylineId('esc_9_ligne_2'),
              zIndex: 2,
              points: [
                LatLng(14.6999897, -17.4513381),
                LatLng(14.6999975, -17.4513528),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 3
            Polyline(
              polylineId: PolylineId('esc_9_ligne_3'),
              zIndex: 2,
              points: [
                LatLng(14.6999862, -17.4513387),
                LatLng(14.699993, -17.4513551),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 4
            Polyline(
              polylineId: PolylineId('esc_9_ligne_4'),
              zIndex: 2,
              points: [
                LatLng(14.6999865, -17.4513571),
                LatLng(14.6999845, -17.4513364),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 5
            Polyline(
              polylineId: PolylineId('esc_9_ligne_5'),
              zIndex: 2,
              points: [
                LatLng(14.699977, -17.4513562),
                LatLng(14.6999835, -17.4513317),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 8
            Polyline(
              polylineId: PolylineId('esc_9_ligne_8'),
              zIndex: 2,
              points: [
                LatLng(14.6999701, -17.4513485),
                LatLng(14.69998, -17.4513374),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 9
            Polyline(
              polylineId: PolylineId('esc_9_ligne_9'),
              zIndex: 2,
              points: [
                LatLng(14.6999642, -17.4513374),
                LatLng(14.69998, -17.4513344),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 10
            Polyline(
              polylineId: PolylineId('esc_9_ligne_10'),
              zIndex: 2,
              points: [
                LatLng(14.6999634, -17.4513291),
                LatLng(14.6999794, -17.451331),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 11
            Polyline(
              polylineId: PolylineId('esc_9_ligne_11'),
              zIndex: 2,
              points: [
                LatLng(14.6999665, -17.4513196),
                LatLng(14.6999803, -17.451328),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 12
            Polyline(
              polylineId: PolylineId('esc_9_ligne_12'),
              zIndex: 2,
              points: [
                LatLng(14.699972, -17.4513122),
                LatLng(14.6999826, -17.4513257),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 13
            Polyline(
              polylineId: PolylineId('esc_9_ligne_13'),
              zIndex: 2,
              points: [
                LatLng(14.6999842, -17.451323),
                LatLng(14.6999775, -17.4513065),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 14
            Polyline(
              polylineId: PolylineId('esc_9_ligne_14'),
              zIndex: 2,
              points: [
                LatLng(14.6999881, -17.451323),
                LatLng(14.6999875, -17.4513052),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 15
            Polyline(
              polylineId: PolylineId('esc_9_ligne_15'),
              zIndex: 2,
              points: [
                LatLng(14.6999927, -17.4513237),
                LatLng(14.6999979, -17.4513109),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 17
            Polyline(
              polylineId: PolylineId('esc_9_ligne_17'),
              zIndex: 2,
              points: [
                LatLng(14.6999972, -17.4513273),
                LatLng(14.700003, -17.4513164),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 9 : Ligne 21
            Polyline(
              polylineId: PolylineId('esc_9_ligne_21'),
              zIndex: 2,
              points: [
                LatLng(14.7000028, -17.4513488),
                LatLng(14.6999949, -17.4513371),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 (vers labo 2) :

            // Escaliers 8 : Ligne 6
            Polyline(
              polylineId: PolylineId('esc_8_ligne_6'),
              points: [
                LatLng(14.7000064, -17.4515258),
                LatLng(14.7000184, -17.4514916),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 7
            Polyline(
              polylineId: PolylineId('esc_8_ligne_7'),
              points: [
                LatLng(14.7000138, -17.4515275),
                LatLng(14.7000252, -17.4514943),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 8
            Polyline(
              polylineId: PolylineId('esc_8_ligne_8'),
              points: [
                LatLng(14.70002, -17.4515295),
                LatLng(14.7000317, -17.451497),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 9
            Polyline(
              polylineId: PolylineId('esc_8_ligne_9'),
              points: [
                LatLng(14.7000275, -17.4515325),
                LatLng(14.7000395, -17.4514993),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 10
            Polyline(
              polylineId: PolylineId('esc_8_ligne_10'),
              points: [
                LatLng(14.7000348, -17.4515352),
                LatLng(14.7000468, -17.4515027),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 11
            Polyline(
              polylineId: PolylineId('esc_8_ligne_11'),
              points: [
                LatLng(14.7000447, -17.4515382),
                LatLng(14.7000554, -17.451506),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 12
            Polyline(
              polylineId: PolylineId('esc_8_ligne_12'),
              points: [
                LatLng(14.7000518, -17.4515395),
                LatLng(14.7000631, -17.4515087),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 8 : Ligne 13
            Polyline(
              polylineId: PolylineId('esc_8_ligne_13'),
              points: [
                LatLng(14.7000049, -17.4515057),
                LatLng(14.7000633, -17.4515282),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 7 (vers bureau Hervé) :

            // Escaliers 7 : Ligne 2
            Polyline(
              polylineId: PolylineId('esc_7_ligne_2'),
              points: [
                LatLng(14.6997517, -17.4515517),
                LatLng(14.6997254, -17.4515417),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 7 : Ligne 4
            Polyline(
              polylineId: PolylineId('esc_7_ligne_4'),
              points: [
                LatLng(14.6997537, -17.4515467),
                LatLng(14.6997271, -17.4515366),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 7 : Ligne 3
            Polyline(
              polylineId: PolylineId('esc_7_ligne_3'),
              points: [
                LatLng(14.6997491, -17.4515594),
                LatLng(14.6997229, -17.45155),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 7 : Ligne 5
            Polyline(
              polylineId: PolylineId('esc_7_ligne_5'),
              points: [
                LatLng(14.6997326, -17.4515621),
                LatLng(14.6997423, -17.4515356),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 6 (HA1) :

            Polyline(
              polylineId: PolylineId('ligne_2_E6'),
              points: [
                LatLng(14.6998381, -17.4511071),
                LatLng(14.6998197, -17.4511011),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_3_E6'),
              points: [
                LatLng(14.6998401, -17.4511014),
                LatLng(14.6998219, -17.4510957),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_4_E6'),
              points: [
                LatLng(14.6998417, -17.4510954),
                LatLng(14.6998239, -17.4510897),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_5_E6'),
              points: [
                LatLng(14.6998437, -17.45109),
                LatLng(14.6998261, -17.4510833),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_6_E6'),
              points: [
                LatLng(14.6998459, -17.451084),
                LatLng(14.6998278, -17.4510766),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_7_E6'),
              points: [
                LatLng(14.6998482, -17.4510773),
                LatLng(14.6998304, -17.4510702),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_8_E6'),
              points: [
                LatLng(14.6998501, -17.4510709),
                LatLng(14.6998326, -17.4510635),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_9_E6'),
              points: [
                LatLng(14.6998524, -17.4510642),
                LatLng(14.6998349, -17.4510578),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_10_E6'),
              points: [
                LatLng(14.6998258, -17.4511104),
                LatLng(14.6998482, -17.4510464),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_11_E6'),
              points: [
                LatLng(14.6998544, -17.4510592),
                LatLng(14.6998453, -17.4510555),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 5 (coin prière) :

            Polyline(
              polylineId: PolylineId('ligne_50 E5'),
              points: [
                LatLng(14.6995797, -17.4510189),
                LatLng(14.6995998, -17.4509602),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_49 E5'),
              points: [
                LatLng(14.6995955, -17.4509723),
                LatLng(14.6995861, -17.4509683),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_48 E5'),
              points: [
                LatLng(14.6996037, -17.450983),
                LatLng(14.6995842, -17.450974),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_45 E5'),
              points: [
                LatLng(14.6995985, -17.4510008),
                LatLng(14.699579, -17.4509918),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_47 E5'),
              points: [
                LatLng(14.6996014, -17.4509901),
                LatLng(14.6995822, -17.450981),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_46 E5'),
              points: [
                LatLng(14.6995994, -17.4509961),
                LatLng(14.6995803, -17.4509871),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_44 E5'),
              points: [
                LatLng(14.6995965, -17.4510058),
                LatLng(14.6995774, -17.4509975),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_43 E5'),
              points: [
                LatLng(14.6995949, -17.4510112),
                LatLng(14.6995839, -17.4510068),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_2 E5'),
              points: [
                LatLng(14.6995913, -17.4510213),
                LatLng(14.6996098, -17.4509639),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // Escaliers 4 :

            // Ligne 8
            Polyline(
              polylineId: const PolylineId('Ligne 8 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996745, -17.4512094),
                const LatLng(14.6996778, -17.4512001),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 2
            Polyline(
              polylineId: const PolylineId('Ligne 2 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996483, -17.4511900),
                const LatLng(14.6996515, -17.4511801),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 3
            Polyline(
              polylineId: const PolylineId('Ligne 3 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996508, -17.4512026),
                const LatLng(14.6996576, -17.4511821),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 4
            Polyline(
              polylineId: const PolylineId('Ligne 4 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996573, -17.4512043),
                const LatLng(14.6996638, -17.4511842),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 5
            Polyline(
              polylineId: const PolylineId('Ligne 5 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996631, -17.4512063),
                const LatLng(14.69967, -17.4511859),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 6
            Polyline(
              polylineId: const PolylineId('Ligne 6 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996687, -17.451208),
                const LatLng(14.6996755, -17.4511876),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 7
            Polyline(
              polylineId: const PolylineId('Ligne 7 E4'),
              zIndex: 3,
              points: [
                const LatLng(14.6996421, -17.4511879),
                const LatLng(14.6996845, -17.451202),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Escaliers 2 BAT E :

            Polyline(
              polylineId: PolylineId('ligne_1_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7004954, -17.4508689),
                LatLng(14.7004354, -17.4508487),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            Polyline(
              polylineId: PolylineId('ligne_2_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7004422, -17.4508642),
                LatLng(14.7004494, -17.45084),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            Polyline(
              polylineId: PolylineId('ligne_3_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7004529, -17.4508665),
                LatLng(14.7004604, -17.450843),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            Polyline(
              polylineId: PolylineId('ligne_4_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.700464, -17.4508709),
                LatLng(14.7004714, -17.4508471),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            Polyline(
              polylineId: PolylineId('ligne_5_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7004747, -17.4508749),
                LatLng(14.7004828, -17.4508511),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            Polyline(
              polylineId: PolylineId('ligne_6_e2_bate'),
              zIndex: 2,
              points: [
                LatLng(14.700488, -17.4508669),
                LatLng(14.7004919, -17.4508541),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),

            // BAT E : Escaliers 1

            Polyline(
              polylineId: PolylineId('ligne_1_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003959, -17.4511672),
                LatLng(14.7003382, -17.4511451),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_2_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003434, -17.4511615),
                LatLng(14.7003476, -17.4511487),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_3_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003538, -17.4511658),
                LatLng(14.7003625, -17.45114),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_4_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003648, -17.4511699),
                LatLng(14.7003735, -17.4511434),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_5_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003744, -17.4511736),
                LatLng(14.7003838, -17.4511477),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),
            Polyline(
              polylineId: PolylineId('ligne_6_e1_bate'),
              zIndex: 2,
              points: [
                LatLng(14.7003898, -17.4511655),
                LatLng(14.700394, -17.4511521),
              ],
              color: const Color(0XFFDCDCDE),
              width: 2,
            ),


            // Entree
            if (widget.floorLevel == 0) ...{
              Polyline(
                zIndex: 3,
                polylineId: const PolylineId('Entree E4'),
                points: [
                  const LatLng(14.6994893, -17.451368),
                  const LatLng(14.6994514, -17.4514837),
                  const LatLng(14.699518, -17.451505),
                  const LatLng(14.6995374, -17.4514453),
                  const LatLng(14.6994433, -17.4514123),
                ],
                color: Color(0XFFE6E1CE),
                width: 2,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildCustomSnackBar(
                      context,
                      "Fonctionnalité disponible prochainement 😉",
                      SnackBarType.info,
                      showCloseIcon: false,
                    ),
                  );
                },
              )
            },

            // Upstairs 1 :
            if (widget.floorLevel == 0) ...{
              Polyline(
                zIndex: 3,
                polylineId: const PolylineId('Up1L1'),
                points: [
                  const LatLng(14.6995775, -17.4512939),
                  const LatLng(14.6996047, -17.4513056),
                ],
                color: Color(0XFFDCDCDE),
                width: 2,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildCustomSnackBar(
                      context,
                      "Fonctionnalité disponible prochainement 😉",
                      SnackBarType.info,
                      showCloseIcon: false,
                    ),
                  );
                },
              ),
              Polyline(
                zIndex: 3,
                polylineId: const PolylineId('Up1L2'),
                points: [
                  const LatLng(14.699607, -17.4512993),
                  const LatLng(14.6995801, -17.4512875),
                ],
                color: Color(0XFFDCDCDE),
                width: 2,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildCustomSnackBar(
                      context,
                      "Fonctionnalité disponible prochainement 😉",
                      SnackBarType.info,
                      showCloseIcon: false,
                    ),
                  );
                },
              ),

            },

            Polyline(
              geodesic: false,
              visible: true,
              polylineId: const PolylineId('polygonId1'),
              points: [
                const LatLng(14.6974015, -17.4511063),
                const LatLng(14.6974327, -17.4510688),
                const LatLng(14.6989789, -17.4514228),
                const LatLng(14.6993058, -17.4514818),
                const LatLng(14.700354, -17.451793),
                const LatLng(14.700712, -17.4506557),
                const LatLng(14.7000893, -17.4504197),
                const LatLng(14.70009, -17.45039),
              ],
              width: 1,
              color: Colors.grey,
              endCap: Cap.roundCap,
              patterns: <PatternItem>[
                // Définit un motif de pointillés
                PatternItem.dash(20.0),
                PatternItem.gap(10.0),
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),


            // Upstairs 2 :
            // Ligne 6
            Polyline(
              polylineId: const PolylineId('Ligne 6'),
              points: [
                const LatLng(14.6995849, -17.4514773),
                const LatLng(14.6995969, -17.4514374),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 7
            Polyline(
              polylineId: const PolylineId('Ligne 7'),
              points: [
                const LatLng(14.6995772, -17.4514753),
                const LatLng(14.6995898, -17.4514364),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 8
            Polyline(
              polylineId: const PolylineId('Ligne 8'),
              points: [
                const LatLng(14.6995697, -17.4514729),
                const LatLng(14.699582, -17.4514324),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 9
            Polyline(
              polylineId: const PolylineId('Ligne 9'),
              points: [
                const LatLng(14.6995624, -17.4514707),
                const LatLng(14.6995749, -17.4514304),
              ],
              color: Color(0XFFF3BABA),
              width: 3,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Upstairs 3 :
            // Ligne 6
            Polyline(
              zIndex: 4,
              polylineId: const PolylineId('Ligne 6'),
              points: [
                const LatLng(14.6996136, -17.4513205),
                const LatLng(14.6996068, -17.4513396),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne X
            Polyline(
              zIndex: 4,
              polylineId: const PolylineId('Ligne X'),
              points: [
                const LatLng(14.699627, -17.451368),
                const LatLng(14.6996328, -17.4513495),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 2
            Polyline(
              zIndex: 4,
              polylineId: const PolylineId('Ligne 2'),
              points: [
                const LatLng(14.6996379, -17.451351),
                const LatLng(14.6996023, -17.4513373),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 3
            Polyline(
              polylineId: const PolylineId('Ligne 3'),
              points: [
                const LatLng(14.6996197, -17.4513653),
                const LatLng(14.6996304, -17.4513277),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 4
            Polyline(
              polylineId: const PolylineId('Ligne 4'),
              points: [
                const LatLng(14.6996133, -17.451363),
                const LatLng(14.6996243, -17.4513247),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // Ligne 5
            Polyline(
              polylineId: const PolylineId('Ligne 5'),
              points: [
                const LatLng(14.6996064, -17.4513599),
                const LatLng(14.6996188, -17.4513224),
              ],
              color: Color(0XFFDCDCDE),
              width: 2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            ),

            // ----------

            Polyline(
              geodesic: false,
              visible: true,
              polylineId: const PolylineId('polygonId2'),
              points: [
                const LatLng(14.70005, -17.45037),
                const LatLng(14.7000447, -17.4504048),
                const LatLng(14.6995751, -17.4502438),
                const LatLng(14.6994765, -17.4505979),
                const LatLng(14.6990471, -17.4504423),
                const LatLng(14.6992067, -17.4507789),
                const LatLng(14.6990354, -17.4513744),
                const LatLng(14.6974684, -17.4510096),
                const LatLng(14.697497, -17.4509747),
              ],
              width: 1,
              color: Colors.grey,
              endCap: Cap.roundCap,
              patterns: <PatternItem>[
                // Définit un motif de pointillés
                PatternItem.dash(20.0),
                PatternItem.gap(10.0),
              ],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildCustomSnackBar(
                    context,
                    "Fonctionnalité disponible prochainement 😉",
                    SnackBarType.info,
                    showCloseIcon: false,
                  ),
                );
              },
            )
          },
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target: mapState.selectedEntity != null
                  ? mapState.selectedEntity!.entityPosition
                  : (mapState.userCurrentLocation != null
                      ? mapState.userCurrentLocation!.userPos
                      : const LatLng(14.700120456910106, -17.45138894766569)),
              zoom: 19.0),
          onMapCreated: (gController) async {
            // mapBloc.add(SetGoogleMapController(gController));
            // setState(() {
            // });const Text("Hey")
            gController.setMapStyle(mapStyle);
            googleMapController = gController;
            // gMapCompleter.complete(gController);
          },
          onCameraMove: (newPos) {
            setState(() {
              zoomLevel = newPos.zoom;
            });

            debugPrint("Zoom level here :" + zoomLevel.toString());
          },
          markers: {
            // ..._levelThreeMarkers
            if (widget.floorLevel == 0) ...{
              if (zoomLevel > 20.5) ..._levelOneMarkers,
              if (zoomLevel > 19) ..._levelTwoMarkers,
              if (zoomLevel > 18.5) ..._levelThreeMarkers,
            },
            if (widget.floorLevel == 1) ...{
              if (zoomLevel > 20.5) ..._levelOneMarkers2,
              if (zoomLevel > 19) ..._levelTwoMarkers2,
              if (zoomLevel > 18.5) ..._levelThreeMarkers,
            },
            // .. giftsMarkers (no levels yet)
            ...mapState.gifts.map((gift) {
              return Marker(
                markerId: MarkerId(gift.giftId),
                anchor: const Offset(0.5, 0.5),
                position: LatLng(gift.lat, gift.lng),
                icon: _getIconForEvent(gift.event, icons),
                onTap: () {
                  context
                      .read<MapBloc>()
                      .add(SetSelectedMapEntity(GiftMapEntity(gift: gift, entityName: gift.title, entityPosition: LatLng(gift.lat, gift.lng))));
                  // add(SetSelectedMapEntity(event.newMapEntity));
                },
              );
            }).toSet()

          },
          mapType: MapType.normal,
        );
      },
    );
  }
}

class MapFloatingButton extends StatelessWidget {
  const MapFloatingButton({
    super.key,
    required this.iconUrl,
    required this.onTap,
    this.backgroundColor,
    required this.isUpper,
  });

  final String iconUrl;
  final Color? backgroundColor;
  final Function onTap;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1.5),
                color: Colors.black.withOpacity(.3))
          ]),
      child: Material(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => onTap(),
          child: Center(
            child: Image.asset(
              iconUrl,
              height: 22,
              width: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class FloorFloatingButton extends StatefulWidget {
  const FloorFloatingButton({
    super.key,
    required this.updateFloorLevel,
    required this.initialFloorLevel,
  });

  final Function(int level) updateFloorLevel;
  final int initialFloorLevel;

  @override
  _FloorFloatingButtonState createState() => _FloorFloatingButtonState();
}

class _FloorFloatingButtonState extends State<FloorFloatingButton> {
  late int localFloorLevel;

  @override
  void initState() {
    super.initState();
    // Initialiser localFloorLevel avec initialFloorLevel
    localFloorLevel = widget.initialFloorLevel;
  }

  void updateLocalFloorLevel(int level) {
    // Mettre à jour localement le floorLevel et appeler updateFloorLevel
    FirebaseEngine.logCustomEvent("update_map_floor_level", {"level":level.toString()});

    setState(() {
      localFloorLevel = level;
    });

    widget.updateFloorLevel(level);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1.5),
            color: Colors.black.withOpacity(.3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: localFloorLevel == 1 ? Color(0xFFE7E7E7) : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                onTap: () => updateLocalFloorLevel(1),
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: localFloorLevel == 0 ? Color(0xFFE7E7E7) : Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                onTap: () => updateLocalFloorLevel(0),
                child: Center(
                  child: Text(
                    "0",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetExpandableContent extends StatefulWidget {
  const BottomSheetExpandableContent({
    Key? key,
    required this.bsKey,
    required this.pagingController,
    required this.toggleDetailsPage, required this.toggleGiftsPage,
  }) : super(key: key);

  final PagingController<int, SearchHitEntity> pagingController;
  final GlobalKey<ExpandableBottomSheetState> bsKey;
  final Function(MainPlace detailsPage) toggleDetailsPage;
  final Function() toggleGiftsPage;
  @override
  State<BottomSheetExpandableContent> createState() =>
      _BottomSheetExpandableContentState();
}

class _BottomSheetExpandableContentState
    extends State<BottomSheetExpandableContent> {
  MapState oldMapState = const MapState();
  MapEntity? selectedMapEntity;
  bool isSearchModeEnabled = false;
  // final bool

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: (previous, current) {
        return current.searchHitsPage != previous.searchHitsPage ||
            current.selectedEntity != previous.selectedEntity ||
            current.isSearchModeEnabled != previous.isSearchModeEnabled;
      },
      listener: (context, mapState) {
        // Ceci est ce qui s'exécute lorsque la page de résultats de recherche change
        if (mapState.searchHitsPage != null &&
            mapState.searchHitsPage != oldMapState.searchHitsPage) {
          if (mapState.searchHitsPage!.pageKey == 0) {
            widget.pagingController.refresh();
          }
          widget.pagingController.appendPage(mapState.searchHitsPage!.items,
              mapState.searchHitsPage!.nextPageKey);
        }

        debugPrint("La différence est elle vraie : " +
            (mapState.selectedEntity != oldMapState.selectedEntity).toString());
        // Ceci est ce qui s'exécutait en temps normal tahu
        // Et pour éviter qu'à cause de l'ajout du custom oldMapState il ne s'exécute si les conditions requises sont présentes.
        if (mapState.selectedEntity != oldMapState.selectedEntity ||
            mapState.isSearchModeEnabled != oldMapState.isSearchModeEnabled) {
          debugPrint(
              "Map entity changed : " + mapState.selectedEntity.toString());

          if (mapState.isSearchModeEnabled) {
            if (mapState.selectedEntity == null) {
              widget.bsKey.currentState!.setMinExpandableHeight(0.06);
            } else {
              widget.bsKey.currentState!.setMinExpandableHeight(1.0);
            }
            // widget.bsKey.currentState!.setMaxExpandableHeight(
            //     newMax: 1.0,
            //     updateMax: () {
            //       setState(() {
            //         isSearchModeEnabled = mapState.isSearchModeEnabled;
            //       });
            //     });

            // J'ai encore du mal à comprendre mais il y'a un bug niveau update avec les animateTo;
            // J'utilise expand en attendant de pouvoir régler ça, c'est pas grave.
            widget.bsKey.currentState!.setMaxExpandableHeight(newMax: 1.0);
            widget.bsKey.currentState!.expand();
            setState(() {
              isSearchModeEnabled = mapState.isSearchModeEnabled;
            });
          } else {
            debugPrint("La recherche est désactivée");

            if (mapState.selectedEntity != null) {
              // Les changements d'étages sont différents en fonction des infoLevel d'où l'on vient.
              if (mapState.selectedEntity is Place) {
                widget.bsKey.currentState!.setMinExpandableHeight(0.15);
                widget.bsKey.currentState!.setMaxExpandableHeight(
                    newMax: 0.53,
                    updateMax: () {
                      setState(() {
                        if (isSearchModeEnabled != false) {
                          isSearchModeEnabled = false;
                        }
                        selectedMapEntity = mapState.selectedEntity;
                      });
                    });
              } else if (mapState.selectedEntity is Stop ||
                  mapState.selectedEntity is Bus) {
                widget.bsKey.currentState!.setMinExpandableHeight(0.53);
                widget.bsKey.currentState!.setMaxExpandableHeight(
                    newMax: 1.0,
                    updateMax: () {
                      setState(() {
                        if (isSearchModeEnabled != false) {
                          isSearchModeEnabled = false;
                        }
                        selectedMapEntity = mapState.selectedEntity;
                      });
                    },
                    animateTo: 0.53);
              } else if (mapState.selectedEntity is MainPlace) {
                debugPrint("This is height :" + 1.sh.toString());
                widget.bsKey.currentState!.setMinExpandableHeight(0.5);
                widget.bsKey.currentState!.setMaxExpandableHeight(
                    newMax: 0.5,
                    updateMax: () {
                      setState(() {
                        if (isSearchModeEnabled != false) {
                          isSearchModeEnabled = false;
                        }
                        selectedMapEntity = mapState.selectedEntity;
                      });
                    },
                    animateTo: 0.5);
              } else if (mapState.selectedEntity is GiftMapEntity) {
                debugPrint("In gift map entitiy mode");
                debugPrint("This is height :" + 1.sh.toString());
                widget.bsKey.currentState!.setMinExpandableHeight(0.5);
                widget.bsKey.currentState!.setMaxExpandableHeight(
                    newMax: 0.5,
                    updateMax: () {
                      setState(() {
                        if (isSearchModeEnabled != false) {
                          isSearchModeEnabled = false;
                        }
                        selectedMapEntity = mapState.selectedEntity;
                      });
                    },
                    animateTo: 0.5);
              }
            } else {
              widget.bsKey.currentState!.setMinExpandableHeight(0.06);
              widget.bsKey.currentState!.setMaxExpandableHeight(
                  newMax: 1.0,
                  animateTo: 0.06,
                  updateMax: () {
                    setState(() {
                      if (isSearchModeEnabled != false) {
                        isSearchModeEnabled = false;
                      }
                      selectedMapEntity = mapState.selectedEntity;
                    });
                  });
            }
          }
        }

        setState(() {
          oldMapState = mapState;
        });
      },
      builder: (context, mapState) {
        // Il faudrait une meilleure façon d'appeler ceci, dans le build ça va se répéter pour rien,
        // performances en patissent !
        return ValueListenableBuilder<SheetPositionPair>(
          valueListenable: widget.bsKey.currentState!.sheetPosition,
          builder: (context, sheetPosition, child) {
            return Container(
                constraints:
                    BoxConstraints(maxHeight: AppConstants.screenHeight),
                child: Container(
                    // margin: EdgeInsets.only(top: 35),
                    // width: 1.sw,
                    height: AppConstants.screenHeight +
                        MediaQuery.of(context).padding.top,
                    color: Colors.white,
                    child: isSearchModeEnabled || selectedMapEntity == null
                        ? sheetPosition.gSheetPosition >= 0.3
                            ? SearchScreenDisplayer(
                                onBackPressed: () {
                                  context
                                      .read<MapBloc>()
                                      .add(const SetSelectedMapEntity(null));
                                  // Navigator.of(context).pop();
                                },
                                blocState: mapState,
                                mapBloc: context.read<MapBloc>(),
                                sheetPosition: sheetPosition,
                                pagingController: widget.pagingController,
                                onTapSuggestion: (mapEntity, searchHitEntity) {
                                  if (searchHitEntity.entityType == "place") {
                                    context
                                        .read<MapBloc>()
                                        .add(const SetSelectedMapEntity(Place(
                                          entityName:
                                              'Ecole supérieure multinationale des télécommunications (ESMT)',
                                          placeName:
                                              'Ecole supérieure multinationale des télécommunications (ESMT)',
                                          entityPosition: LatLng(
                                              14.700029517700326,
                                              -17.451019219831917),
                                        )));
                                  } else if (searchHitEntity.entityType ==
                                      "stop") {
                                    context.read<MapBloc>().add(
                                          const SetSelectedMapEntity(
                                            Stop(
                                                entityName:
                                                    'Arrêt Dardanelles',
                                                stopName: 'Arrêt Dardanelles',
                                                entityPosition: LatLng(
                                                    14.695223067123997,
                                                    -17.44946546833327)),
                                          ),
                                        );
                                  } else {
                                    context.read<MapBloc>().add(
                                          const SetSelectedMapEntity(Bus(
                                              entityName:
                                                  "Ligne 001 - Dakar Dem Dikk",
                                              state: BusState.UNKNOWN,
                                              capacity: 45,
                                              line: Line(
                                                arrival: 'LECLERC',
                                                departure:
                                                    'PARCELLES ASSAINIES',
                                                lineNumber: "001",
                                                description:
                                                    'Cette ligne couvre la distance PARCELLES ASSAINIES-LECLERC',
                                                rating: 5,
                                                fareRange: '200-300',
                                                onwardShape: [
                                                  LatLng(14.76033717791818,
                                                      -17.438687495664922),
                                                  LatLng(14.763940762120395,
                                                      -17.441183406746163),
                                                  LatLng(14.762826227208505,
                                                      -17.446516269735618),
                                                  LatLng(14.75983177074642,
                                                      -17.44810450812752),
                                                  LatLng(14.758248455408173,
                                                      -17.44776497933181),
                                                  LatLng(14.756328841098107,
                                                      -17.44733680657224),
                                                  LatLng(14.754299800845413,
                                                      -17.446884226197255),
                                                  LatLng(14.750523231135967,
                                                      -17.446540219732984),
                                                  LatLng(14.750049793921685,
                                                      -17.44799082092741),
                                                  LatLng(14.7502938867721,
                                                      -17.44962752085666),
                                                  LatLng(14.750618183071591,
                                                      -17.451216308405563),
                                                  LatLng(14.751908674768655,
                                                      -17.45432092949277),
                                                  LatLng(14.751323779488551,
                                                      -17.45614723355753),
                                                  LatLng(14.750277612687961,
                                                      -17.45788510152128),
                                                  LatLng(14.746394954969995,
                                                      -17.466588512861758),
                                                  LatLng(14.744905821864554,
                                                      -17.46887636539269),
                                                  LatLng(14.740497732127464,
                                                      -17.471505759915615),
                                                  LatLng(14.735673214191454,
                                                      -17.473247964998105),
                                                  LatLng(14.729655629460476,
                                                      -17.472863237737428),
                                                  LatLng(14.72590576002534,
                                                      -17.471812771657483),
                                                  LatLng(14.722566078908324,
                                                      -17.471226477452866),
                                                  LatLng(14.719750523903995,
                                                      -17.47138906188038),
                                                  LatLng(14.712284520605824,
                                                      -17.471902590631213),
                                                  LatLng(14.709249652444962,
                                                      -17.471284811984475),
                                                  LatLng(14.70503495422966,
                                                      -17.470293948214813),
                                                  LatLng(14.700211986761264,
                                                      -17.468850235517714),
                                                  LatLng(14.695885291241627,
                                                      -17.465384372683875),
                                                  LatLng(14.69356583153468,
                                                      -17.46262004957258),
                                                  LatLng(14.691573627552767,
                                                      -17.460203620061222),
                                                  LatLng(14.689322117315578,
                                                      -17.457816311477483),
                                                  LatLng(14.686677185172137,
                                                      -17.45551296891371),
                                                  LatLng(14.683540150827751,
                                                      -17.452373935181324),
                                                  LatLng(14.68151197255026,
                                                      -17.450238695218715),
                                                  LatLng(14.679699854072759,
                                                      -17.4482861599848),
                                                  LatLng(14.678560024739568,
                                                      -17.447046170035282),
                                                  LatLng(14.675097340711405,
                                                      -17.443518609858753),
                                                  LatLng(14.670725088433215,
                                                      -17.440326509804457),
                                                  LatLng(14.669173822827892,
                                                      -17.43795000330283),
                                                  LatLng(14.6693667259859,
                                                      -17.434781353950044),
                                                  LatLng(14.669498559521607,
                                                      -17.432615841203198),
                                                  LatLng(14.669904854641885,
                                                      -17.43170395936341),
                                                  LatLng(14.6742458189469,
                                                      -17.43261082618835),
                                                  LatLng(14.673962216827931,
                                                      -17.43167132154245),
                                                  LatLng(14.671892986596275,
                                                      -17.42734131811217),
                                                  LatLng(14.67212311504506,
                                                      -17.42733760332219),
                                                ],
                                                lineId: 1,
                                              ),
                                              isAccessible: false,
                                              entityPosition: LatLng(
                                                  14.67212311504506,
                                                  -17.42733760332219))),
                                          // Ajoutez d'autres éléments de la liste ici
                                        );
                                  }
                                                                  context.read<MapBloc>().add(
                                      AddSearchHitToCache(
                                          searchHitEntity: searchHitEntity));
                                },
                                onChangeFilterState: (newValue) {
                                  debugPrint("Filter state changement !");
                                  context.read<MapBloc>().add(
                                      UpdateSearchFilterMode(
                                          newSearchFilterMode: newValue));
                                },
                              )
                            : const NearbyUserInfoDisplayer()
                        :
                        // selectedMapEntity != null
                        //       ?
                        selectedMapEntity is Place
                            ? PlaceInfoDisplayer(sheetPosition: sheetPosition)
                            : selectedMapEntity is Stop
                                ? StopInfoDisplayer(
                                    sheetPosition: sheetPosition)
                                : selectedMapEntity is Bus
                                    ? BusInfoDisplayer(
                                        sheetPosition: sheetPosition)
                                    : selectedMapEntity is GiftMapEntity
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ImageSwiper(
                                                  isLikeable: false,
                                                  images: ["assets/images/gifts_ad_image.png"],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  height: AppConstants
                                                              .screenWidth <=
                                                          360
                                                      ? 15
                                                      : 39,
                                                  child: Text(
                                                    (selectedMapEntity!
                                                                as GiftMapEntity)
                                                            .gift.title +
                                                        " : " +
                                                        (selectedMapEntity!
                                                        as GiftMapEntity)
                                                            .gift.description,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryText,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: AppConstants
                                                                    .screenWidth >=
                                                                360
                                                            ? 14
                                                            : 13),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: AppConstants
                                                                .screenWidth <=
                                                            360
                                                        ? 1
                                                        : 2,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: AppConstants
                                                              .screenWidth <=
                                                          360
                                                      ? 5
                                                      : 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Il ne te reste plus que :",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .secondaryText,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: AppConstants
                                                                      .screenWidth >=
                                                                  342
                                                              ? 14
                                                              : 13),
                                                    ),
                                                    CountdownTimerWidget(height: 30,)

                                                  ],
                                                ),
                                                SizedBox(
                                                  height: AppConstants
                                                              .screenWidth <=
                                                          360
                                                      ? 8
                                                      : 20,
                                                ),
                                                Material(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                  child: InkWell(
                                                    onTap: () {
                                                      widget.toggleGiftsPage();
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "En savoir plus",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    AppConstants.screenWidth >=
                                                                            342
                                                                        ? 15
                                                                        : 14),
                                                          ),
                                                          const SizedBox(
                                                            width: 7,
                                                          ),
                                                          Image.asset(
                                                            "assets/icons/direction.png",
                                                            height: 12,
                                                            width: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                          : selectedMapEntity is MainPlace
                                                ? Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  ImageSwiper(
                                                    isLikeable: false,
                                                    images: (selectedMapEntity!
                                                    as MainPlace)
                                                        .photos,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        top: 10),
                                                    height: AppConstants
                                                        .screenWidth <=
                                                        360
                                                        ? 15
                                                        : 39,
                                                    child: Text(
                                                      (selectedMapEntity!
                                                      as MainPlace)
                                                          .placeName +
                                                          " : " +
                                                          (selectedMapEntity!
                                                          as MainPlace)
                                                              .shortDescription,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primaryText,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontSize: AppConstants
                                                              .screenWidth >=
                                                              360
                                                              ? 14
                                                              : 13),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: AppConstants
                                                          .screenWidth <=
                                                          360
                                                          ? 1
                                                          : 2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppConstants
                                                        .screenWidth <=
                                                        360
                                                        ? 5
                                                        : 8,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${(selectedMapEntity! as MainPlace).floor}  • ${(selectedMapEntity! as MainPlace).placeType}",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .secondaryText,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            fontSize: AppConstants
                                                                .screenWidth >=
                                                                342
                                                                ? 14
                                                                : 13),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                            border: Border.all(
                                                                color: (selectedMapEntity!
                                                                as MainPlace)
                                                                    .isOpen
                                                                    ? AppColors
                                                                    .bootstrapGreen
                                                                    : AppColors
                                                                    .bootstrapRed)),
                                                        child: Text(
                                                          (selectedMapEntity!
                                                          as MainPlace)
                                                              .isOpen
                                                              ? "Ouvert"
                                                              : "Fermé",
                                                          style: TextStyle(
                                                              color: (selectedMapEntity!
                                                              as MainPlace)
                                                                  .isOpen
                                                                  ? AppColors
                                                                  .bootstrapGreen
                                                                  : AppColors
                                                                  .bootstrapRed,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              fontSize: 13),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: AppConstants
                                                        .screenWidth <=
                                                        360
                                                        ? 8
                                                        : 20,
                                                  ),
                                                  Material(
                                                    color: !(context
                                                        .read<
                                                        MapBloc>()
                                                        .state
                                                        .selectedEntity
                                                    as MainPlace)
                                                        .hasDetails
                                                        ? AppColors.secondaryText
                                                        : AppColors.primaryColor,
                                                    borderRadius:
                                                    BorderRadius.circular(17),
                                                    child: InkWell(
                                                      onTap: () {

                                                        FirebaseEngine.logCustomEvent("map_see_details_pressed", {"selected_entity":context
                                                            .read<
                                                            MapBloc>()
                                                            .state
                                                            .selectedEntity!.entityName});

                                                        if ((context
                                                            .read<
                                                            MapBloc>()
                                                            .state
                                                            .selectedEntity!
                                                        as MainPlace)
                                                            .placeType ==
                                                            "Laboratoire") {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                            buildCustomSnackBar(
                                                              context,
                                                              "Fonctionnalité disponible prochainement 😉",
                                                              SnackBarType.info,
                                                              showCloseIcon:
                                                              false,
                                                            ),
                                                          );
                                                        } else if (!(context
                                                            .read<
                                                            MapBloc>()
                                                            .state
                                                            .selectedEntity!
                                                        as MainPlace)
                                                            .hasDetails) {
                                                        } else {
                                                          widget.toggleDetailsPage(context
                                                              .read<MapBloc>()
                                                              .state
                                                              .selectedEntity
                                                          as MainPlace);
                                                        }
                                                        ;
                                                      },
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          17),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 14),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Text(
                                                              "Voir détails",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  fontSize:
                                                                  AppConstants.screenWidth >=
                                                                      342
                                                                      ? 15
                                                                      : 14),
                                                            ),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            Image.asset(
                                                              "assets/icons/direction.png",
                                                              height: 12,
                                                              width: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                        : const NearbyUserInfoDisplayer()

                    // : const NearbyUserInfoDisplayer(),
                    ));
          },
        );
      },
    );
  }
}

class BusInfoDisplayer extends StatefulWidget {
  const BusInfoDisplayer({Key? key, required this.sheetPosition})
      : super(key: key);

  final SheetPositionPair sheetPosition;

  @override
  State<BusInfoDisplayer> createState() => _BusInfoDisplayerState();
}

class _BusInfoDisplayerState extends State<BusInfoDisplayer> {
  bool status = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                AnimatedContainer(
                  height: widget.sheetPosition.gSheetPosition >= 0.95
                      ? MediaQuery.of(context).padding.top - 10
                      : 0,
                  duration: const Duration(milliseconds: 100),
                ),
                Row(
                  mainAxisAlignment: widget.sheetPosition.gSheetPosition > 0.6
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ligne 001 - Dakar Dem Dikk",
                      style: widget.sheetPosition.gSheetPosition > 0.6
                          ? const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 17,
                              fontWeight: FontWeight.w400)
                          : null,
                    ),
                    if (widget.sheetPosition.gSheetPosition > 0.6) ...[
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/filled_heart.png",
                            height: 15,
                            width: 15,
                          ),
                        ),
                      )
                    ]

                    // const SizedBox(
                    //   width: 15,
                    // ),
                  ],
                ),
                if (widget.sheetPosition.gSheetPosition > 0.6) ...[
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          children: const [
                            InfoCard(
                              title: "En circulation",
                              image: "assets/icons/valid_check.png",
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InfoCard(
                              title: "100 F - 350 F",
                              image: "assets/icons/fcfa_blue.png",
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InfoCard(
                              title: "50 places assises",
                              image: "assets/icons/seat_blue.png",
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InfoCard(
                              title: "Accessible",
                              image: "assets/icons/accessibility_blue.png",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ],
            ),
          ),
        ),
        RepaintBoundary(
          child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    dividerHeight: 0.0,
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 2.0, color: AppColors.primaryVar0),
                      // insets: EdgeInsets.symmetric(horizontal:-23.0)
                    ),
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColors.primaryVar0,
                    onTap: (index) {
                      if (index == 1) {}
                    },
                    tabs: [
                      Tab(
                        child: Text(
                          "Itinéraire",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize:
                                AppConstants.screenWidth >= 342 ? 14 : 12.5,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "À propos",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize:
                                  AppConstants.screenWidth >= 342 ? 14 : 12.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppConstants.screenHeight -
                        MediaQuery.of(context).padding.top,
                    child: TabBarView(
                      children: [
                        ListView(
                          primary: false,
                          padding: EdgeInsets.only(top: 15),
                          physics: widget.sheetPosition.gSheetPosition <= 0.6
                              ? NeverScrollableScrollPhysics()
                              : AlwaysScrollableScrollPhysics(),
                          children: [
                            if (widget.sheetPosition.gSheetPosition > 0.6) ...[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                height: 85,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        AppColors.lightYellow.withOpacity(.25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    Image.asset(
                                      "assets/icons/warning_yellow.png",
                                      height: 42,
                                      width: 42,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Déviation possible",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.bootstrapYellow),
                                          ),
                                          Text(
                                            "Veuillez parler au receveur avant de monter.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    AppColors.bootstrapYellow,
                                                fontSize: 12.5),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            const LineStop(
                              stopTitle: "Arrêt Yawou Dial",
                              stopAddress: "Proche de vous",
                              isNextStop: true,
                            ),
                            const LineStop(
                                stopTitle: "Clinique du cap",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Hôpital Le Dantec",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Clinique du cap",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Hôpital Le Dantec",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Clinique du cap",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Hôpital Le Dantec",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Clinique du cap",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                                stopTitle: "Hôpital Le Dantec",
                                stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                                isNextStop: false),
                            const LineStop(
                              stopTitle: "Clinique du cap",
                              stopAddress: "MH38+7C3, Av. Pasteur, Dakar",
                              isNextStop: false,
                              isFinal: true,
                            ),
                          ],
                        ),
                        // sheetPosition.gSheetPosition > 0.6 ?
                        SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                if (widget.sheetPosition.gSheetPosition <=
                                    0.6) ...[
                                  SizedBox(
                                    height: 30,
                                    child: ListView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      children: const [
                                        InfoCard(
                                          title: "En circulation",
                                          image: "assets/icons/valid_check.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InfoCard(
                                          title: "100 F - 350 F",
                                          image: "assets/icons/fcfa_blue.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InfoCard(
                                          title: "50 places assises",
                                          image: "assets/icons/seat_blue.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InfoCard(
                                          title: "Accessible",
                                          image:
                                              "assets/icons/accessibility_blue.png",
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SectionTitle(
                                    title: "Horaires de service",
                                    rightItem: FlutterSwitch(
                                      activeColor: AppColors.primaryVar0,
                                      inactiveColor: AppColors.secondaryVar0,
                                      activeText: "Aller",
                                      inactiveText: "Retour",
                                      activeTextFontWeight: FontWeight.normal,
                                      activeTextColor: Colors.white,
                                      inactiveTextFontWeight: FontWeight.normal,
                                      inactiveTextColor: Colors.white,
                                      width: 76.0,
                                      height: 30.0,
                                      valueFontSize: 12.0,
                                      toggleSize: 20.0,
                                      value: status,
                                      borderRadius: 30.0,
                                      padding: 4.0,
                                      activeIcon: Image.asset(
                                        "assets/icons/bus_onward.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                      inactiveIcon: Image.asset(
                                        "assets/icons/bus_backward.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                      showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          status = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20.0),
                                  constraints: BoxConstraints(minHeight: 150),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.4),
                                          blurRadius: 4.0, // soften the shadow
                                          spreadRadius: 0.3, //extend the shadow
                                          offset: Offset(
                                            0.0, // Move to right 10  horizontally
                                            0.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/clock_dark.png",
                                            height: 34,
                                            width: 34,
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 1.sw - 147,
                                                child: Text(
                                                    status
                                                        ? "Parcelles Assainies -> Leclerc"
                                                        : "Leclerc -> Parcelles Assainies",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 1.sw - 145,
                                                child: Text(
                                                    "33 minutes de trajet en moyenne",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: AppColors
                                                            .secondaryText)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      if (widget.sheetPosition.gSheetPosition >
                                          0.6) ...[
                                        const SizedBox(height: 7.0),
                                        LineSchedule(
                                            day: "lundi",
                                            schedule: status
                                                ? "05:00 - 22:38"
                                                : "05:30 - 21:45"),
                                        const SizedBox(height: 12.0),
                                        LineSchedule(
                                            day: "mardi",
                                            schedule: status
                                                ? "05:00 - 22:38"
                                                : "05:30 - 21:45"),
                                        const SizedBox(height: 12.0),
                                        LineSchedule(
                                            day: "mercredi",
                                            schedule: status
                                                ? "05:00 - 22:38"
                                                : "05:30 - 21:45"),
                                        const SizedBox(height: 12.0),
                                      ],
                                      LineSchedule(
                                          day: "jeudi (aujourd'hui)",
                                          schedule: "05:00 - 22:38"),
                                      const SizedBox(height: 12.0),
                                      LineSchedule(
                                          day: "vendredi",
                                          schedule: status
                                              ? "05:00 - 22:38"
                                              : "05:30 - 21:45"),
                                      if (widget.sheetPosition.gSheetPosition >
                                          0.6) ...[
                                        const SizedBox(height: 12.0),
                                        LineSchedule(
                                            day: "samedi",
                                            schedule: status
                                                ? "05:00 - 22:44"
                                                : "05:30 - 23:00"),
                                        const SizedBox(height: 12.0),
                                        LineSchedule(
                                            day: "dimanche",
                                            schedule: status
                                                ? "06:00 - 21:57"
                                                : "06:17 - 20:43"),
                                      ]
                                    ],
                                  ),
                                ),
                                if (widget.sheetPosition.gSheetPosition >
                                    0.6) ...[
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  SectionTitle(
                                    title: "Description",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "Cette ligne de bus relie le quartier de Hann à la Place de l'Indépendance, en passant par des arrêts stratégiques tels que le Monument de la Renaissance et l'Université Cheikh Anta Diop.",
                                      style: TextStyle(fontSize: 12)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SectionTitle(
                                          title: "Note et commentaires",
                                          subtitle:
                                              "Ce que pensent les gens de cette ligne",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MapEntityRating(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CommentSection(),
                                      ],
                                    ),
                                  )
                                ] else ...[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const EntityRating(),
                                ]
                              ],
                            ),
                          ),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: Column(
                        //     children: [
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       SizedBox(
                        //         height: 30,
                        //         child: ListView(
                        //           clipBehavior: Clip.none,
                        //           scrollDirection: Axis.horizontal,
                        //           children: const [
                        //             InfoCard(
                        //               title: "En activité",
                        //               image: "assets/icons/valid_check.png",
                        //             ),
                        //             SizedBox(
                        //               width: 10,
                        //             ),
                        //             InfoCard(
                        //               title: "Siège disponible",
                        //               image: "assets/icons/seat_blue.png",
                        //             ),
                        //             SizedBox(
                        //               width: 10,
                        //             ),
                        //             InfoCard(
                        //               title: "Accessible",
                        //               image:
                        //               "assets/icons/accessibility_blue.png",
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 15,
                        //       ),
                        //       const ImageSwiper(
                        //         isLikeable: false,
                        //         images: ["assets/images/arrêt_1.png","assets/images/arrêt_2.png","assets/images/arrêt_3.png"],
                        //       ),
                        //       const SizedBox(
                        //         height: 4,
                        //       ),
                        //       const EntityRating(),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}

class LineSchedule extends StatelessWidget {
  const LineSchedule({
    super.key,
    required this.day,
    required this.schedule,
  });

  final String day;
  final String schedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(day, style: const TextStyle(fontSize: 13)),
            Text(schedule, style: const TextStyle(fontSize: 13))
          ],
        ),
        Divider(
          thickness: 0.2,
          height: 0.8,
          color: AppColors.secondaryText,
        )
      ],
    );
  }
}

class LineStop extends StatelessWidget {
  const LineStop({
    super.key,
    required this.isNextStop,
    required this.stopTitle,
    required this.stopAddress,
    this.isFinal = false,
  });

  final bool isNextStop;
  final String stopTitle;
  final String stopAddress;
  final bool isFinal;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Fonctionnalité disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isNextStop
                                  ? AppColors.lightRed
                                  : AppColors.primaryVar1),
                        ),
                        if (!isFinal) ...[
                          Expanded(
                            child: Center(
                                child: Container(
                                    width: 1.0,
                                    color: isNextStop
                                        ? AppColors.lightRed
                                        : AppColors.primaryVar1)),
                          )
                        ]
                      ],
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stopTitle),
                        // const SizedBox(height: 10,),
                        Text(
                          stopAddress,
                          style: TextStyle(
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isNextStop) ...[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 1.0),
                    height: 33,
                    decoration: BoxDecoration(
                        color: AppColors.lightRed,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Image.asset(
                            "assets/icons/clock_white.png",
                            height: 17,
                            width: 17,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "6 mins",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        )
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StopInfoDisplayer extends StatelessWidget {
  const StopInfoDisplayer({
    super.key,
    required this.sheetPosition,
  });

  final SheetPositionPair sheetPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              AnimatedContainer(
                height: sheetPosition.gSheetPosition >= 0.95
                    ? MediaQuery.of(context).padding.top - 10
                    : 0,
                duration: const Duration(milliseconds: 100),
              ),
              Row(
                mainAxisAlignment: sheetPosition.gSheetPosition > 0.6
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icons/stop_empty.png",
                          width: sheetPosition.gSheetPosition > 0.6 ? 26 : 22,
                          height: sheetPosition.gSheetPosition > 0.6 ? 26 : 22),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Arrêt bus dardanelles",
                        style: sheetPosition.gSheetPosition > 0.6
                            ? const TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w400)
                            : null,
                      ),
                    ],
                  ),
                  if (sheetPosition.gSheetPosition > 0.6) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/filled_heart.png",
                          height: 15,
                          width: 15,
                        ),
                      ),
                    )
                  ]

                  // const SizedBox(
                  //   width: 15,
                  // ),
                ],
              ),
              if (sheetPosition.gSheetPosition > 0.6) ...[
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 30,
                      child: ListView(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        children: const [
                          InfoCard(
                            title: "En activité",
                            image: "assets/icons/valid_check.png",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InfoCard(
                            title: "Siège disponible",
                            image: "assets/icons/seat_blue.png",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InfoCard(
                            title: "Accessible",
                            image: "assets/icons/accessibility_blue.png",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ],
          ),
        ),
        RepaintBoundary(
          child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelPadding: EdgeInsets.zero,
                    dividerHeight: 0.0,
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 2.0, color: AppColors.primaryVar0),
                      // insets: EdgeInsets.symmetric(horizontal:-23.0)
                    ),
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColors.primaryVar0,
                    onTap: (index) {
                      if (index == 1) {}
                    },
                    tabs: [
                      Tab(
                        child: Text(
                          "Prochains départs",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  AppConstants.screenWidth >= 342 ? 14 : 12.5,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "À propos",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  AppConstants.screenWidth >= 342 ? 14 : 12.5,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppConstants.screenHeight - 270,
                    child: TabBarView(
                      children: [
                        ListView(
                          primary: false,
                          padding: EdgeInsets.only(top: 2),
                          physics: sheetPosition.gSheetPosition <= 0.6
                              ? NeverScrollableScrollPhysics()
                              : AlwaysScrollableScrollPhysics(),
                          children: const [
                            NextBusItemMarker(
                              busLine: '007',
                              busState: BusState.EMPTY,
                              busDest: 'Palais',
                              busCompany: 'Dakar Dem Dikk',
                              time: '05',
                              hour: '17:24',
                              isAccessible: true,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '217',
                              busState: BusState.HALFCROWDED,
                              busDest: 'Parcelles Assainies',
                              busCompany: 'GIE AFTU',
                              time: '25',
                              hour: '17:51',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '219',
                              busState: BusState.CROWDED,
                              busDest: 'Liberté 6',
                              busCompany: 'Dakar Dem Dikk',
                              time: '30',
                              hour: '17:56',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '319',
                              busState: BusState.CROWDED,
                              busDest: 'Hann Maristes',
                              busCompany: 'Dakar Dem Dikk',
                              time: '18:34',
                              hour: '18:34',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '049',
                              busState: BusState.UNKNOWN,
                              busDest: 'Liberté 6',
                              busCompany: 'Dakar Dem Dikk',
                              time: '18:34',
                              hour: '18:34',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '049',
                              busState: BusState.UNKNOWN,
                              busDest: 'Liberté 6',
                              busCompany: 'Dakar Dem Dikk',
                              time: '18:34',
                              hour: '18:34',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '049',
                              busState: BusState.UNKNOWN,
                              busDest: 'Liberté 6',
                              busCompany: 'Dakar Dem Dikk',
                              time: '18:34',
                              hour: '18:34',
                              isAccessible: false,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            NextBusItemMarker(
                              busLine: '049',
                              busState: BusState.UNKNOWN,
                              busDest: 'Liberté 6',
                              busCompany: 'Dakar Dem Dikk',
                              time: '18:34',
                              hour: '18:34',
                              isAccessible: false,
                            ),
                          ],
                        ),
                        // sheetPosition.gSheetPosition > 0.6 ?
                        SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                if (sheetPosition.gSheetPosition <= 0.6) ...[
                                  SizedBox(
                                    height: 30,
                                    child: ListView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      children: const [
                                        InfoCard(
                                          title: "En activité",
                                          image: "assets/icons/valid_check.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InfoCard(
                                          title: "Siège disponible",
                                          image: "assets/icons/seat_blue.png",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InfoCard(
                                          title: "Accessible",
                                          image:
                                              "assets/icons/accessibility_blue.png",
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                ],
                                const SizedBox(
                                  height: 10,
                                ),
                                ImageSwiper(
                                  isLikeable:
                                      sheetPosition.gSheetPosition <= 0.6,
                                  images: const [
                                    "assets/images/arrêt_2.png",
                                    "assets/images/arrêt_3.png",
                                    "assets/images/arrêt_1.png"
                                  ],
                                ),
                                if (sheetPosition.gSheetPosition > 0.6) ...[
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  SizedBox(
                                    width: AppConstants.screenWidth,
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SectionTitle(
                                            title: "Donnez votre avis",
                                            subtitle:
                                                "Partagez votre vécu pour aider les autres"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            StopContributeCard(
                                              icon:
                                                  "assets/icons/comment_rating_blue.png",
                                              title:
                                                  "Suggérer une modification",
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            StopContributeCard(
                                              icon:
                                                  "assets/icons/star_rating_blue.png",
                                              title:
                                                  "Attribuer une note à l'arrêt",
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SectionTitle(
                                          title: "Note et commentaires",
                                          subtitle:
                                              "Ce que pensent les gens de cet arrêt",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MapEntityRating(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CommentSection(),
                                      ],
                                    ),
                                  )
                                ] else ...[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const EntityRating(),
                                ]
                              ],
                            ),
                          ),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: Column(
                        //     children: [
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       SizedBox(
                        //         height: 30,
                        //         child: ListView(
                        //           clipBehavior: Clip.none,
                        //           scrollDirection: Axis.horizontal,
                        //           children: const [
                        //             InfoCard(
                        //               title: "En activité",
                        //               image: "assets/icons/valid_check.png",
                        //             ),
                        //             SizedBox(
                        //               width: 10,
                        //             ),
                        //             InfoCard(
                        //               title: "Siège disponible",
                        //               image: "assets/icons/seat_blue.png",
                        //             ),
                        //             SizedBox(
                        //               width: 10,
                        //             ),
                        //             InfoCard(
                        //               title: "Accessible",
                        //               image:
                        //               "assets/icons/accessibility_blue.png",
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 15,
                        //       ),
                        //       const ImageSwiper(
                        //         isLikeable: false,
                        //         images: ["assets/images/arrêt_1.png","assets/images/arrêt_2.png","assets/images/arrêt_3.png"],
                        //       ),
                        //       const SizedBox(
                        //         height: 4,
                        //       ),
                        //       const EntityRating(),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserComment(
          username: "Adji Sonko",
          userPicture: "assets/images/adji_sonko.png",
          userComment:
              "J'ai pris la ligne 007 plusieurs fois pour me déplacer à travers Dakar et je suis vraiment satisfait du service. Les bus sont généralement propres et bien entretenus...",
        ),
        SizedBox(
          height: 10,
        ),
        UserComment(
            username: "Ousmane Sarr",
            userPicture: "assets/images/ousmane_sarr.png",
            userComment:
                "En tant que personne handicapée, je suis ravi de constater à quel point la ligne 007 est accessible. Les bus sont équipés de rampes d'accès pour fauteuils roulants, ce qui facilite grandement...")
      ],
    );
  }

}

class UserComment extends StatelessWidget {

  const UserComment({
    super.key,
    required this.username,
    required this.userPicture,
    required this.userComment,
  });


  final String username;
  final String userPicture;
  final String userComment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(userPicture),
                        fit: BoxFit.cover,
                      ),
                      // color: Colors.blue,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.primaryVar0,
                              size: 17.0,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.primaryVar0,
                              size: 17.0,
                            ),
                            Icon(
                              Icons.star,
                              color: AppColors.primaryVar0,
                              size: 17.0,
                            ),
                            Icon(
                              Icons.star_half_outlined,
                              color: AppColors.primaryVar0,
                              size: 17.0,
                            ),
                            Icon(
                              Icons.star_border,
                              color: AppColors.primaryVar0,
                              size: 17.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("07/03/2023",
                            style: TextStyle(color: AppColors.secondaryText))
                      ],
                    ),
                  ],
                )
              ],
            ),
            Icon(
              Icons.more_vert,
              color: AppColors.secondaryText,
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        const SizedBox(
          height: 7,
        ),
        Text(userComment, style: const TextStyle(fontSize: 13))
      ],
    );
  }
}

class MapEntityRating extends StatelessWidget {
  const MapEntityRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        RatingsStars(),
        RatingsStats(),
      ],
    );
  }
}

class RatingsStars extends StatelessWidget {
  const RatingsStars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3, // 40% de la largeur disponible
      child: SizedBox(
        height: 100,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 95,
              width: 110,
              child: Stack(children: [
                const Text(
                  "4.7",
                  // textHeightBehavior: TextHeightBehavior(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 62,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  heightFactor: 4.3,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryVar0,
                        size: 17.0,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.primaryVar0,
                        size: 17.0,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.primaryVar0,
                        size: 17.0,
                      ),
                      Icon(
                        Icons.star_half_outlined,
                        color: AppColors.primaryVar0,
                        size: 17.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: AppColors.primaryVar0,
                        size: 17.0,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  heightFactor: 7,
                  child: Text(
                    "25.000 avis",
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText.withOpacity(.9)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingsStats extends StatelessWidget {
  const RatingsStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 5, // 70% de la largeur disponible
      child: SizedBox(
        height: 100,
        // color: Colors.green,
        child: Column(
          children: [
            RatingBar(ratingTitle: "5", ratingLevel: 0.8),
            SizedBox(height: 1),
            RatingBar(ratingTitle: "4", ratingLevel: 0.5),
            SizedBox(height: 1),
            RatingBar(ratingTitle: "3", ratingLevel: 0.3),
            SizedBox(height: 1),
            RatingBar(ratingTitle: "2", ratingLevel: 0.1),
            SizedBox(height: 1),
            RatingBar(ratingTitle: "1", ratingLevel: 0.1),
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.ratingLevel,
    required this.ratingTitle,
  });

  final double ratingLevel;
  final String ratingTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 7,
          child: Text(
            ratingTitle,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          height: 10,
          decoration: BoxDecoration(
              color: AppColors.secondaryText.withOpacity(.2),
              borderRadius: BorderRadius.circular(5)),
          child: FractionallySizedBox(
            widthFactor: ratingLevel,
            child: Container(
              // height: 12,
              decoration: BoxDecoration(
                  color: AppColors.primaryVar0,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ))
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {super.key, required this.title, this.subtitle, this.rightItem});

  final String title;
  final String? subtitle;
  final Widget? rightItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
            if (rightItem != null) ...[rightItem!]
          ],
        ),
        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: TextStyle(
                fontSize: 12,
                // fontWeight: FontWeight.w500,
                color: AppColors.secondaryText),
            textAlign: TextAlign.start,
          ),
        ]
      ],
    );
  }
}

class StopContributeCard extends StatelessWidget {
  const StopContributeCard({
    super.key,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 130,
        // width: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.3,
                  blurRadius: 5,
                  offset: const Offset(0, 1.5),
                  color: Colors.grey.withOpacity(.3))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 26,
              width: 26,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(title, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class BusIconInfo extends StatelessWidget {
  const BusIconInfo({
    super.key,
    required this.lineNumber,
    required this.busState,
  });

  final String lineNumber;
  final BusState busState;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: busState == BusState.EMPTY
              ? AppColors.bootstrapGreen
              : busState == BusState.CROWDED
                  ? AppColors.bootstrapRed
                  : busState == BusState.HALFCROWDED
                      ? AppColors.bootstrapYellow
                      : AppColors.secondaryText.withOpacity(.5)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1.7,
            child: Image.asset(
              // "assets/icons/single_bus_green.png",
              busState == BusState.EMPTY
                  ? "assets/icons/single_bus_green.png"
                  : busState == BusState.CROWDED
                      ? "assets/icons/single_bus_red.png"
                      : busState == BusState.HALFCROWDED
                          ? "assets/icons/single_bus_yellow.png"
                          : "assets/icons/single_bus_unknown.png",
              height: 18,
              width: 18,
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 25,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    lineNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 8, height: 0.8),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(.2),
      elevation: 4,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 16,
              width: 16,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: const TextStyle(height: 1.32),
            ),
          ],
        )),
      ),
    );
  }
}

class EntityRating extends StatelessWidget {
  const EntityRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: AppColors.primaryVar0,
              size: 20.0,
            ),
            Icon(
              Icons.star,
              color: AppColors.primaryVar0,
              size: 20.0,
            ),
            Icon(
              Icons.star,
              color: AppColors.primaryVar0,
              size: 20.0,
            ),
            Icon(
              Icons.star_half_outlined,
              color: AppColors.primaryVar0,
              size: 20.0,
            ),
            Icon(
              Icons.star_border,
              color: AppColors.primaryVar0,
              size: 20.0,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              "4.7/5",
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w400,
                  height: 1.8,
                  fontSize: 14),
            ),
          ],
        ),
        Text(
          "(25 avis)",
          style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w400,
              height: 1.8,
              fontSize: 14),
        ),
      ],
    );
  }
}

class NextBusItemMarker extends StatelessWidget {
  const NextBusItemMarker({
    super.key,
    required this.busLine,
    required this.busState,
    required this.busDest,
    required this.busCompany,
    required this.time,
    required this.hour,
    required this.isAccessible,
  });

  final String busLine;
  final BusState busState;
  final String busDest;
  final String busCompany;
  final String time;
  final String hour;
  final bool isAccessible;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            buildCustomSnackBar(
              context,
              "Fonctionnalité disponible prochainement 😉",
              SnackBarType.info,
              showCloseIcon: false,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BusIconInfo(
                            lineNumber: busLine,
                            busState: busState,
                          ),
                          // BusMarkerIcon(
                          //   lineNumber: busLine,
                          //   state: busState,
                          //   height: 40,
                          //   width: 40,
                          //   fontSize: 8.5,
                          // ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(busDest),
                              Row(
                                children: [
                                  Text(
                                    "$busCompany •",
                                    style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      " $hour",
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: AppColors.secondaryText,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13),
                                    ),
                                  ),
                                  if (isAccessible) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 2, left: 5, right: 3),
                                      child: Image.asset(
                                        "assets/icons/accessibility.png",
                                        height: 13,
                                        width: 13,
                                      ),
                                    ),
                                  ]
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      time.length > 2
                          ? Text(time,
                              style: const TextStyle(
                                  fontSize: 33,
                                  height: 0,
                                  fontWeight: FontWeight.w400))
                          : RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                  text: "$time \n",
                                  style: const TextStyle(
                                      fontSize: 33,
                                      height: 0.8,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  children: [
                                    TextSpan(
                                      text: "mins",
                                      style: TextStyle(
                                          color: AppColors.secondaryText,
                                          fontSize: 13),
                                    ),
                                  ]),
                            ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 18,
                color: AppColors.secondaryText,
                thickness: 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class Map extends StatelessWidget {
//   const Map(
//       {Key? key,
//       required this.bsKey,
//       this.foundPlace,
//       required this.gMapController,
//       required this.controller,
//       required this.mapStyle,
//       required this.setGMapController})
//       : super(key: key);
//
//   final GlobalKey<ExpandableBottomSheetState> bsKey;
//   final Place? foundPlace;
//   final GoogleMapController gMapController;
//   final Completer<GoogleMapController> controller;
//   final String mapStyle;
//   final Function(GoogleMapController controller) setGMapController;
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class NearbyUserInfoDisplayer extends StatelessWidget {
  const NearbyUserInfoDisplayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth,
      child: Column(
        children: [
          Text(
            "Vous êtes à l'ESMT",
            style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class PlaceInfoDisplayer extends StatelessWidget {
  const PlaceInfoDisplayer({
    super.key,
    required this.sheetPosition,
  });

  final SheetPositionPair sheetPosition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sheetPosition.gSheetPosition >= 0.16) ...[
            const ImageSwiper(
              isLikeable: true,
              images: [
                "assets/images/esmt_1.png",
                "assets/images/esmt_2.png",
                "assets/images/esmt_3.png"
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 39,
              child: Text(
                "Ecole Supérieure Multinationale Des Télécommunications (ESMT)",
                style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w400,
                    fontSize: AppConstants.screenWidth >= 342 ? 14 : 13),
              ),
            ),
            SizedBox(
              height: AppConstants.screenWidth >= 342 ? 8 : 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Ecole •",
                      style: TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: AppConstants.screenWidth >= 342 ? 14 : 13),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 2, left: 5, right: 3),
                      child: Image.asset(
                        "assets/icons/bus_grey.png",
                        height: 14,
                        width: 14,
                      ),
                    ),
                    Text(
                      "22 min",
                      style: TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: AppConstants.screenWidth >= 342 ? 14 : 13),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.bootstrapGreen)),
                  child: Text(
                    "Ouvert",
                    style: TextStyle(
                        color: AppColors.bootstrapGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.screenWidth >= 342 ? 20 : 8,
            ),
            Material(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(17),
              child: InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildCustomSnackBar(
                      context,
                      "Fonctionnalité disponible prochainement 😉",
                      SnackBarType.info,
                      showCloseIcon: false,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Itinéraires",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize:
                                AppConstants.screenWidth >= 342 ? 15 : 14),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset(
                        "assets/icons/direction.png",
                        height: 12,
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ] else ...[
            SizedBox(
              // width: AppConstants.screenWidth,
              height: 0.15 * (AppConstants.screenHeight - 130),
              // color: Colors.red,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/esmt_1.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15)
                        // color: Colors.blue,
                        ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        // width: 1.sw - 114,
                        child: Text(
                          "École supérieur multination...",
                          style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: AppColors.bootstrapGreen)),
                            child: Text(
                              "Ouvert",
                              style: TextStyle(
                                  color: AppColors.bootstrapGreen,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Ecole •",
                            style: TextStyle(
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 2, left: 5, right: 3),
                            child: Image.asset(
                              "assets/icons/bus_grey.png",
                              height: 14,
                              width: 14,
                            ),
                          ),
                          Text(
                            "22 min",
                            style: TextStyle(
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

class ImageSwiper extends StatefulWidget {
  const ImageSwiper({Key? key, required this.isLikeable, required this.images})
      : super(key: key);

  final bool isLikeable;
  final List<String> images;

  @override
  State<ImageSwiper> createState() => _ImageSwiperState();
}

class _ImageSwiperState extends State<ImageSwiper> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          // 1.sw >= 342 ? 1.sh * 0.14 :
          1.sh * 0.2,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length, // Number of images in the list
              itemBuilder: (context, index) {
                // Build a container for each image in the list
                return Container(
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget
                          .images[index]), // Use the image path from the list
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // child: PageView(
            //   controller: _controller,
            //   children: widget.images.map((e) => Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: AssetImage(e),
            //           fit: BoxFit.cover,
            //         ),
            //         // color: Colors.blue,
            //       ))).toList()
            // ),
          ),
          IgnorePointer(
            child: Container(
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.6),
                    Colors.transparent,
                    Colors.transparent
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          if (widget.isLikeable) ...[
            Positioned(
                top: 10,
                left: 10,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/icons/filled_heart.png",
                      height: 15,
                      width: 15,
                    ),
                  ),
                ))
          ],
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor:
                // 1.sw >= 342 ? 1.sh * 0.016 :
                1.sh * 0.0233,
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.images.length,
              effect: WormEffect(
                spacing: 4,
                dotColor: Colors.white.withOpacity(.9),
                activeDotColor: AppColors.primaryVar0,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BusMarkerIcon extends StatelessWidget {
  const BusMarkerIcon(
      {super.key,
      required this.lineNumber,
      required this.state,
      this.height,
      this.width,
      this.fontSize});

  final String lineNumber;
  final BusState state;
  final double? height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    String imagePath = "assets/images/empty_bus.png"; // Valeur par défaut

    if (state == BusState.CROWDED) {
      imagePath = "assets/images/crowded_bus.png";
    } else if (state == BusState.HALFCROWDED) {
      imagePath = "assets/images/half_crowded_bus.png";
    } else if (state == BusState.UNKNOWN) {
      imagePath = "assets/images/unknown_bus.png";
    }

    return SizedBox(
      height: height ?? 82,
      width: width ?? 78,
      child: Stack(
        children: [
          Image(
            image: AssetImage(imagePath),
            width: 82,
            height: 82,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lineNumber,
                style: TextStyle(
                    fontSize: fontSize ?? 15,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FloatingButtonsContainer extends StatelessWidget {
  const FloatingButtonsContainer({
    super.key,
    this.floatingButton1,
    this.floatingButton2,
    required this.isUpper,
  });

  final bool isUpper;
  final Widget? floatingButton1;
  final Widget? floatingButton2;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 110),
      child: Column(
        mainAxisAlignment:
            isUpper ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (floatingButton2 != null) ...[
            floatingButton2!,
          ],
          if (floatingButton1 != null) ...[
            const SizedBox(height: 15),
            floatingButton1!
          ]
        ],
      ),
    );
  }
}

class FloatingButtonsContainerReverso extends StatelessWidget {
  const FloatingButtonsContainerReverso({
    super.key,
    this.floatingButton1,
    this.floatingButton2,
    required this.bsKey,
    required this.isUpperButtonActive,
  });

  // final bool isUpper;
  final Widget? floatingButton1;
  final bool isUpperButtonActive;
  final GlobalKey<ExpandableBottomSheetState> bsKey;
  final Widget? floatingButton2;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SheetPositionPair>(
        valueListenable: bsKey.currentState!.sheetPosition,
        builder: (context, sheetPosition, child) {
          return SizedBox(
            height: 110,
            width: AppConstants.screenWidth,
            child: Stack(
              // mainAxisAlignment: isUpper ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (floatingButton2 != null) ...[
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      left: sheetPosition.gSheetPosition >= 0.50 &&
                              !isUpperButtonActive
                          ? -50.0
                          : 20.0,
                      child: floatingButton2!)
                ],
                if (floatingButton1 != null) ...[
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      top: 55,
                      left: sheetPosition.gSheetPosition >= 0.50 ? -50.0 : 20.0,
                      child: floatingButton1!)
                ]
              ],
            ),
          );
        });
  }
}
