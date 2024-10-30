//
// import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:widget_to_marker/widget_to_marker.dart';
// import 'package:yeebus_thesis_app/feature_main/domain/model/bus_nearby.dart';
//
// import '../../../core/commons/utils/resource.dart';
// import '../../presentation/map_screen/map_screen.dart';
// import '../model/bus.dart';
//
// class GetBusesNearbyUseCase{
//
//   // Ici on utiliserait la position de l'utilisateur pour faire appel à GraphQL et récupérer
//   // Les bus à proximité de l'utilisateur, voici les seules informations nécessaires :
//   // Le numéro de ligne, l'état du bus et sa position en temps réel
//
//   // Je dois me renseigner quant à comment un bon développeur front-end utilise GraphQL car on le sait,
//   // GraphQL ne va me retourner que cs 3 infos là, et moi je devrai les encapsuler dans des objets, est-ce
//   // que cela veut dire que j'aurai besoin de rendre tous mes attribut Nullable, de telle sorte à n'avoir des'
//   // objets qu'avec les attributs que je veux ?'
//
//   Stream<Resource<List<BusNearby>>> execute(LatLng userPos) async*{
//
//     // Pour le moment j'ai crée une entité bien à part, il faudra dans le futur que je sollicite l'avis d'un
//     // expert pour cela.
//     List<BusNearby> mockedResponse1 = [
//       BusNearby(
//           busId: "bus1",
//           lineId: "line1",
//           lineNumber: 219,
//           position: const LatLng(14.721409159089271, -17.482512039612224),
//           state: BusState.EMPTY,
//           busMarker: Marker(
//               markerId: const MarkerId("bus1"),
//               position: const LatLng(14.721409159089271, -17.482512039612224),
//               icon: await const BusMarkerIcon(
//                 lineNumber: "219",
//                 state: BusState.EMPTY,
//               ).toBitmapDescriptor(logicalSize: const Size(92, 92), imageSize: const Size(92, 92))
//           )
//       ),
//       BusNearby(
//           busId: "bus2",
//           lineId: "line2",
//           lineNumber: 003,
//           position: const LatLng(14.72230626892727, -17.48438741135946),
//           state: BusState.CROWDED,
//           busMarker: Marker(
//               markerId: const MarkerId("bus2"),
//               position: const LatLng(14.72230626892727, -17.48438741135946),
//               icon: await const BusMarkerIcon(
//                 lineNumber: "003",
//                 state: BusState.CROWDED,
//               ).toBitmapDescriptor(logicalSize: const Size(92, 92), imageSize: const Size(92, 92))
//           )
//       ),
//       BusNearby(
//           busId: "bus3",
//           lineId: "line3",
//           lineNumber: 217,
//           position: const LatLng(14.72401885771192, -17.48343967360605),
//           state: BusState.CROWDED,
//           busMarker: Marker(
//               markerId: const MarkerId("bus3"),
//               position: const LatLng(14.72401885771192, -17.48343967360605),
//               icon: await const BusMarkerIcon(
//                 lineNumber: "217",
//                 state: BusState.HALFCROWDED,
//               ).toBitmapDescriptor(logicalSize: const Size(92, 92), imageSize: const Size(92, 92))
//           )
//       )
//
//     ];
//
//     // List<BusNearby> mockedResponse2 = [
//     //   BusNearby(
//     //       busId: "bus1",
//     //       lineId: "line1",
//     //       lineNumber: 219,
//     //       position: const LatLng(14.700029517700326, -17.451019219831917),
//     //       state: BusState.EMPTY,
//     //       busMarker: Marker(
//     //           markerId: const MarkerId("bus1"),
//     //           position: const LatLng(14.700029517700326, -17.451019219831917),
//     //           icon: await const BusMarkerIcon(
//     //             lineNumber: "219",
//     //             state: BusState.EMPTY,
//     //           ).toBitmapDescriptor(logicalSize: const Size(72, 72), imageSize: const Size(72, 72))
//     //       )
//     //   )
//     // ];
//
//     //
//     yield Resource.success(mockedResponse1);
//     // while (true) {
//     //   // Émettre la première valeur mockée
//     //   yield Resource.success(mockedResponse1);
//     //
//     //   // Attendre 5 secondes
//     //   await Future.delayed(Duration(seconds: 5));
//     //
//     //   // Émettre la deuxième valeur mockée
//     //   yield Resource.success(mockedResponse2);
//     //
//     //   // Attendre 5 secondes
//     //   await Future.delayed(Duration(seconds: 5));
//     // }
//   }
//
// }

import 'dart:async';
import 'dart:math';
import 'dart:ui';

// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../core/commons/utils/resource.dart';
import '../../presentation/map_screen/bloc/map_bloc.dart';
import '../../presentation/map_screen/bloc/map_event.dart';
import '../../presentation/map_screen/map_screen.dart';
import '../model/bus.dart';
import '../model/bus_nearby.dart';
import '../model/line.dart';

class GetBusesNearbyUseCase {
  late List<BusNearby> _buses;
  late Random _random;

  GetBusesNearbyUseCase() {
    // Initialisation de vos bus (vous pouvez utiliser vos données mockées ici)
    _random = Random();
  }

  // ...
  Future<void> _initializeBuses(MapBloc bloc) async {
    // Opération asynchrone pour récupérer la liste des bus
    _buses = await _fetchBusData(bloc);
  }

  LatLng getDestination(int lineNumber) {
    switch (lineNumber) {
      case 219:
        return const LatLng(14.718207960018598, -17.478246948535737);
      case 003:
        // Reste sur place
        return LatLng(14.72230626892727, -17.48438741135946);
      case 217:
        return const LatLng(14.723064244342849, -17.481680176078537);
      default:
        // Par défaut, retournez une destination neutre
        return const LatLng(0, 0);
    }
  }

  Stream<Resource<List<BusNearby>>> execute(
      LatLng userPos, MapBloc bloc) async* {
    await _initializeBuses(bloc);

    while (true) {
      // Déplacer chaque bus
      for (int i = 0; i < _buses.length; i++) {
        final bus = _buses[i];
        final newLatLng = _calculateNextPosition(
            bus.position, getDestination(bus.lineNumber));

        // Mettez à jour la position du bus
        _buses[i] = await bus.copyWith(position: newLatLng);
      }

      // Émettre la liste mise à jour des bus
      yield Resource.success(_buses);
      debugPrint("Was called :");

      // Attendre un certain temps avant de mettre à jour à nouveau
      await Future.delayed(Duration(seconds: 2 + _random.nextInt(10)));
    }
  }

  Future<List<BusNearby>> _fetchBusData(MapBloc bloc) async {
    // Logique pour récupérer la liste initiale des bus (peut être asynchrone)
    // Remplacez cela par votre logique de récupération réelle
    return [
      BusNearby(
          busId: "bus1",
          lineId: "line1",
          lineNumber: 219,
          position: const LatLng(14.721409159089271, -17.482512039612224),
          state: BusState.EMPTY,
          busMarker: Marker(
              markerId: const MarkerId("bus1"),
              position: const LatLng(14.721409159089271, -17.482512039612224),
              icon: await const BusMarkerIcon(
                lineNumber: "219",
                state: BusState.EMPTY,
              ).toBitmapDescriptor(
                  logicalSize: const Size(92, 92),
                  imageSize: const Size(92, 92)))),
      BusNearby(
          busId: "bus2",
          lineId: "line2",
          lineNumber: 003,
          position: const LatLng(14.72230626892727, -17.48438741135946),
          state: BusState.CROWDED,
          busMarker: Marker(
              markerId: const MarkerId("bus2"),
              position: const LatLng(14.72230626892727, -17.48438741135946),
              onTap: () {
                debugPrint("Tapped");
                bloc.add(SetSelectedMapEntity(Bus(
                    entityName: "Ligne 003 - GIE AFTU",
                    state: BusState.CROWDED,
                    capacity: 45,
                    line: Line(
                      arrival: 'PETERSEN',
                      departure: 'YOFF VILLAGE',
                      lineNumber: "003",
                      description:
                          'Cette ligne couvre la distance PETERSEN-YOFF VILLAGE',
                      rating: 5,
                      fareRange: '200-300',
                      onwardShape: [
                        LatLng(14.7488936802881, -17.490589151363938),
                        LatLng(14.754173488495805, -17.495051551688665),
                        LatLng(14.748591968133685, -17.507519826256395),
                        LatLng(14.743596231787446, -17.5117928410464),
                        LatLng(14.737027589121572, -17.509082346612267),
                        LatLng(14.73181570823653, -17.508061925159762),
                        LatLng(14.728577494662582, -17.505000660857682),
                        LatLng(14.727559760459522, -17.50286415348019),
                        LatLng(14.726425402507246, -17.500775492897652),
                        LatLng(14.725457713941438, -17.497373609274877),
                        LatLng(14.721857874710896, -17.491930595435694),
                        LatLng(14.719496657507207, -17.489969509576458),
                        LatLng(14.750277612687961, -17.45788510152128),
                        LatLng(14.746394954969995, -17.466588512861758),
                        LatLng(14.744905821864554, -17.46887636539269),
                        LatLng(14.740497732127464, -17.471505759915615),
                        LatLng(14.735673214191454, -17.473247964998105),
                        LatLng(14.729655629460476, -17.472863237737428),
                        LatLng(14.72590576002534, -17.471812771657483),
                        LatLng(14.722566078908324, -17.471226477452866),
                        LatLng(14.719750523903995, -17.47138906188038),
                      ],
                      lineId: 1,
                    ),
                    isAccessible: false,
                    entityPosition:
                        LatLng(14.72230626892727, -17.48438741135946))));
              },
              icon: await const BusMarkerIcon(
                lineNumber: "003",
                state: BusState.CROWDED,
              ).toBitmapDescriptor(
                  logicalSize: const Size(92, 92),
                  imageSize: const Size(92, 92)))),
      BusNearby(
          busId: "bus3",
          lineId: "line3",
          lineNumber: 217,
          position: const LatLng(14.72401885771192, -17.48343967360605),
          state: BusState.HALFCROWDED,
          busMarker: Marker(
            markerId: const MarkerId("bus3"),
            position: const LatLng(14.72401885771192, -17.48343967360605),
            icon: await const BusMarkerIcon(
              lineNumber: "217",
              state: BusState.HALFCROWDED,
            ).toBitmapDescriptor(
                logicalSize: const Size(92, 92), imageSize: const Size(92, 92)),
            onTap: () {
              debugPrint("Tapped");

              bloc.add(SetSelectedMapEntity(Bus(
                  entityName: "Ligne 003 - GIE AFTU",
                  state: BusState.CROWDED,
                  capacity: 45,
                  line: Line(
                    arrival: 'PETERSEN',
                    departure: 'YOFF VILLAGE',
                    lineNumber: "003",
                    description:
                        'Cette ligne couvre la distance PETERSEN-YOFF VILLAGE',
                    rating: 5,
                    fareRange: '200-300',
                    onwardShape: [
                      LatLng(14.7488936802881, -17.490589151363938),
                      LatLng(14.754173488495805, -17.495051551688665),
                      LatLng(14.748591968133685, -17.507519826256395),
                      LatLng(14.743596231787446, -17.5117928410464),
                      LatLng(14.737027589121572, -17.509082346612267),
                      LatLng(14.73181570823653, -17.508061925159762),
                      LatLng(14.728577494662582, -17.505000660857682),
                      LatLng(14.727559760459522, -17.50286415348019),
                      LatLng(14.726425402507246, -17.500775492897652),
                      LatLng(14.725457713941438, -17.497373609274877),
                      LatLng(14.721857874710896, -17.491930595435694),
                      LatLng(14.719496657507207, -17.489969509576458),
                      LatLng(14.750277612687961, -17.45788510152128),
                      LatLng(14.746394954969995, -17.466588512861758),
                      LatLng(14.744905821864554, -17.46887636539269),
                      LatLng(14.740497732127464, -17.471505759915615),
                      LatLng(14.735673214191454, -17.473247964998105),
                      LatLng(14.729655629460476, -17.472863237737428),
                      LatLng(14.72590576002534, -17.471812771657483),
                      LatLng(14.722566078908324, -17.471226477452866),
                      LatLng(14.719750523903995, -17.47138906188038),
                    ],
                    lineId: 1,
                  ),
                  isAccessible: false,
                  entityPosition:
                      LatLng(14.72230626892727, -17.48438741135946))));
            },
          ))
    ];
  }

  LatLng _calculateNextPosition(LatLng currentPos, LatLng destination) {
    // Logique pour calculer la prochaine position de manière réaliste
    // Peut-être utiliser des formules de mouvement doux entre les points
    // Vous pouvez utiliser une bibliothèque comme 'latlong' pour faciliter cela.

    // Pour l'instant, on suppose simplement un mouvement linéaire vers la destination
    final double latDiff = destination.latitude - currentPos.latitude;
    final double lngDiff = destination.longitude - currentPos.longitude;

    // Si le bus est très proche de la destination, il s'arrête
    if (latDiff.abs() < 0.0001 && lngDiff.abs() < 0.0001) {
      return currentPos;
    }

    // Sinon, effectuez un petit mouvement vers la destination
    final double latIncrement = latDiff * 0.1;
    final double lngIncrement = lngDiff * 0.1;

    return LatLng(currentPos.latitude + latIncrement,
        currentPos.longitude + lngIncrement);
  }
}
