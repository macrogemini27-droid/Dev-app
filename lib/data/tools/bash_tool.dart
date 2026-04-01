import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class BashTool extends BaseTool {
  final SSHRepository sshRepository;

  BashTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'execute_command',
        description: 'Execute a shell command on the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'command': {
              'type': 'string',
              'description': 'The shell command to execute',
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
  Future<String> execute(Map<String, dynamic> arguments) async {
    final command = arguments['command'] as String;

    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => 'Error: ${failure.message}',
      (output) => output,
    );
  }
}
