import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class GlobTool extends BaseTool {
  final SSHRepository sshRepository;

  GlobTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'list_files',
        description: 'List files in a directory or find files matching a pattern',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The directory path to list',
            },
            'pattern': {
              'type': 'string',
              'description': 'Optional glob pattern to match (e.g., "*.dart")',
            },
          },
          'required': ['path'],
        },
        isReadOnly: true,
        isConcurrencySafe: true,
      );

  @override
  bool get isReadOnly => true;

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final path = arguments['path'] as String;
    final pattern = arguments['pattern'] as String?;

    final command = pattern != null
        ? 'find $path -name "$pattern"'
        : 'ls -la $path';
    
    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => 'List failed: ${failure.message}',
      (output) => output.isEmpty ? 'No files found' : output,
    );
  }
}
