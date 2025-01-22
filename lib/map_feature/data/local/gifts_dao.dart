import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/cupertino.dart';
import '../../../../core/data/database_instance.dart';
import '../../../../core/di/locator.dart';
import '../../../main_feature/data/exceptions/local_database_exception.dart';
import '../../domain/model/gift.dart';


abstract class YeegiftsDao {
  Future<List<Gift>> getAllGifts();
  Future<void> updateAllGifts(List<Gift> gifts);
}

class YeegiftsDaoImpl implements YeegiftsDao {
  @override
  Future<List<Gift>> getAllGifts() async {
    sql.Database database =
    await locator.get<AppLocalDatabase>().getOrCreateDatabase;

    try {
      final maps = await database.query('gifts', orderBy: 'title ASC');

      return maps.map((map) {
        return Gift(
          giftId: map['gift_id'] as String,
          title: map['title'] as String,
          description: map['description'] as String,
          lat: map['lat'] as double,
          lng: map['lng'] as double,
          markerType: GiftMarkerType.values[map['marker_type'] as int],
          event: GiftEvent.values[map['event'] as int],
          wasFound: (map['was_found'] as int) == 1,
        );
      }).toList();
    } catch (error) {
      debugPrint('An error occurred in getAllGifts: $error');
      throw LocalDatabaseException('getAllGifts');
    }
  }

  @override
  Future<void> updateAllGifts(List<Gift> gifts) async {
    sql.Database database =
    await locator.get<AppLocalDatabase>().getOrCreateDatabase;

    final batch = database.batch();

    try {
      // Supprimer tous les cadeaux existants
      batch.delete('gifts');

      // Ajouter les nouveaux cadeaux
      for (final gift in gifts) {
        batch.insert(
          'gifts',
          {
            'gift_id': gift.giftId,
            'title': gift.title,
            'description': gift.description,
            'lat': gift.lat,
            'lng': gift.lng,
            'marker_type': gift.markerType.index,
            'event': gift.event.index,
            'was_found': gift.wasFound ? 1 : 0,
          },
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
      }

      // Exécuter la transaction batch
      await batch.commit(noResult: true);
    } catch (error) {
      debugPrint('An error occurred in updateAllGifts: $error');
      throw LocalDatabaseException('updateAllGifts');
    }
  }
}
