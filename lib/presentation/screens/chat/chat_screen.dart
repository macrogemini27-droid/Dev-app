import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/message.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/chat_input.dart';
import '../../widgets/tool_execution_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId;

  const ChatScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadSessionEvent(sessionId: widget.sessionId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return Text(state.session.name);
            }
            return const Text('Chat');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show menu
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
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
                ],
              ),
            );
          }

          if (state is ChatLoaded) {
            return Column(
              children: [
                if (state.executingTools.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
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
                      children: state.executingTools
                          .map((tool) => ToolExecutionIndicator(toolCall: tool))
                          .toList(),
                    ),
                  ),
                Expanded(
                  child: state.messages.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                              message: state.messages[index],
                            );
                          },
                        ),
                ),
                ChatInput(
                  onSend: (content) {
                    context.read<ChatBloc>().add(
                          SendMessageEvent(content: content),
                        );
                  },
                  enabled: !state.isStreaming,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppTheme.textTertiaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to begin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
