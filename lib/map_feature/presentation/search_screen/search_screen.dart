import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/commons/theme/app_colors.dart';
import '../../../core/commons/utils/app_constants.dart';
import '../../../core/commons/utils/raw_explandable_bottom_sheet.dart';
import '../../../core/commons/utils/toolbox.dart';
import '../../../core/presentation/root_app_bar/root_app_bar.dart';
import '../../../map_feature/domain/model/bus.dart';
import '../../domain/model/line.dart';
import '../../../map_feature/domain/model/map_entity.dart';
import '../../domain/model/place.dart';
import '../../domain/model/product.dart';
import '../../domain/model/search_hit_entity.dart';
import '../../domain/model/stop.dart';
import '../map_screen/bloc/map_bloc.dart';
import '../map_screen/bloc/map_state.dart';
import '../map_screen/map_screen.dart';
import 'bloc/search_bloc.dart';
import 'bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider sert à rendre ton bloc accessible au sein d'un widget, utile quand
    // tu as seulement besoin d'accéder au state du bloc sans le modifier.
    return BlocProvider(
      create: (_) => SearchBloc(),
      // BlocBuilder en revanche te permet de pouvoir émettre des évènements avec ton bloc
      // Si tu ne met pas de bloc builder, ton widget ne va pas s'update si ton state change
      // Il est donc utile quand tu as besoin d'émettre de nouvelles valeurs.
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, searchState) {
          // Et enfin à l'intérieur tu peux accéder à ton Bloc :
          // .add() pour émettre un évènement et .state pour accéder à l'état avec ses attributs
          final searchBloc = context.read<SearchBloc>();

          return Scaffold(
            // backgroundColor: Colors.white.withOpacity(.5),
            appBar: RootAppBar(
              isActive: true,
              rootContext: context,
              onTextChanged: (String value) {
                // searchBloc.add(UpdatePrompt(newPrompt: value));
              },
              textValue: searchState.userPrompt,
            ),
            // body: SearchScreenDisplayer(),
          );
        },
      ),
    );
  }
}

class SearchScreenDisplayer extends StatefulWidget {
  // const SearchScreenDisplayer({Key? key}) : super(key: key);

  const SearchScreenDisplayer({
    super.key,
    required this.blocState,
    required this.onTapSuggestion,
    required this.sheetPosition,
    required this.pagingController, required this.onChangeFilterState, required this.mapBloc, required this.onBackPressed,
  });

  final MapState blocState;
  final MapBloc mapBloc;
  final SheetPositionPair sheetPosition;
  final PagingController<int, SearchHitEntity> pagingController;
  final Function(MapEntity? suggestedMapEntity, SearchHitEntity searchHitEntity) onTapSuggestion;
  final Function() onBackPressed;
  final Function(FilterValues filterValue) onChangeFilterState;

  @override
  State<SearchScreenDisplayer> createState() => _SearchScreenDisplayerState();
}

class _SearchScreenDisplayerState extends State<SearchScreenDisplayer> {


  // Widget _hits(BuildContext context) => PagedListView<int, SearchHitEntity>(
  //     pagingController: pagingController,
  //     builderDelegate: PagedChildBuilderDelegate<SearchHitEntity>(
  //         noItemsFoundIndicatorBuilder: (_) => const Center(
  //           child: Text('No results found'),
  //         ),
  //         itemBuilder: (_, item, __) => Container(
  //           color: Colors.white,
  //           height: 80,
  //           padding: const EdgeInsets.all(8),
  //           child: item.entityType == "stop"
  //               ? Text((item as SearchHitStop).stopName)
  //               : Text((item as SearchHitRoute).routeShortName),
  //         )));

  // Column(
  // children: [
  // Expanded(
  // child: _hits(context),
  // ),
  // // AnimatedContainer(
  // //   height: widget.sheetPosition.gSheetPosition >= 0.95 ? 42 : 0,
  // //   duration: const Duration(milliseconds: 100),
  // // ),
  // // Container(
  // //   color: AppColors.primaryVar2.withOpacity(.2),
  // //   height: 5,
  // // ),
  // // const SizedBox(
  // //   height: 18,
  // // ),
  // // Padding(
  // //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
  // //   child: Row(
  // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // //     crossAxisAlignment: CrossAxisAlignment.center,
  // //     children: [
  // //       Text(widget.blocState.userPrompt.isEmpty ? "Récents" : "Suggestions",
  // //           style: const TextStyle(
  // //               fontSize: 20, fontWeight: FontWeight.w500)),
  // //       Image.asset(
  // //           widget.blocState.userPrompt.isEmpty
  // //               ? "assets/icons/trash_outlined_maroon.png"
  // //               : "assets/icons/filter_outlined_maroon.png",
  // //           width: 26,
  // //           height: 26),
  // //     ],
  // //   ),
  // // ),
  // // const SizedBox(
  // //   height: 8,
  // // ),
  // // SizedBox(
  // //   // color: AppColors.bootstrapRed,
  // //   // margin: EdgeInsets.symmetric(horizontal: 25),
  // //   height: widget.blocState.userPrompt.isEmpty ? 1.sh - 340 : 220,
  // //   child: widget.blocState.userPrompt.isEmpty
  // //       ? const Column(
  // //           children: [
  // //             SizedBox(
  // //               height: 10,
  // //             ),
  // //             EntityHistory(
  // //               entityType: "place",
  // //               entityName: "Wakagoro Japanese Res...",
  // //               entityInfo: "Dakar, Ouakam",
  // //             ),
  // //             SizedBox(
  // //               height: 12,
  // //             ),
  // //             EntityHistory(
  // //               entityType: "stop",
  // //               entityName: "Marché Tilène",
  // //               entityInfo: "1 arrêt et 3 destinations trouvés",
  // //             ),
  // //             SizedBox(
  // //               height: 12,
  // //             ),
  // //             EntityHistory(
  // //               entityName: "Raftel island",
  // //             ),
  // //             SizedBox(
  // //               height: 12,
  // //             ),
  // //             EntityHistory(
  // //               entityType: "bus",
  // //               entityName: "bus 44 tata",
  // //               entityInfo: "1 ligne trouvée",
  // //             ),
  // //             SizedBox(
  // //               height: 12,
  // //             ),
  // //             EntityHistory(
  // //               entityName: "Mao Zedong",
  // //             ),
  // //             SizedBox(
  // //               height: 12,
  // //             ),
  // //             EntityHistory(
  // //               entityType: "place",
  // //               entityName: "ESMT",
  // //               entityInfo: "Dakar, Colobane",
  // //             ),
  // //
  // //             // NewsCard(),
  // //             // NewsCard(),
  // //             // Ajoutez d'autres éléments de la liste ici
  // //           ],
  // //         )
  // //       : ListView(
  // //           padding: EdgeInsets.zero,
  // //           scrollDirection: Axis.vertical,
  // //           children: [
  // //             SizedBox(
  // //               height: 10,
  // //             ),
  // //             EntitySuggestion(
  // //               entityType: "place",
  // //               entityName: "Ecole supérieure multi...",
  // //               entityAddress: "Dakar, Colobane",
  // //               onTapSuggestion: onTapSuggestion,
  // //               mapEntity: Place(
  // //                 entityName:
  // //                     'Ecole supérieure multinationale des télécommunications (ESMT)',
  // //                 placeName:
  // //                     'Ecole supérieure multinationale des télécommunications (ESMT)',
  // //                 entityPosition:
  // //                     LatLng(14.700029517700326, -17.451019219831917),
  // //               ),
  // //             ),
  // //             const SizedBox(
  // //               height: 10,
  // //             ),
  // //             EntitySuggestion(
  // //               entityType: "stop",
  // //               entityName: "Arrêt Dardanelles - TATA",
  // //               entityAddress: "Dakar, Sacré-Coeur",
  // //               onTapSuggestion: onTapSuggestion,
  // //               mapEntity: Stop(
  // //                   entityName: 'Arrêt Dardanelles',
  // //                   stopName: 'Arrêt Dardanelles',
  // //                   entityPosition: LatLng(
  // //                       14.695223067123997, -17.44946546833327)),
  // //             ),
  // //             const SizedBox(
  // //               height: 10,
  // //             ),
  // //             EntitySuggestion(
  // //                 entityType: "bus",
  // //                 entityName: "Ligne 001 - Dakar Dem Dikk",
  // //                 entityAddress: "Ouakam, Colobane",
  // //                 onTapSuggestion: onTapSuggestion,
  // //                 mapEntity: Bus(
  // //                     entityName: "Ligne 001 - Dakar Dem Dikk",
  // //                     state: BusState.UNKNOWN,
  // //                     capacity: 45,
  // //                     line: Line(
  // //                       arrival: 'LECLERC',
  // //                       departure: 'PARCELLES ASSAINIES',
  // //                       lineNumber: "001",
  // //                       description:
  // //                           'Cette ligne couvre la distance PARCELLES ASSAINIES-LECLERC',
  // //                       rating: 5,
  // //                       fareRange: '200-300',
  // //                       onwardShape: [
  // //                         LatLng(14.76033717791818, -17.438687495664922),
  // //                         LatLng(14.763940762120395, -17.441183406746163),
  // //                         LatLng(14.762826227208505, -17.446516269735618),
  // //                         LatLng(14.75983177074642, -17.44810450812752),
  // //                         LatLng(14.758248455408173, -17.44776497933181),
  // //                         LatLng(14.756328841098107, -17.44733680657224),
  // //                         LatLng(14.754299800845413, -17.446884226197255),
  // //                         LatLng(14.750523231135967, -17.446540219732984),
  // //                         LatLng(14.750049793921685, -17.44799082092741),
  // //                         LatLng(14.7502938867721, -17.44962752085666),
  // //                         LatLng(14.750618183071591, -17.451216308405563),
  // //                         LatLng(14.751908674768655, -17.45432092949277),
  // //                         LatLng(14.751323779488551, -17.45614723355753),
  // //                         LatLng(14.750277612687961, -17.45788510152128),
  // //                         LatLng(14.746394954969995, -17.466588512861758),
  // //                         LatLng(14.744905821864554, -17.46887636539269),
  // //                         LatLng(14.740497732127464, -17.471505759915615),
  // //                         LatLng(14.735673214191454, -17.473247964998105),
  // //                         LatLng(14.729655629460476, -17.472863237737428),
  // //                         LatLng(14.72590576002534, -17.471812771657483),
  // //                         LatLng(14.722566078908324, -17.471226477452866),
  // //                         LatLng(14.719750523903995, -17.47138906188038),
  // //                         LatLng(14.712284520605824, -17.471902590631213),
  // //                         LatLng(14.709249652444962, -17.471284811984475),
  // //                         LatLng(14.70503495422966, -17.470293948214813),
  // //                         LatLng(14.700211986761264, -17.468850235517714),
  // //                         LatLng(14.695885291241627, -17.465384372683875),
  // //                         LatLng(14.69356583153468, -17.46262004957258),
  // //                         LatLng(14.691573627552767, -17.460203620061222),
  // //                         LatLng(14.689322117315578, -17.457816311477483),
  // //                         LatLng(14.686677185172137, -17.45551296891371),
  // //                         LatLng(14.683540150827751, -17.452373935181324),
  // //                         LatLng(14.68151197255026, -17.450238695218715),
  // //                         LatLng(14.679699854072759, -17.4482861599848),
  // //                         LatLng(14.678560024739568, -17.447046170035282),
  // //                         LatLng(14.675097340711405, -17.443518609858753),
  // //                         LatLng(14.670725088433215, -17.440326509804457),
  // //                         LatLng(14.669173822827892, -17.43795000330283),
  // //                         LatLng(14.6693667259859, -17.434781353950044),
  // //                         LatLng(14.669498559521607, -17.432615841203198),
  // //                         LatLng(14.669904854641885, -17.43170395936341),
  // //                         LatLng(14.6742458189469, -17.43261082618835),
  // //                         LatLng(14.673962216827931, -17.43167132154245),
  // //                         LatLng(14.671892986596275, -17.42734131811217),
  // //                         LatLng(14.67212311504506, -17.42733760332219),
  // //                       ],
  // //                       lineId: 1,
  // //                     ),
  // //                     isAccessible: false,
  // //                     entityPosition: LatLng(14.67212311504506, -17.42733760332219))),
  // //             // Ajoutez d'autres éléments de la liste ici
  // //           ],
  // //         ),
  // // ),
  // // const SizedBox(
  // //   height: 15,
  // // ),
  // // Row(
  // //   mainAxisAlignment: MainAxisAlignment.center,
  // //   children: [
  // //     Text(
  // //       "Choisir sur la carte",
  // //       style: TextStyle(
  // //         fontSize: 14,
  // //         color: AppColors.secondaryVar0,
  // //         decoration: TextDecoration.underline,
  // //       ),
  // //     ),
  // //     const SizedBox(width: 7),
  // //     Image.asset(
  // //       "assets/icons/floating_map_maroon.png",
  // //       height: 20,
  // //       width: 20,
  // //     ),
  // //   ],
  // // )
  // ],
  // ),

  @override
  void dispose() {
    _selectedFilterNotifier.dispose();
    super.dispose();
  }


  final ValueNotifier<FilterValues> _selectedFilterNotifier = ValueNotifier(FilterValues.all);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            return Column(
              children: [
                AnimatedContainer(
                  height: widget.sheetPosition.gSheetPosition >= 0.95 ? 42 + MediaQuery.of(context).padding.top : 0,
                  duration: const Duration(milliseconds: 100),
                ),
                Container(
                  color: AppColors.primaryVar2.withOpacity(.2),
                  height: 5,
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.blocState.userPrompt.isEmpty ? "Récents" : "Suggestions",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      InkWell(
                        onTap: () {

                          if(widget.blocState.userPrompt.isEmpty){
                            // Vider les récents
                          }else{
                            showMenu(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Ajustez le borderRadius selon vos besoins
                              ),
                              elevation: 3.5,
                              position: RelativeRect.fromLTRB(300, 220, 30, 0), // Position du menu
                              items: [
                                PopupMenuItem(
                                  enabled: true,
                                  child: ValueListenableBuilder<FilterValues>(
                                    valueListenable: _selectedFilterNotifier,
                                    builder: (context, selectedFilter, child) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFilter == FilterValues.routes,
                                            onChanged: null, // Désactive la case à cocher
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0), // Ajustez la forme ici
                                            ),
                                            side: BorderSide(
                                              width: 0.8, // Ajustez la largeur de la bordure
                                            ),
                                          ),
                                          Text('Lignes (bus)'),
                                        ],
                                      );
                                    },
                                  ),
                                  onTap: (){
                                    _selectedFilterNotifier.value = FilterValues.routes;
                                    widget.onChangeFilterState(FilterValues.routes);

                                  },
                                ),
                                PopupMenuItem(
                                  enabled: true,
                                  child: ValueListenableBuilder<FilterValues>(
                                    valueListenable: _selectedFilterNotifier,
                                    builder: (context, selectedFilter, child) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFilter == FilterValues.stop,
                                            onChanged: null, // Désactive la case à cocher
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0), // Ajustez la forme ici
                                            ),
                                            side: BorderSide(
                                              width: 0.8, // Ajustez la largeur de la bordure
                                            ),
                                          ),
                                          Text('Arrêts'),
                                        ],
                                      );
                                    },
                                  ),
                                  onTap: (){
                                    _selectedFilterNotifier.value = FilterValues.stop;
                                    widget.onChangeFilterState(FilterValues.stop);

                                  },
                                ),
                                PopupMenuItem(
                                  child: ValueListenableBuilder<FilterValues>(
                                    valueListenable: _selectedFilterNotifier,
                                    builder: (context, selectedFilter, child) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFilter == FilterValues.places,
                                            onChanged: null, // Désactive la case à cocher
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0), // Ajustez la forme ici
                                            ),
                                            side: BorderSide(
                                              width: 0.8, // Ajustez la largeur de la bordure
                                            ),
                                          ),
                                          Text('Lieux'),
                                        ],
                                      );
                                    },
                                  ),
                                  onTap: (){
                                    _selectedFilterNotifier.value = FilterValues.places;
                                    widget.onChangeFilterState(FilterValues.places);

                                  },
                                ),
                                PopupMenuItem(
                                  child: ValueListenableBuilder<FilterValues>(
                                    valueListenable: _selectedFilterNotifier,
                                    builder: (context, selectedFilter, child) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: selectedFilter == FilterValues.all,
                                            onChanged: null, // Désactive la case à cocher
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2.0), // Ajustez la forme ici
                                            ),
                                            side: BorderSide(
                                              width: 0.8, // Ajustez la largeur de la bordure
                                            ),
                                          ),
                                          Text('Tous (par défaut)'),
                                        ],
                                      );
                                    },
                                  ),
                                  onTap: (){
                                    _selectedFilterNotifier.value = FilterValues.all;
                                    widget.onChangeFilterState(FilterValues.all);
                                  },
                                ),
                              ],
                            );
                          }
                        },
                        child: Image.asset(
                            widget.blocState.userPrompt.isEmpty
                                ? "assets/icons/trash_outlined.png"
                                : "assets/icons/filter_outlined.png",
                            width: 26,
                            height: 26),
                      ),

                    ],

                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.blocState.userPrompt.isEmpty ) ...[

                  if(widget.blocState.searchLoading.isHistoryLoading) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  ]else...[

                    SizedBox(
                    height: 365,
                    child: Material(
                        color: Colors.white,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: mapState.searchHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final suggestion = mapState.searchHistory[index];
                            return EntitySuggestion(
                                entitySuggestion: suggestion,
                                onTapSuggestion: widget.onTapSuggestion);
                            // } else {
                            //   // Retourner un conteneur vide pour exclure cet élément
                            //   // return Text("ez");
                            // }
                          },
                        )

                    ),
                  )
                  ]


                ] else ...[
                  if(widget.blocState.searchLoading.isSuggestionsLoading) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: 350,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  ]else if(widget.blocState.filteredSearchHits == null ||
                      widget.blocState.filteredSearchHits.length == 0) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: 350,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  height: 200,
                                  "assets/images/not_found_1.png"
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Text(
                                "Oops, Dr.Khady ne trouve rien...",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0
                                ),
                                ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Il semblerait que votre recherche n'aie rien donné, veuillez réessayer !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,

                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    )
                  ]else ...[
                    SizedBox(
                      height: 350,
                      child: Material(
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: mapState.filteredSearchHits.length,
                          itemBuilder: (BuildContext context, int index) {
                            final suggestion = mapState.filteredSearchHits[index];
                            // if (mapState.searchFilter == FilterValues.all ||
                            //     (mapState.searchFilter == FilterValues.places &&
                            //         suggestion.entityType == "place") ||
                            //     (mapState.searchFilter == FilterValues.stop &&
                            //         suggestion.entityType == "stop") ||
                            //     (mapState.searchFilter == FilterValues.routes &&
                            //         suggestion.entityType == "route")) {
                              return EntitySuggestion(
                              entitySuggestion:
                              widget.blocState.filteredSearchHits[index],
                              onTapSuggestion: widget.onTapSuggestion);
                            // } else {
                            //   // Retourner un conteneur vide pour exclure cet élément
                            //   // return Text("ez");
                            // }
                          },
                        )

                      ),
                    )
                  ]

                ],
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.primaryVar0,

                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: (){
                          widget.onBackPressed();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.primaryVar0,

                              borderRadius: BorderRadius.circular(30),
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
                              ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/map_white.png",
                                height: 18,
                                width: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                )
              ],
            );
          }
      ),
    );
  }
}


class EntityHistory extends StatelessWidget {
  const EntityHistory({
    super.key,
    this.entityType,
    required this.entityName,
    this.entityInfo,
  });

  final String? entityType;
  final String entityName;
  final String? entityInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
        height: 53,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.secondaryText
                  .withOpacity(.5), // Couleur de la bordure inférieure
              width: 0.5, // Épaisseur de la bordure inférieure
            ),
          ),
        ),
        // color: Colors.red,
        child: entityType != null && entityInfo != null
            ? Padding(
          padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      entityType == "place"
                          ? "assets/icons/location_search.png"
                          : entityType == "stop"
                              ? "assets/icons/stop_search.png"
                              : "assets/icons/bus_search.png",
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entityName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryText.withOpacity(0.8)),
                        ),
                        Text(
                          entityInfo!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryText),
                        ),
                      ],
                    )
                  ],
                ),
            )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Image.asset(
                    "assets/icons/notfound_search.png",
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  SizedBox(
                    height: 32,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entityName,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryText.withOpacity(0.8)),
                        ),
                        // Text(
                        //   "0 résultats",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       color: AppColors.bootstrapRed.withOpacity(.5)
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class EntitySuggestion extends StatelessWidget {
  const EntitySuggestion({
    super.key,
    // required this.entityType,
    // required this.entityName,
    // required this.entityAddress,
    // required this.mapEntity,
    required this.onTapSuggestion,
    required this.entitySuggestion,
  });

  final SearchHitEntity entitySuggestion;
  // final MapEntity mapEntity;
  final Function(MapEntity? suggestedMapEntity, SearchHitEntity searchHitEntity)? onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 390), () {
          onTapSuggestion!(null,entitySuggestion);
          // onTapSuggestion!(mapEntity);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
        height: 53,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.secondaryText
                  .withOpacity(.5), // Couleur de la bordure inférieure
              width: 0.5, // Épaisseur de la bordure inférieure
            ),
          ),
        ),
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                entitySuggestion.entityType == "place"
                    ? "assets/icons/location_search.png"
                    : entitySuggestion.entityType == "stop"
                        ? "assets/icons/stop_search.png"
                        : "assets/icons/bus_search.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: AppConstants.screenWidth * .6,
                          child: Text(
                              entitySuggestion.entityType == "place"
                              ? (entitySuggestion as SearchHitPlace).title
                              :  entitySuggestion.entityType == "stop"
                                ? (entitySuggestion as SearchHitStop).stopName
                                : (entitySuggestion as SearchHitRoute)
                                    .routeShortName  + " - " + ((entitySuggestion as SearchHitRoute).agencyId == "DDD" ? "Dakar Dem Dikk" : "Gie AFTU"),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryText.withOpacity(0.8)),
                          ),
                        ),
                        SizedBox(
                          width: AppConstants.screenWidth * .6,
                          child: Text(
                            entitySuggestion.entityType == "place"
                                ? (entitySuggestion as SearchHitPlace).subTitle
                                : entitySuggestion.entityType == "stop"
                                ? "Dakar"
                                : Toolbox.capitalizeWords((entitySuggestion as SearchHitRoute)
                                    .routeLongName),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(

                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryText),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/icons/arrow_left_up_black.png",
                      height: 25,
                      width: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
