import 'package:dartz/dartz.dart';
import '../entities/tool.dart';
import '../../core/errors/failures.dart';

abstract class ToolRepository {
  Future<Either<Failure, String>> executeTool({
    required String toolName,
    required Map<String, dynamic> arguments,
  });

  List<Tool> getAvailableTools();
  Tool? getTool(String name);
}
