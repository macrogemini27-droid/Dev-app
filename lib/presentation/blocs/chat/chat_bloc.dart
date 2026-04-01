import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/entities/tool.dart';
import '../../../domain/usecases/tool/execute_tool.dart';
import '../../../domain/usecases/session/save_message.dart';
import '../../../domain/usecases/session/load_session.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ExecuteTool executeTool;
  final SaveMessage saveMessage;
  final LoadSession loadSession;
  final _uuid = const Uuid();

  ChatBloc({
    required this.executeTool,
    required this.saveMessage,
    required this.loadSession,
  }) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadSessionEvent>(_onLoadSession);
    on<ToolExecutionStartedEvent>(_onToolExecutionStarted);
    on<ToolExecutionCompletedEvent>(_onToolExecutionCompleted);
    on<StreamingChunkReceivedEvent>(_onStreamingChunkReceived);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    final userMessage = Message(
      id: _uuid.v4(),
      sessionId: currentState.session.id,
      role: MessageRole.user,
      content: event.content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    // Add user message
    emit(currentState.copyWith(
      messages: [...currentState.messages, userMessage],
    ));

    // Save user message
    await saveMessage(userMessage);

    // Start streaming assistant response
    emit(currentState.copyWith(
      isStreaming: true,
    ));

    // TODO: Integrate with API client for streaming
    // For now, simulate a response
    await Future.delayed(const Duration(seconds: 1));

    final assistantMessage = Message(
      id: _uuid.v4(),
      sessionId: currentState.session.id,
      role: MessageRole.assistant,
      content: 'This is a simulated response. API integration pending.',
      timestamp: DateTime.now(),
      status: MessageStatus.completed,
    );

    emit(currentState.copyWith(
      messages: [...currentState.messages, assistantMessage],
      isStreaming: false,
    ));

    await saveMessage(assistantMessage);
  }

  Future<void> _onLoadSession(
    LoadSessionEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await loadSession(event.sessionId);

    result.fold(
      (failure) => emit(ChatError(message: failure.toString())),
      (session) => emit(ChatLoaded(
        session: session,
        messages: session.messages,
      )),
    );
  }

  void _onToolExecutionStarted(
    ToolExecutionStartedEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    emit(currentState.copyWith(
      executingTools: [...currentState.executingTools, event.toolCall],
    ));
  }

  void _onToolExecutionCompleted(
    ToolExecutionCompletedEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    final updatedTools = currentState.executingTools
        .where((tool) => tool.id != event.toolCall.id)
        .toList();

    emit(currentState.copyWith(
      executingTools: updatedTools,
    ));
  }

  void _onStreamingChunkReceived(
    StreamingChunkReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    // Update the last message with streaming content
    if (currentState.messages.isNotEmpty) {
      final messages = [...currentState.messages];
      final lastMessage = messages.last;

      if (lastMessage.role == MessageRole.assistant) {
        messages[messages.length - 1] = lastMessage.copyWith(
          content: lastMessage.content + event.chunk,
        );

        emit(currentState.copyWith(messages: messages));
      }
    }
  }
}
