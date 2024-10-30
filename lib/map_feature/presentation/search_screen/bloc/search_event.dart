
abstract class SearchEvent{
  const SearchEvent();
}


class UpdatePrompt extends SearchEvent{
  final String newPrompt;
  const UpdatePrompt({required this.newPrompt});
}