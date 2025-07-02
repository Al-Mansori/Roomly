class ChatbotRequest {
  final String message;

  ChatbotRequest({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

