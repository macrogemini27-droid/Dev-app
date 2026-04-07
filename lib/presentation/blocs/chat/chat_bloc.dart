import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/entities/provider_config.dart';
import '../../../domain/entities/tool.dart';
import '../../../domain/usecases/tool/execute_tool.dart';
import '../../../domain/usecases/session/save_message.dart';
import '../../../domain/usecases/session/load_session.dart';
import '../../../domain/usecases/provider/get_providers.dart';
import '../../../data/datasources/api/api_client_factory.dart';
import '../../../data/datasources/api/base_api_client.dart';
import '../../../core/services/app_logger.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ExecuteTool executeTool;
  final SaveMessage saveMessage;
  final LoadSession loadSession;
  final GetProviders getProviders;
  final _uuid = const Uuid();
  final _logger = AppLogger();
  
  BaseApiClient? _apiClient;
  StreamSubscription? _streamSubscription;

  ChatBloc({
    required this.executeTool,
    required this.saveMessage,
    required this.loadSession,
    required this.getProviders,
  }) : super(ChatInitial()) {
    _logger.info('ChatBloc initialized', tag: 'ChatBloc');
    on<SendMessageEvent>(_onSendMessage);
    on<LoadSessionEvent>(_onLoadSession);
    on<ToolExecutionStartedEvent>(_onToolExecutionStarted);
    on<ToolExecutionCompletedEvent>(_onToolExecutionCompleted);
    on<StreamingChunkReceivedEvent>(_onStreamingChunkReceived);
  }

  @override
  Future<void> close() {
    _logger.debug('ChatBloc closing', tag: 'ChatBloc');
    _streamSubscription?.cancel();
    _apiClient?.dispose();
    return super.close();
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) {
      _logger.warning('Attempted to send message but chat not loaded', tag: 'ChatBloc');
      return;
    }

    _logger.info('Sending message: ${event.content.substring(0, event.content.length > 50 ? 50 : event.content.length)}...', tag: 'ChatBloc');
    final currentState = state as ChatLoaded;
    
    // Get default provider
    _logger.debug('Getting default provider', tag: 'ChatBloc');
    final providersResult = await getProviders();
    ProviderConfig? defaultProvider;
    
    providersResult.fold(
      (failure) {
        _logger.error('Failed to get providers: ${failure.toString()}', tag: 'ChatBloc');
        return null;
      },
      (providers) {
        if (providers.isNotEmpty) {
          defaultProvider = providers.firstWhere(
            (p) => p.isDefault,
            orElse: () => providers.first,
          );
          _logger.debug('Using provider: ${defaultProvider!.name}', tag: 'ChatBloc');
        }
      },
    );

    if (defaultProvider == null) {
      _logger.error('No provider configured', tag: 'ChatBloc');
      emit(ChatError(message: 'No provider configured. Please add a provider in settings.'));
      return;
    }

    // Create user message
    final userMessage = Message(
      id: _uuid.v4(),
      sessionId: currentState.session.id,
      role: MessageRole.user,
      content: event.content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    _logger.debug('Created user message: ${userMessage.id}', tag: 'ChatBloc');

    // Add user message to UI
    final messagesWithUser = [...currentState.messages, userMessage];
    emit(currentState.copyWith(
      messages: messagesWithUser,
    ));

    // Save user message
    _logger.debug('Saving user message to database', tag: 'ChatBloc');
    await saveMessage(userMessage);

    // Create empty assistant message for streaming
    final assistantMessageId = _uuid.v4();
    final assistantMessage = Message(
      id: assistantMessageId,
      sessionId: currentState.session.id,
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    emit(currentState.copyWith(
      messages: [...messagesWithUser, assistantMessage],
      isStreaming: true,
    ));

    // Initialize API client
    _logger.debug('Initializing API client', tag: 'ChatBloc');
    _apiClient?.dispose();
    _apiClient = ApiClientFactory.createClient(defaultProvider!);

    // Get available tools
    final tools = _getAvailableTools();
    _logger.debug('Available tools: ${tools.length}', tag: 'ChatBloc');

    // Build system prompt
    final systemPrompt = _buildSystemPrompt();

    try {
      _logger.info('Starting streaming chat completion', tag: 'ChatBloc');
      // Stream the response
      final stream = _apiClient!.streamChatCompletion(
        messages: currentState.messages.where((m) => m.id != assistantMessageId).toList(),
        tools: tools,
        systemPrompt: systemPrompt,
      );

      String accumulatedContent = '';
      int chunkCount = 0;

      await for (final event in stream) {
        if (event is TextChunkEvent) {
          chunkCount++;
          accumulatedContent += event.text;
          add(StreamingChunkReceivedEvent(chunk: event.text));
        } else if (event is ToolCallEvent) {
          _logger.info('Tool call received: ${event.toolName}', tag: 'ChatBloc');
          // Handle tool execution
          add(ToolExecutionStartedEvent(
            toolCall: ToolCall(
              id: event.toolCallId,
              name: event.toolName,
              input: event.arguments,
            ),
          ));

          // Execute the tool
          final toolResult = await _executeToolCall(event);
          
          add(ToolExecutionCompletedEvent(
            toolCall: ToolCall(
              id: event.toolCallId,
              name: event.toolName,
              input: event.arguments,
            ),
            result: ToolResult(
              toolCallId: event.toolCallId,
              content: toolResult,
            ),
          ));

          // Add tool result to accumulated content
          accumulatedContent += '\n\n[Tool: ${event.toolName}]\n$toolResult';
        } else if (event is StreamEndEvent) {
          _logger.info('Streaming completed. Received $chunkCount chunks', tag: 'ChatBloc');
          // Streaming completed
          break;
        } else if (event is StreamErrorEvent) {
          _logger.error('Stream error: ${event.error}', tag: 'ChatBloc');
          emit(ChatError(message: event.error));
          return;
        }
      }

      // Update final message
      _logger.debug('Saving final assistant message', tag: 'ChatBloc');
      final finalMessage = assistantMessage.copyWith(
        content: accumulatedContent,
        status: MessageStatus.completed,
      );

      if (state is ChatLoaded) {
        final updatedState = state as ChatLoaded;
        final messages = [...updatedState.messages];
        final index = messages.indexWhere((m) => m.id == assistantMessageId);
        if (index != -1) {
          messages[index] = finalMessage;
        }

        emit(updatedState.copyWith(
          messages: messages,
          isStreaming: false,
        ));
      }

      // Save final message
      await saveMessage(finalMessage);
      _logger.info('Message exchange completed successfully', tag: 'ChatBloc');
    } catch (e, stackTrace) {
      _logger.error('Failed to send message', error: e, stackTrace: stackTrace, tag: 'ChatBloc');
      emit(ChatError(message: 'Failed to send message: $e'));
    }
  }

  Future<String> _executeToolCall(ToolCallEvent event) async {
    _logger.info('Executing tool: ${event.toolName}', tag: 'ChatBloc');
    _logger.debug('Tool arguments: ${event.arguments}', tag: 'ChatBloc');
    
    final result = await executeTool(
      ToolExecutionParams(
        toolName: event.toolName,
        arguments: event.arguments,
      ),
    );

    return result.fold(
      (failure) {
        _logger.error('Tool execution failed: ${failure.toString()}', tag: 'ChatBloc');
        return 'Error: ${failure.toString()}';
      },
      (output) {
        _logger.info('Tool executed successfully: ${event.toolName}', tag: 'ChatBloc');
        return output;
      },
    );
  }

  Future<void> _onLoadSession(
    LoadSessionEvent event,
    Emitter<ChatState> emit,
  ) async {
    _logger.info('Loading session: ${event.sessionId}', tag: 'ChatBloc');
    emit(ChatLoading());

    final result = await loadSession(event.sessionId);

    if (result.isRight()) {
      final session = result.getOrElse(() => throw StateError('unreachable'));
      _logger.info('Session loaded successfully with ${session.messages.length} messages', tag: 'ChatBloc');
      emit(ChatLoaded(
        session: session,
        messages: session.messages,
      ));
      return;
    }

    // Handle failure
    final failure = result.fold((f) => f, (_) => throw StateError('unreachable'));
    _logger.warning('Session not found: ${event.sessionId}', tag: 'ChatBloc');

    if (!failure.toString().contains('Session not found')) {
      _logger.error('Failed to load session: ${failure.toString()}', tag: 'ChatBloc');
      emit(ChatError(message: failure.toString()));
      return;
    }

    // Session not found — create a new one
    final providersResult = await getProviders();

    if (providersResult.isLeft()) {
      _logger.error('No provider configured', tag: 'ChatBloc');
      emit(ChatError(message: 'No provider configured. Please add a provider in settings.'));
      return;
    }

    final providers = providersResult.getOrElse(() => []);
    if (providers.isEmpty) {
      _logger.error('No providers available', tag: 'ChatBloc');
      emit(ChatError(message: 'No provider configured. Please add a provider in settings.'));
      return;
    }

    final defaultProvider = providers.firstWhere(
      (p) => p.isDefault,
      orElse: () => providers.first,
    );

    _logger.info('Creating new session with provider: ${defaultProvider.name}', tag: 'ChatBloc');
    final newSession = Session(
      id: event.sessionId,
      name: 'New Chat',
      sshConfigId: 'default',
      providerId: defaultProvider.id,
      workingDirectory: '/home',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
    );

    emit(ChatLoaded(
      session: newSession,
      messages: [],
    ));
  }

  List<Tool> _getAvailableTools() {
    return [
      Tool(
        name: 'read_file',
        description: 'Read the contents of a file from the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The path to the file to read',
            },
          },
          'required': ['path'],
        },
      ),
      Tool(
        name: 'write_file',
        description: 'Write content to a file on the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The path to the file to write',
            },
            'content': {
              'type': 'string',
              'description': 'The content to write to the file',
            },
          },
          'required': ['path', 'content'],
        },
      ),
      Tool(
        name: 'execute_command',
        description: 'Execute a shell command on the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'command': {
              'type': 'string',
              'description': 'The command to execute',
            },
          },
          'required': ['command'],
        },
      ),
      Tool(
        name: 'list_files',
        description: 'List files in a directory on the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The directory path to list',
            },
          },
          'required': ['path'],
        },
      ),
    ];
  }

  String _buildSystemPrompt() {
    return '''You are Claude Code, an AI coding assistant that helps developers write, debug, and understand code.

You have access to a remote server via SSH and can:
- Read and write files
- Execute shell commands
- List directory contents
- Search for files and content

When helping users:
1. Always explain what you're doing before using tools
2. Show the results of tool executions
3. Provide clear, actionable suggestions
4. Write clean, well-documented code
5. Follow best practices and coding standards

You are currently connected to a remote server. Use the available tools to help the user with their coding tasks.''';
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
