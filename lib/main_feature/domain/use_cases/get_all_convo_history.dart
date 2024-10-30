
import '../../../core/commons/utils/resource.dart';
import '../../../core/di/locator.dart';
import '../../data/exceptions/local_database_exception.dart';
import '../model/chat_message.dart';
import '../repository/yeebot_repo.dart';

class GetAllConvoHistoryUseCase {
  final YeebotRepo _yeebotRepo = locator.get<YeebotRepo>();

  Stream<Resource<List<ChatMessage>>> execute() async* {
    try {
      yield Resource.loading();
      final messagesResource = await _yeebotRepo.getAllMessages();
      if (messagesResource.data != null) {
        yield Resource.success(messagesResource.data!);
      } else {
        yield Resource.error(messagesResource.message ?? 'Une erreur s\'est produite lors de la récupération des messages');
      }
    } on LocalDatabaseException catch (e) {
      yield Resource.error('Erreur lors de la récupération des messages de l\'historique: ${e.message}');
    } catch (e) {
      yield Resource.error('Une erreur inattendue est survenue lors de la récupération des messages de l\'historique: $e');
    }
  }
}