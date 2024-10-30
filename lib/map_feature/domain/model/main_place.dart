import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_entity.dart';

// Classe représentant les endroits clés du campus (labos, resto, etc.)
class MainPlace extends MapEntity {
  final String placeName;
  final String placeType;
  final String shortDescription;
  final String rating;
  final String floor;
  final String building;        
  final String timeDetail;       
  final String about;            
  final bool isOpen;
  final List<String> photos;

  const MainPlace({
    required this.placeType,
    required this.placeName,
    required this.shortDescription,
    required this.rating,
    required this.floor,
    required this.building,
    required this.timeDetail,
    required this.about,
    required this.isOpen,
    required super.entityPosition,
    required super.entityName,
    required this.photos

  });

  MainPlace copyWith({
    String? entityName,
    String? placeName,
    String? shortDescription,
    LatLng? entityPosition,
    String? rating,
    String? floor,
    String? building,
    String? timeDetail,
    String? about,
    bool? isOpen,
    List<String>? photos,
  }) {
    return MainPlace(
      placeType: placeType ?? this.placeType,
      placeName: placeName ?? this.placeName,
      shortDescription: shortDescription ?? this.shortDescription,
      rating: rating ?? this.rating,
      floor: floor ?? this.floor,
      building: building ?? this.building,
      timeDetail: timeDetail ?? this.timeDetail,
      about: about ?? this.about,
      isOpen: isOpen ?? this.isOpen,
      entityPosition: entityPosition ?? this.entityPosition,
      entityName: entityName ?? this.entityName,
      photos: photos ?? this.photos,
    );
  }
}

class Restroom extends MainPlace {
  final String occupancyLevel;
  final String urinalsAvailable;
  final String cleanlinessLevel;

  const Restroom({
    required this.occupancyLevel,
    required this.urinalsAvailable,
    required this.cleanlinessLevel,
    required super.placeName,
    required super.shortDescription,
    required super.entityPosition,
    required super.entityName,
    required super.rating,
    required super.floor,
    required super.building,
    required super.timeDetail,
    required super.about,
    required super.isOpen,
    required super.photos,
    required super.placeType,
  });

  Restroom copyWith({
    String? occupancyLevel,
    String? urinalsAvailable,
    String? cleanlinessLevel,
    String? placeName,
    String? shortDescription,
    LatLng? entityPosition,
    String? entityName,
    String? rating,
    String? floor,
    String? building,
    String? timeDetail,
    String? about,
    bool? isOpen,
    List<String>? photos,
    String? placeType,
  }) {
    return Restroom(
      occupancyLevel: occupancyLevel ?? this.occupancyLevel,
      urinalsAvailable: urinalsAvailable ?? this.urinalsAvailable,
      cleanlinessLevel: cleanlinessLevel ?? this.cleanlinessLevel,
      placeName: placeName ?? this.placeName,
      shortDescription: shortDescription ?? this.shortDescription,
      entityPosition: entityPosition ?? this.entityPosition,
      entityName: entityName ?? this.entityName,
      rating: rating ?? this.rating,
      floor: floor ?? this.floor,
      building: building ?? this.building,
      timeDetail: timeDetail ?? this.timeDetail,
      about: about ?? this.about,
      isOpen: isOpen ?? this.isOpen,
      photos: photos ?? this.photos,
      placeType: placeType ?? this.placeType,
    );
  }
}

class Office extends MainPlace {
  final String officeRole;
  final String aboutOffice;
  final List<String> officeHours;
  final List<String> servicesProvided;
  final List<Responsable> responsables;

  const Office({
    required this.officeRole,
    required this.aboutOffice,
    required this.officeHours,
    required this.servicesProvided,
    required this.responsables,
    required super.placeName,
    required super.shortDescription,
    required super.entityPosition,
    required super.entityName,
    required super.rating,
    required super.floor,
    required super.building,
    required super.timeDetail,
    required super.about,
    required super.isOpen,
    required super.photos,
    required super.placeType,
  });

  Office copyWith({
    String? officeRole,
    String? aboutOffice,
    List<String>? officeHours,
    List<String>? servicesProvided,
    List<Responsable>? responsables,
    String? placeName,
    String? shortDescription,
    LatLng? entityPosition,
    String? entityName,
    String? rating,
    String? floor,
    String? building,
    String? timeDetail,
    String? about,
    bool? isOpen,
    List<String>? photos,
    String? placeType,
  }) {
    return Office(
      officeRole: officeRole ?? this.officeRole,
      aboutOffice: aboutOffice ?? this.aboutOffice,
      officeHours: officeHours ?? this.officeHours,
      servicesProvided: servicesProvided ?? this.servicesProvided,
      responsables: responsables ?? this.responsables,
      placeName: placeName ?? this.placeName,
      shortDescription: shortDescription ?? this.shortDescription,
      entityPosition: entityPosition ?? this.entityPosition,
      entityName: entityName ?? this.entityName,
      rating: rating ?? this.rating,
      floor: floor ?? this.floor,
      building: building ?? this.building,
      timeDetail: timeDetail ?? this.timeDetail,
      about: about ?? this.about,
      isOpen: isOpen ?? this.isOpen,
      photos: photos ?? this.photos,
      placeType: placeType ?? this.placeType,
    );
  }
}

class Responsable {
  final String fullName;
  final String email;
  final String description;
  final List<String> photos;
  final bool isTeacher;
  final String phoneNumber;
  final String linkedin;
  final String position;

  const Responsable({
    required this.fullName,
    required this.email,
    required this.description,
    required this.photos,
    required this.isTeacher,
    required this.phoneNumber,
    required this.linkedin,
    required this.position,
  });
}

class Classroom extends MainPlace {
  const Classroom({
    required super.placeType,
    required super.placeName,
    required super.shortDescription,
    required super.rating,
    required super.floor,
    required super.building,
    required super.timeDetail,
    required super.about,
    required super.isOpen,
    required super.entityPosition,
    required super.entityName,
    required super.photos,
  });
}
