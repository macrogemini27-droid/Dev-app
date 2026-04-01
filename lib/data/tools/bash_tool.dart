import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class BashTool extends BaseTool {
  final SSHRepository sshRepository;

  BashTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Bash',
        description: 'Execute a bash command on the remote server',
        inputSchema: {
          'type': 'object',
          'properties': {
            'command': {
              'type': 'string',
              'description': 'The bash command to execute',
            },
          },
          'required': ['command'],
        },
        isReadOnly: false,
        isConcurrencySafe: false,
      );

  @override
  bool get isReadOnly => false;

  @override
  Future<ToolResult> execute(
    Map<String, dynamic> input,
    ToolExecutionContext context,
  ) async {
    final command = input['command'] as String;

    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => ToolResult(
        toolCallId: '',
        content: 'Command failed: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (output) => ToolResult(
        toolCallId: '',
        content: output,
        isError: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
