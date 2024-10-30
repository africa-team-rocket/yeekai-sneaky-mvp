import 'package:flutter/material.dart';

import '../../../core/commons/utils/app_constants.dart';
import '../../../core/domain/models/chatbot_conversation.dart';

enum Languages { fr, eng, wol }

class Yeeguide {
  String id;
  String name;
  String profilePictureAsset;
  String profilePictureSquareAsset;
  String tag;
  String category;
  String shortBio;
  bool usesAudio;
  List<Languages> languages;
  int nbSubs;
  Conversation script;
  ChatResponse introChatResponse;
  ChatResponse welcomeChatResponse;


  Yeeguide(
      {required this.id,
      required this.name,
      required this.profilePictureAsset,
      required this.profilePictureSquareAsset,
      required this.tag,
      required this.category,
      required this.shortBio,
      required this.usesAudio,
      required this.languages,
      required this.nbSubs,
      required this.introChatResponse,
      required this.welcomeChatResponse,
      required this.script
      });

  static Yeeguide getById(String id) {
    // Convertit la chaîne de caractères en une valeur de l'énumération YeeguideId
    YeeguideId enumId;
    switch (id) {
      case "raruto":
        enumId = YeeguideId.raruto;
        break;
      case "rita":
        enumId = YeeguideId.rita;
        break;
      case "issa":
        enumId = YeeguideId.issa;
        break;
      case "songo":
        enumId = YeeguideId.songo;
        break;
      case "domsa":
        enumId = YeeguideId.domsa;
        break;
      case "sane_madio":
        enumId = YeeguideId.madio;
        break;
      case "vaidewish":
        enumId = YeeguideId.vaidewish;
        break;
      default:
        throw ArgumentError('Invalid Yeeguide ID: $id');
    }

    // Utilise la méthode getById avec l'énumération YeeguideId
    return getByIdUsingEnum(enumId);
  }

  static Yeeguide getByIdUsingEnum(YeeguideId id) {
    return AppConstants.yeeguidesOriginalList.firstWhere(
      (yeeguide) => yeeguide.id == id.value,
    );
  }

  static Widget buildRichText(String shortBio) {
    List<TextSpan> textSpans = [];
    List<String> words = shortBio.split(' ');

    for (String word in words) {
      if (word.startsWith('#')) {
        // Si le mot commence par un hashtag (#), le mettre en bleu
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(color: Colors.blue),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
    }

    return RichText(
      textAlign: TextAlign.start,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: textSpans,
      ),
    );
  }
}
