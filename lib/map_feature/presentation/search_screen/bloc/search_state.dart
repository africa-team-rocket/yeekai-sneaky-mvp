class SearchState {
  final String userPrompt;

  const SearchState({
    this.userPrompt = "",
  });

  SearchState copyWith({
    String? userPrompt,
  }) {
    return SearchState(
      userPrompt: userPrompt ?? this.userPrompt,
    );
  }
}
