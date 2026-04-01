part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String content;

  const SendMessageEvent({required this.content});

  @override
  List<Object?> get props => [content];
}

class LoadSessionEvent extends ChatEvent {
  final String sessionId;

  const LoadSessionEvent({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

class ToolExecutionStartedEvent extends ChatEvent {
  final ToolCall toolCall;

  const ToolExecutionStartedEvent({required this.toolCall});

  @override
  List<Object?> get props => [toolCall];
}

class ToolExecutionCompletedEvent extends ChatEvent {
  final ToolCall toolCall;
  final ToolResult result;

  const ToolExecutionCompletedEvent({
    required this.toolCall,
    required this.result,
  });

  @override
  List<Object?> get props => [toolCall, result];
}

class StreamingChunkReceivedEvent extends ChatEvent {
  final String chunk;

  const StreamingChunkReceivedEvent({required this.chunk});

  @override
  List<Object?> get props => [chunk];
}
