import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageEntity> messages;

  const ChatbotLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];

  ChatbotLoaded copyWith({
    List<ChatMessageEntity>? messages,
  }) {
    return ChatbotLoaded(
      messages: messages ?? this.messages,
    );
  }
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object?> get props => [message];
}

