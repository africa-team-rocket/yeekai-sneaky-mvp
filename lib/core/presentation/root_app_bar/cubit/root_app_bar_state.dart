import '../../../data/local/entity/current_dest_local_entity.dart';

class RootAppBarState{
  final List<CurrentDestLocalEntity> favDestinations;
  final isLoading;

  const RootAppBarState({
    this.favDestinations = const [],
    this.isLoading = true,
  });

  RootAppBarState copyWith({
    List<CurrentDestLocalEntity>? favDestinations,
    bool? isLoading,
  }) {
    return RootAppBarState(
      favDestinations: favDestinations ?? this.favDestinations,
      isLoading: isLoading ?? this.isLoading
    );
  }
}