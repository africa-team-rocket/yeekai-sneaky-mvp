import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';


class AppLocalDatabase {
  static const _databaseName = 'yeechat_database.db';
  static const _databaseVersion = 1;
  sql.Database? _database;

  // Getter pour l'instance de la base de données
  Future<sql.Database> get getOrCreateDatabase async {
    if (_database == null) {
      await createDatabase();
    }
    return _database!;
  }

  AppLocalDatabase() {
    debugPrint("Constructur called");
    createDatabase();
  }

  Future<void> createDatabase() async {
    final databasePath = await sql.getDatabasesPath();
    final pathToDatabase = path.join(databasePath, _databaseName);

    final database = await sql.openDatabase(
      pathToDatabase,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Effectuer les opérations nécessaires lors de la mise à niveau de la base de données (par exemple, modifier la structure des tables)
        // Assurez-vous de gérer correctement les migrations de données si nécessaire
      },
    );

    _database = database;

    // suggestionHitDao = SearchHitsDaoImpl(database);
    // currentDestsDao = CurrentDestsDaoImpl(database);
  }

  // Future<void> insertDefaultCurrentDestinations(sql.Database database) async {
  //   final defaultDestinations = [
  //     CurrentDestLocalEntity(
  //       placeId: null,
  //       latitude: null, // Remplacez par la latitude réelle
  //       longitude: null, // Remplacez par la longitude réelle
  //       formatedAddress: null,
  //       label: "Maison",
  //       definitive: 1, // Marquez les destinations par défaut comme "définitives"
  //       iconUrl: "assets/icons/fav_collection/fav_home.svg", // Remplacez par l'URL réelle de l'icône
  //       order: 1, // L'ordre dans lequel ils apparaissent
  //     ),
  //     CurrentDestLocalEntity(
  //       placeId: null,
  //       latitude: null, // Remplacez par la latitude réelle
  //       longitude: null, // Remplacez par la longitude réelle
  //       formatedAddress: null,
  //       label: "Travail",
  //       definitive: 1, // Marquez les destinations par défaut comme "définitives"
  //       iconUrl: "assets/icons/fav_collection/fav_work.svg", // Remplacez par l'URL réelle de l'icône
  //       order: 2, // L'ordre dans lequel ils apparaissent
  //     ),
  //     CurrentDestLocalEntity(
  //       placeId: null,
  //       latitude: null, // Remplacez par la latitude réelle
  //       longitude: null, // Remplacez par la longitude réelle
  //       formatedAddress: null,
  //       label: "Courses",
  //       definitive: 1, // Marquez les destinations par défaut comme "définitives"
  //       iconUrl: "assets/icons/fav_collection/fav_shop.svg", // Remplacez par l'URL réelle de l'icône
  //       order: 3, // L'ordre dans lequel ils apparaissent
  //     ),
  //     CurrentDestLocalEntity(
  //       placeId: null,
  //       latitude: null, // Remplacez par la latitude réelle
  //       longitude: null, // Remplacez par la longitude réelle
  //       formatedAddress: null,
  //       label: "Sport",
  //       definitive: 1, // Marquez les destinations par défaut comme "définitives"
  //       iconUrl: "assets/icons/fav_collection/fav_dumbell.svg", // Remplacez par l'URL réelle de l'icône
  //       order: 4, // L'ordre dans lequel ils apparaissent
  //     ),
  //     // Ajoutez d'autres destinations par défaut ici
  //   ];
  //
  //   for (final destination in defaultDestinations) {
  //     await database.insert('current_dests_records', destination.toMap(),
  //         conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   }
  // }

  Future<void> createTables(sql.Database database) async {
    debugPrint("On created est appelé ;)");

    // Créez une table pour stocker les messages
    // Ta table ne doit pas se terminer par une virgule sinon ça fait buguer tout ton code hein !
    await database.execute('''
      CREATE TABLE IF NOT EXISTS conversation (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        content TEXT,
        yeeguide_id TEXT,
        is_user_message INTEGER NOT NULL,
        run_id TEXT,
        creation_date TEXT NOT NULL
      )
    ''');
  }
}
