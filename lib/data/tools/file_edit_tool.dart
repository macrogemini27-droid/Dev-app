import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileEditTool extends BaseTool {
  final SSHRepository sshRepository;

  FileEditTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'edit_file',
        description: 'Edit a file by replacing old string with new string',
        parameters: {
          'type': 'object',
          'properties': {
            'path': {
              'type': 'string',
              'description': 'The path to the file to edit',
            },
            'old_string': {
              'type': 'string',
              'description': 'The string to replace',
            },
            'new_string': {
              'type': 'string',
              'description': 'The replacement string',
            },
          },
          'required': ['path', 'old_string', 'new_string'],
        },
        isReadOnly: false,
        isConcurrencySafe: false,
      );

  @override
  bool get isReadOnly => false;

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final filePath = arguments['path'] as String;
    final oldString = arguments['old_string'] as String;
    final newString = arguments['new_string'] as String;

    // Read file first
    final readResult = await sshRepository.readFile(filePath);

    return await readResult.fold(
      (failure) async => 'Error reading file: ${failure.message}',
      (content) async {
        // Replace content
        final newContent = content.replaceAll(oldString, newString);

        // Write back
        final writeResult = await sshRepository.writeFile(filePath, newContent);

        return writeResult.fold(
          (failure) => 'Error writing file: ${failure.message}',
          (_) => 'Successfully edited $filePath',
        );
      },
    );
  }
}
