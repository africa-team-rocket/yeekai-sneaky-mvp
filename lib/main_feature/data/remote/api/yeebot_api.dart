import '../../../../core/commons/utils/resource.dart';

abstract class YeebotApi {

  static const String API_BASE_URL = "https://yeegpt.replit.app";

  Future<Resource<String>> invokeYeeguide(String yeeguideId, String message, List<List<String>> chatHistory);
  Resource<String> cancelStream();
  Stream<String> streamYeeguide(String yeeguideId, String message, List<List<String>> chatHistory);
}