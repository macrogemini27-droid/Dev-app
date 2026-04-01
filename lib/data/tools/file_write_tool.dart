import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileWriteTool extends BaseTool {
  final SSHRepository sshRepository;

  FileWriteTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'write_file',
        description: 'Write content to a file on the remote server',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The path to the file to write',
            },
            'content': {
              'type': 'string',
              'description': 'The content to write to the file',
            },
          },
          'required': ['path', 'content'],
        },
        isReadOnly: false,
        isConcurrencySafe: false,
      );

  @override
  bool get isReadOnly => false;

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final filePath = arguments['path'] as String;
    final content = arguments['content'] as String;

    final result = await sshRepository.writeFile(filePath, content);

    return result.fold(
      (failure) => 'Error writing file: ${failure.message}',
      (_) => 'Successfully wrote to $filePath',
    );
  }
}
