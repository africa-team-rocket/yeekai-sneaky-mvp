// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:yeebus_filthy_mvp/map_feature/domain/model/search_hit_entity.dart';
// import 'package:yeebus_thesis_app/feature_main/domain/model/search_hit_entity.dart';

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<SearchHitEntity> items;
  final int pageKey;
  final int? nextPageKey;

  // factory HitsPage.fromResponse(SearchResponse response) {
  //   debugPrint("Voici la hitsPage :");
  //   debugPrint(response.toString());
  //   final items = response.hits.map(SearchHitEntity.fromJson).toList();
  //   final isLastPage = response.page >= response.nbPages;
  //   final nextPageKey = isLastPage ? null : response.page + 1;
  //   return HitsPage(items, response.page, nextPageKey);
  // }

  @override
  String toString() {
    return 'HitsPage{items: $items, pageKey: $pageKey, nextPageKey: $nextPageKey}';
  }
}