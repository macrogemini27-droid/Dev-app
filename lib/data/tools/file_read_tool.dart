import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileReadTool extends BaseTool {
  final SSHRepository sshRepository;

  FileReadTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
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
        isReadOnly: true,
        isConcurrencySafe: true,
      );

  @override
  bool get isReadOnly => true;

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final filePath = arguments['path'] as String;

    final result = await sshRepository.readFile(filePath);

    return result.fold(
      (failure) => 'Error reading file: ${failure.message}',
      (content) => content,
    );
  }
}
