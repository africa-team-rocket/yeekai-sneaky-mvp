
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../../data/local/entity/current_dest_local_entity.dart';

class GetFavoriteDestsFromCacheUseCase{

  // final _favDestsRepo = locator.get<CurrentDestsRepo>();

  List<CurrentDestLocalEntity> destinations = [
    CurrentDestLocalEntity(
      id: 1,
      placeId: 'place_1',
      latitude: 48.8566,
      longitude: 2.3522,
      formatedAddress: 'Adresse de la Maison',
      label: 'Maison',
      definitive: 1,
      iconUrl: 'http://example.com/icon1.png',
      order: 1,
    ),
    CurrentDestLocalEntity(
      id: 2,
      placeId: 'place_2',
      latitude: 48.8567,
      longitude: 2.3523,
      formatedAddress: 'Adresse du Travail',
      label: 'Travail',
      definitive: 1,
      iconUrl: 'http://example.com/icon2.png',
      order: 2,
    ),
    CurrentDestLocalEntity(
      id: 3,
      placeId: 'place_3',
      latitude: 48.8568,
      longitude: 2.3524,
      formatedAddress: 'Adresse des Courses',
      label: 'Courses',
      definitive: 1,
      iconUrl: 'http://example.com/icon3.png',
      order: 3,
    ),
    CurrentDestLocalEntity(
      id: 4,
      placeId: 'place_4',
      latitude: 48.8569,
      longitude: 2.3525,
      formatedAddress: 'Adresse du Sport',
      label: 'Sport',
      definitive: 1,
      iconUrl: 'http://example.com/icon4.png',
      order: 4,
    ),
    CurrentDestLocalEntity(
      id: 5,
      placeId: 'place_5',
      latitude: 48.8570,
      longitude: 2.3526,
      formatedAddress: 'Adresse de Loisirs',
      label: 'Loisirs',
      definitive: 1,
      iconUrl: 'http://example.com/icon5.png',
      order: 5,
    ),
  ];


  Stream<Resource<List<CurrentDestLocalEntity>>> execute(Duration duration) async*{

    // Dans le futur, toutes les exceptions devront être redescendus et traités dans ton bloc ou use case.

    yield Resource.loading();

    // final response = await _favDestsRepo.getAllCurrentDests();
    await Future.delayed(duration);

    yield Resource.success(destinations);
    // Future.delayed(const Duration(milliseconds: 1000), () async*{
    // });

  }

}