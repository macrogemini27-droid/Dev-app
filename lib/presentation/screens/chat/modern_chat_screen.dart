import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/message.dart' as domain;
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/connection/connection_bloc.dart' as connection;

class ModernChatScreen extends StatefulWidget {
  final String sessionId;

  const ModernChatScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<ModernChatScreen> createState() => _ModernChatScreenState();
}

class _ModernChatScreenState extends State<ModernChatScreen> {
  final _user = const types.User(id: 'user');
  final _assistant = const types.User(id: 'assistant', firstName: 'Claude');

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadSessionEvent(sessionId: widget.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.session.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
                    builder: (context, connState) {
                      if (connState is connection.ConnectionConnected) {
                        return Text(
                          'Connected to ${connState.config.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.successColor,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            }
            return const Text('Chat');
          },
        ),
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded && state.isStreaming) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  _showClearConfirmation();
                  break;
                case 'export':
                  // TODO: Export chat
                  break;
                case 'settings':
                  // TODO: Show settings
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 12),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading chat',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ChatBloc>().add(
                            LoadSessionEvent(sessionId: widget.sessionId),
                          );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ChatLoaded) {
            return Column(
              children: [
                // Tool execution indicators
                if (state.executingTools.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.borderColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Executing tools...',
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...state.executingTools.map((tool) => Padding(
                              padding: const EdgeInsets.only(left: 28, top: 4),
                              child: Text(
                                '• ${tool.name}',
                                style: TextStyle(
                                  color: AppTheme.textTertiaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                
                // Chat messages
                Expanded(
                  child: Chat(
                    messages: _convertMessages(state.messages),
                    onSendPressed: (message) {
                      context.read<ChatBloc>().add(
                            SendMessageEvent(content: message.text),
                          );
                    },
                    user: _user,
                    theme: _buildChatTheme(),
                    showUserAvatars: true,
                    showUserNames: false,
                    inputOptions: InputOptions(
                      enabled: !state.isStreaming,
                      sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                    ),
                    emptyState: _buildEmptyState(),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<types.Message> _convertMessages(List<domain.Message> messages) {
    return messages.reversed.map((msg) {
      return types.TextMessage(
        author: msg.role == domain.MessageRole.user ? _user : _assistant,
        createdAt: msg.timestamp.millisecondsSinceEpoch,
        id: msg.id,
        text: msg.content,
        status: msg.status == domain.MessageStatus.sending
            ? types.Status.sending
            : msg.status == domain.MessageStatus.sent
                ? types.Status.sent
                : types.Status.delivered,
      );
    }).toList();
  }

  DefaultChatTheme _buildChatTheme() {
    return DefaultChatTheme(
      backgroundColor: AppTheme.backgroundColor,
      primaryColor: AppTheme.primaryColor,
      secondaryColor: AppTheme.surfaceColor,
      inputBackgroundColor: AppTheme.surfaceColor,
      inputTextColor: AppTheme.textPrimaryColor,
      inputBorderRadius: BorderRadius.circular(24),
      messageBorderRadius: 16,
      userAvatarNameColors: [AppTheme.primaryColor],
      receivedMessageBodyTextStyle: TextStyle(
        color: AppTheme.textPrimaryColor,
        fontSize: 16,
        height: 1.5,
      ),
      sentMessageBodyTextStyle: TextStyle(
        color: AppTheme.textPrimaryColor,
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Start Coding with AI',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask me to write code, fix bugs, or explain complex logic.\nI can read files, execute commands, and help you build faster.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textTertiaryColor,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('Write tests for auth module'),
                _buildSuggestionChip('Fix all lint errors'),
                _buildSuggestionChip('Explain this codebase'),
                _buildSuggestionChip('Add dark mode support'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        context.read<ChatBloc>().add(SendMessageEvent(content: text));
      },
      backgroundColor: AppTheme.surfaceColor,
      labelStyle: TextStyle(
        color: AppTheme.textSecondaryColor,
        fontSize: 14,
      ),
      side: BorderSide(color: AppTheme.borderColor),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Clear chat
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
