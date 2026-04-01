import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class GlobTool extends BaseTool {
  final SSHRepository sshRepository;

  GlobTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Glob',
        description: 'Find files matching a pattern',
        inputSchema: {
          'type': 'object',
          'properties': {
            'pattern': {
              'type': 'string',
              'description': 'The glob pattern to match (e.g., "*.dart")',
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

    final command = 'find $path -name "$pattern"';
    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => ToolResult(
        toolCallId: '',
        content: 'Find failed: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (output) => ToolResult(
        toolCallId: '',
        content: output.isEmpty ? 'No files found' : output,
        isError: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
