import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileEditTool extends BaseTool {
  final SSHRepository sshRepository;

  FileEditTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Edit',
        description: 'Edit a file by replacing old string with new string',
        inputSchema: {
          'type': 'object',
          'properties': {
            'file_path': {
              'type': 'string',
              'description': 'The absolute path to the file to edit',
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
          'required': ['file_path', 'old_string', 'new_string'],
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
    final filePath = input['file_path'] as String;
    final oldString = input['old_string'] as String;
    final newString = input['new_string'] as String;

    // Read file first
    final readResult = await sshRepository.readFile(filePath);

    return await readResult.fold(
      (failure) async => ToolResult(
        toolCallId: '',
        content: 'Error reading file: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (content) async {
        // Replace content
        final newContent = content.replaceAll(oldString, newString);

        // Write back
        final writeResult = await sshRepository.writeFile(filePath, newContent);

        return writeResult.fold(
          (failure) => ToolResult(
            toolCallId: '',
            content: 'Error writing file: ${failure.message}',
            isError: true,
            timestamp: DateTime.now(),
          ),
          (_) => ToolResult(
            toolCallId: '',
            content: 'File edited successfully: $filePath',
            isError: false,
            timestamp: DateTime.now(),
          ),
        );
      },
    );
  }
}
