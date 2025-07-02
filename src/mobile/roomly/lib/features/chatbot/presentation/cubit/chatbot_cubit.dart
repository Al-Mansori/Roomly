// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/entities/chat_message_entity.dart';
// import '../../domain/usecases/send_message_usecase.dart';
// import 'chatbot_state.dart';

// class ChatbotCubit extends Cubit<ChatbotState> {
//   final SendMessageUseCase sendMessageUseCase;
//   final List<ChatMessageEntity> _messages = [];

//   ChatbotCubit({
//     required this.sendMessageUseCase,
//   }) : super(ChatbotInitial());

//   void loadMessages() {
//     emit(ChatbotLoaded(messages: List.from(_messages)));
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.trim().isEmpty) return;

//     try {
//       // Add user message
//       final userMessage = ChatMessageEntity(
//         id: _generateId(),
//         message: message.trim(),
//         isUser: true,
//         timestamp: DateTime.now(),
//       );
      
//       _messages.add(userMessage);
//       emit(ChatbotLoaded(messages: List.from(_messages)));

//       // Send message to API and get response
//       final response = await sendMessageUseCase(message.trim());
      
//       _messages.add(response);
//       emit(ChatbotLoaded(messages: List.from(_messages)));
      
//     } catch (e) {
//       emit(ChatbotError(message: e.toString()));
//       // Reload messages after error
//       emit(ChatbotLoaded(messages: List.from(_messages)));
//     }
//   }

//   void clearMessages() {
//     _messages.clear();
//     emit(ChatbotLoaded(messages: List.from(_messages)));
//   }

//   String _generateId() {
//     return DateTime.now().millisecondsSinceEpoch.toString() + 
//            Random().nextInt(1000).toString();
//   }
// }



// v2 ---------------------------------------------------------------------------------


import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final SendMessageUseCase sendMessageUseCase;
  final List<ChatMessageEntity> _messages = [];

  ChatbotCubit({
    required this.sendMessageUseCase,
  }) : super(ChatbotInitial());

  void loadMessages() {
    emit(ChatbotLoaded(messages: List.from(_messages)));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      // Add user message
      final userMessage = ChatMessageEntity(
        id: _generateId(),
        message: message.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );
      
      _messages.add(userMessage);
      emit(ChatbotLoaded(messages: List.from(_messages)));

      // Add a temporary loading message
      final loadingMessage = ChatMessageEntity(
        id: 'loading',
        message: 'Loading...',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(loadingMessage);
      emit(ChatbotLoaded(messages: List.from(_messages)));

      // Send message to API and get response
      final response = await sendMessageUseCase(message.trim());
      
      // Remove the loading message and add the actual response
      _messages.removeWhere((msg) => msg.id == 'loading');
      _messages.add(response);
      emit(ChatbotLoaded(messages: List.from(_messages)));
      
    } catch (e) {
      _messages.removeWhere((msg) => msg.id == 'loading'); // Remove loading message on error
      emit(ChatbotError(message: e.toString()));
      // Reload messages after error
      emit(ChatbotLoaded(messages: List.from(_messages)));
    }
  }

  void clearMessages() {
    _messages.clear();
    emit(ChatbotLoaded(messages: List.from(_messages)));
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
}

