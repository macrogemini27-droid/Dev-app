import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class GrepTool extends BaseTool {
  final SSHRepository sshRepository;

  GrepTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Grep',
        description: 'Search for a pattern in files',
        inputSchema: {
          'type': 'object',
          'properties': {
            'pattern': {
              'type': 'string',
              'description': 'The pattern to search for',
            },
            'path': {
              'type': 'string',
              'description': 'The path to search in (default: current directory)',
            },
          },
          'required': ['pattern'],
        },
        isReadOnly: true,
        isConcurrencySafe: true,
      );

  @override
  bool get isReadOnly => true;

  @override
  Future<ToolResult> execute(
    Map<String, dynamic> input,
    ToolExecutionContext context,
  ) async {
    final pattern = input['pattern'] as String;
    final path = input['path'] as String? ?? '.';

    final command = 'grep -r "$pattern" $path';
    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => ToolResult(
        toolCallId: '',
        content: 'Search failed: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (output) => ToolResult(
        toolCallId: '',
        content: output.isEmpty ? 'No matches found' : output,
        isError: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
