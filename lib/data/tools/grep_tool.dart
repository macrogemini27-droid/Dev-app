import '../../domain/entities/tool.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../repositories/tool_repository_impl.dart';

class GrepTool extends BaseTool {
  final SSHRepository sshRepository;

  GrepTool(this.sshRepository);

  @override
  Tool get definition => const Tool(
        name: 'search_files',
        description: 'Search for a pattern in files using grep',
        parameters: {
          'type': 'object',
          'properties': {
            'pattern': {
              'type': 'string',
              'description': 'The pattern to search for',
            },
            'path': {
              'type': 'string',
              'description': 'The path to search in (default: current directory)',
            },
          },
          'required': ['pattern'],
        },
        isReadOnly: true,
        isConcurrencySafe: true,
      );

  @override
  bool get isReadOnly => true;

  @override
  Future<String> execute(Map<String, dynamic> arguments) async {
    final pattern = arguments['pattern'] as String;
    final path = arguments['path'] as String? ?? '.';

    // Escape shell arguments to prevent command injection
    final escapedPattern = _escapeShellArg(pattern);
    final escapedPath = _escapeShellArg(path);

    final command = 'grep -r $escapedPattern $escapedPath';
    final result = await sshRepository.executeCommand(command);

    return result.fold(
      (failure) => 'Search failed: ${failure.message}',
      (output) => output.isEmpty ? 'No matches found' : output,
    );
  }

  /// Escapes a shell argument by wrapping it in single quotes
  /// and escaping any single quotes within the argument
  String _escapeShellArg(String arg) {
    // Replace single quotes with '\'' (end quote, escaped quote, start quote)
    final escaped = arg.replaceAll("'", "'\\''");
    return "'$escaped'";
  }
}
