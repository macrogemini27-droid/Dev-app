part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Session session;
  final List<Message> messages;
  final bool isStreaming;
  final List<ToolCall> executingTools;

  const ChatLoaded({
    required this.session,
    required this.messages,
    this.isStreaming = false,
    this.executingTools = const [],
  });

  ChatLoaded copyWith({
    Session? session,
    List<Message>? messages,
    bool? isStreaming,
    List<ToolCall>? executingTools,
  }) {
    return ChatLoaded(
      session: session ?? this.session,
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      executingTools: executingTools ?? this.executingTools,
    );
  }

  @override
  List<Object?> get props => [session, messages, isStreaming, executingTools];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
