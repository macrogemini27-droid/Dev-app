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

  /// Dangerous command patterns that should be blocked for safety.
  static final _dangerousPatterns = [
    RegExp(r'rm\s+(-[a-zA-Z]*f[a-zA-Z]*\s+)?/\s*$'),
    RegExp(r'rm\s+-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*\s+/\s*$'),
    RegExp(r'mkfs\.'),
    RegExp(r'dd\s+.*of=/dev/'),
    RegExp(r':(\s*)\{\s*:\|:\s*&\s*\}\s*;\s*:'),
  ];

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final command = arguments['command'] as String;

    // Check for dangerous commands
    for (final pattern in _dangerousPatterns) {
      if (pattern.hasMatch(command)) {
        return 'Error: This command has been blocked for safety. '
            'It matches a dangerous pattern that could cause data loss.';
      }
    }

    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => 'Error: ${failure.message}',
      (output) => output,
    );
  }
}
