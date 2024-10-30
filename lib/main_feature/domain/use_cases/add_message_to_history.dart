
import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../../data/exceptions/local_database_exception.dart';
import '../model/chat_message.dart';
import '../repository/yeebot_repo.dart';

class AddMessageToHistoryUseCase {
  final YeebotRepo _yeebotRepo = locator.get<YeebotRepo>();

  // C'est exactement comme ça que tu dois catch et throws les erreurs dans le use case.
  // Maintenant il te faudrait dans le futur quelque chose qui permette de bien déterminer le message à afficher
  // chez l'utilisateur, ou peut-être qu'on devrait directement renvoyer le message en question ici.

  Stream<Resource<void>> execute(ChatMessage message) async* {
    try {
      yield Resource.loading();
      _yeebotRepo.addConvoMessageToCache(message);
      yield Resource.success(null);
    } on LocalDatabaseException catch (e) {
      yield Resource.error('Erreur lors de l\'ajout du message à l\'historique: ${e.message}');
    } catch (e) {
      yield Resource.error('Une erreur inattendue est survenue lors de l\'ajout du message à l\'historique: $e');
    }
  }
}