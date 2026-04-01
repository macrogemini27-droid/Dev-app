import 'package:flutter/material.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/domain/entities/message.dart';

class ToolExecutionIndicator extends StatelessWidget {
  const ToolExecutionIndicator({
    super.key,
    required this.toolCall,
  });

  final ToolCall toolCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Executing: ${toolCall.name}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (toolCall.input.isNotEmpty)
                  Text(
                    _formatInput(toolCall.input),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Icon(
            _getToolIcon(toolCall.name),
            size: 20,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  String _formatInput(Map<String, dynamic> input) {
    if (input.isEmpty) return '';
    final firstKey = input.keys.first;
    final firstValue = input[firstKey];
    return '$firstKey: $firstValue';
  }

  IconData _getToolIcon(String toolName) {
    switch (toolName) {
      case 'Read':
        return Icons.description;
      case 'Write':
        return Icons.edit;
      case 'Edit':
        return Icons.edit_note;
      case 'Bash':
        return Icons.terminal;
      case 'Grep':
        return Icons.search;
      case 'Glob':
        return Icons.folder_open;
      default:
        return Icons.build;
    }
  }
}
