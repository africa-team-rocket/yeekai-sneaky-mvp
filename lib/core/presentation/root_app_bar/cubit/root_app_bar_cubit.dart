import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yeebus_filthy_mvp/core/presentation/root_app_bar/cubit/root_app_bar_state.dart';

import '../../../commons/utils/resource.dart';
import '../../../domain/use_cases/get_favorite_dests_from_cache_use_case.dart';


class RootAppBarCubit extends Cubit<RootAppBarState>{
  // Ce use case est importé depuis un autre feature, ce n'est pas convenable en terme de clean architecture
  // Mais pour des raisons pratiques je le fais.
  // Dans le futur je créerai un autre use case qui ne récupère spécifiquement que les 3 premiers de la liste dans le core
  final _getFavoritesListUseCase = GetFavoriteDestsFromCacheUseCase();

  RootAppBarCubit() : super(const RootAppBarState());

  Future<void> getFavDestinations() async {

      await for (final resource in _getFavoritesListUseCase.execute(const Duration(milliseconds: 1500))) {
        switch (resource.type) {
          case ResourceType.success:
            debugPrint("La liste est làà :");
            debugPrint(resource.data.toString());
            emit(state.copyWith(favDestinations: resource.data,isLoading: false));
            break;
          case ResourceType.error:
          // Handle error if needed
            break;
          case ResourceType.loading:
          // Handle loading state if needed
            break;
        }
      }
  }
}
