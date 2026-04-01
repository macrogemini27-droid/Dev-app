import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileWriteTool extends BaseTool {
  final SSHRepository sshRepository;

  FileWriteTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Write',
        description: 'Write content to a file on the remote server',
        inputSchema: {
          'type': 'object',
          'properties': {
            'file_path': {
              'type': 'string',
              'description': 'The absolute path to the file to write',
            },
            'content': {
              'type': 'string',
              'description': 'The content to write to the file',
            },
          },
          'required': ['file_path', 'content'],
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
    final content = input['content'] as String;

    final result = await sshRepository.writeFile(filePath, content);

    return result.fold(
      (failure) => ToolResult(
        toolCallId: '',
        content: 'Error writing file: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (_) => ToolResult(
        toolCallId: '',
        content: 'File written successfully: $filePath',
        isError: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
