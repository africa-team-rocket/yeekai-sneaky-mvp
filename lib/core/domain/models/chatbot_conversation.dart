// static const emptyChatStep = ChatStep(prompt: prompt)

class Conversation {
  List<ChatStep> steps;
  List<FaqStep> faqSteps;
  ChatStep afterFaq;
  Conversation({required this.steps, required this.faqSteps, required this.afterFaq});
}


class FaqStep{
  String question;
  ChatResponse answer;


  FaqStep({required this.question, required this.answer});
}


class ChatStep {
  String prompt;
  ChatResponse response;

  ChatStep(
      {required this.prompt, required this.response});

  @override
  String toString() {
    return 'ChatStep{prompt: $prompt, response: $response}';
  }
}

class ChatResponse {
  List<String> text;
  List<ChatStep> nextSteps;

  ChatResponse({required this.text, required this.nextSteps});
}

