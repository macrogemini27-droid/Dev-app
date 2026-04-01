import '../../domain/entities/tool.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class FileReadTool extends BaseTool {
  final SSHRepository sshRepository;

  FileReadTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'Read',
        description: 'Read a file from the remote server',
        inputSchema: {
          'type': 'object',
          'properties': {
            'file_path': {
              'type': 'string',
              'description': 'The absolute path to the file to read',
            },
          },
          'required': ['file_path'],
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
    final filePath = input['file_path'] as String;

    final result = await sshRepository.readFile(filePath);

    return result.fold(
      (failure) => ToolResult(
        toolCallId: '',
        content: 'Error reading file: ${failure.message}',
        isError: true,
        timestamp: DateTime.now(),
      ),
      (content) => ToolResult(
        toolCallId: '',
        content: content,
        isError: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}
