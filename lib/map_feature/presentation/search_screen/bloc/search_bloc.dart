

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/search_screen/bloc/search_event.dart';
import 'package:yeebus_filthy_mvp/map_feature/presentation/search_screen/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{

  SearchBloc():super(const SearchState()){
    // J'associe chaque évènement à une logique (méthode) ex ici UpdatePrompt à _updatePrompt
    on<UpdatePrompt>(_updatePrompt);

  }

  // _updatePrompt va donc s'exécuter à chaque fois que UpdatePrompt sera émis.
  void _updatePrompt(UpdatePrompt event, Emitter<SearchState> emit) async {

    // Avec emit je change le state du bloc (il faut lui passer un nouvel objet SearchState)
      emit(state.copyWith(userPrompt: event.newPrompt));
  }

}
