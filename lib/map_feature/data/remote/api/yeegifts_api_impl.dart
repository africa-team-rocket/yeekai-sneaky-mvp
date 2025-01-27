import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeebus_filthy_mvp/main_feature/data/remote/api/yeebot_api.dart';
import 'package:yeebus_filthy_mvp/map_feature/data/remote/api/yeegifts_api.dart';

import '../../../../core/commons/utils/resource.dart';

import 'package:http/http.dart' as http;


class YeegiftsApiImpl extends YeegiftsApi {


  @override
  Future<Resource<List<Map<String, dynamic>>>> fetchGifts() async {
    final url = Uri.parse("${YeegiftsApi.API_BASE_URL}/gifts");

    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return Resource.success(data.cast<Map<String, dynamic>>());
    } else {
      debugPrint("Erreur lors de fetchGifts: ${response.body}");
      throw Exception("Erreur inattendue dans fetchGifts: ${response.body}");
    }
  }

  @override
  Future<Resource<List<Map<String, dynamic>>>> fetchGiftsByEvent(String event) async {
    final url = Uri.parse("${YeegiftsApi.API_BASE_URL}/gifts?event=$event");

    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return Resource.success(data.cast<Map<String, dynamic>>());
    } else {
      debugPrint("Erreur lors de fetchGiftsByEvent: ${response.body}");
      throw Exception("Erreur inattendue dans fetchGiftsByEvent: ${response.body}");
    }
  }

  @override
  Future<Resource<Map<String, dynamic>>> fetchGiftById(String giftId) async {
    final url = Uri.parse("${YeegiftsApi.API_BASE_URL}/gifts/$giftId");

    final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return Resource.success(data);
    } else {
      debugPrint("Erreur lors de fetchGiftById: ${response.body}");
      throw Exception("Erreur inattendue dans fetchGiftById: ${response.body}");
    }
  }

  @override
  Future<Resource<String>> updateGift(String giftId, Map<String, dynamic> payload) async {
    final url = Uri.parse("${YeegiftsApi.API_BASE_URL}/gifts/$giftId");

    final response = await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload));

    if (response.statusCode == 200) {
      return Resource.success("Gift mis à jour avec succès");
    } else {
      debugPrint("Erreur lors de updateGift: ${response.body}");
      throw Exception("Erreur inattendue dans updateGift: ${response.body}");
    }
  }


  @override
  Future<Resource<String>> toggleGiftWasFound(String giftId) async {
    final url = Uri.parse("${YeegiftsApi.API_BASE_URL}/gifts/$giftId/wasFound");

    final response = await http.patch(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return Resource.success("État de wasFound togglé avec succès");
    } else {
      debugPrint("Erreur lors de toggleGiftWasFound: ${response.body}");
      throw Exception("Erreur inattendue dans toggleGiftWasFound: ${response.body}");
    }
  }
}
