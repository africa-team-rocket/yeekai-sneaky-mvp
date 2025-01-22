import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/commons/utils/resource.dart';

import '../../core/di/locator.dart';
import '../domain/model/gift.dart';
import '../domain/repository/yeegifts_repo.dart';

class GiftTestPage extends StatefulWidget {
  const GiftTestPage({Key? key}) : super(key: key);

  @override
  State<GiftTestPage> createState() => _GiftTestPageState();
}

class _GiftTestPageState extends State<GiftTestPage> {
  YeegiftsRepo yeegiftsRepo = locator.get<YeegiftsRepo>();
  // YeegiftsRepo yeegiftsRepo = YeegiftsRepoImpl();
  String response = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Repository Test Page')),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final Resource<List<Gift>> result = await yeegiftsRepo.fetchGiftsFromCache();
                  setState(() {
                    response = result.data?.toString() ?? result.message!;
                  });
                  debugPrint("Cadeaux depuis le cache: $response");
                },
                child: const Text("Récupérer cadeaux depuis le cache"),
              ),
              ElevatedButton(
                onPressed: () async {

                  final Resource<List<Gift>> remoteResponse =
                  await yeegiftsRepo.fetchGiftsFromRemote();
                  if(remoteResponse.data != null){

                  final Resource<String> result = await yeegiftsRepo.updateGiftsCache(remoteResponse.data!);
                  setState(() {
                    response = result.data ?? result.message!;
                  });
                  debugPrint("Mise à jour du cache: $response");
                  }else{
                    debugPrint("La liste est nulle ?!");
                  }

                },
                child: const Text("Synchroniser le cache"),
              ),

              ElevatedButton(
                onPressed: () async {
                  final Resource<List<Gift>> result =
                  await yeegiftsRepo.fetchGiftsFromRemote();
                  setState(() {
                    response = result.data?.toString() ?? result.message!;
                  });
                  debugPrint("Tous les gifts: $response");
                },
                child: const Text("Récupérer tous les gifts"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Resource<List<Gift>> result =
                  await yeegiftsRepo.fetchGiftsByEventFromRemote(GiftEvent.CHRISTMAS);
                  setState(() {
                    response = result.data?.toString() ?? result.message!;
                  });
                  debugPrint("Gifts pour CHRISTMAS: $response");
                },
                child: const Text("Récupérer gifts par événement"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Resource<Gift> result =
                  await yeegiftsRepo.fetchGiftByIdFromRemote("123");
                  setState(() {
                    response = result.data?.toString() ?? result.message!;
                  });
                  debugPrint("Gift avec ID 123: $response");
                },
                child: const Text("Récupérer un gift par ID"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Gift updatedGift = Gift(
                    giftId: "123",
                    title: "Loot surprise",
                    description: "A small red box under the old oak tree.",
                    lat: 14.70031828080074,
                    lng: -17.450545392930508,
                    markerType: GiftMarkerType.LOOT,
                    event: GiftEvent.CHRISTMAS,
                    wasFound: true,
                  );
                  final Resource<String> result =
                  await yeegiftsRepo.updateGiftFromRemote("123", updatedGift);
                  setState(() {
                    response = result.data ?? result.message!;
                  });
                  debugPrint("Gift mis à jour: $response");
                },
                child: const Text("Mettre à jour un gift"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Resource<String> result =
                  await yeegiftsRepo.toggleGiftWasFoundFromRemote("123");
                  setState(() {
                    response = result.data ?? result.message!;
                  });
                  debugPrint("Toggle wasFound pour gift 123: $response");
                },
                child: const Text("Changer l'état 'wasFound'"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Réponse: $response",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
