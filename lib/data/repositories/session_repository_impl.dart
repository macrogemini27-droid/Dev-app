import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/local/database_helper.dart';

class SessionRepositoryImpl implements SessionRepository {
  final DatabaseHelper databaseHelper;
  final _uuid = const Uuid();

  SessionRepositoryImpl({required this.databaseHelper});

  @override
  Future<Either<Failure, Session>> createSession({
    required String name,
    required String sshConfigId,
    required String providerId,
    required String workingDirectory,
  }) async {
    try {
      final db = await databaseHelper.database;
      final now = DateTime.now();
      final session = Session(
        id: _uuid.v4(),
        name: name,
        sshConfigId: sshConfigId,
        providerId: providerId,
        workingDirectory: workingDirectory,
        createdAt: now,
        updatedAt: now,
      );

      await db.insert('sessions', {
        'id': session.id,
        'name': session.name,
        'ssh_config_id': session.sshConfigId,
        'provider_id': session.providerId,
        'working_directory': session.workingDirectory,
        'created_at': session.createdAt.millisecondsSinceEpoch,
        'updated_at': session.updatedAt?.millisecondsSinceEpoch,
      });

      return Right(session);
    } on StorageException catch (e) {
      return Left(StorageFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to create session: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Session>> getSession(String id) async {
    try {
      final db = await databaseHelper.database;
      final results = await db.query(
        'sessions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) {
        return const Left(StorageFailure(message: 'Session not found'));
      }

      final sessionData = results.first;
      final session = Session(
        id: sessionData['id'] as String,
        name: sessionData['name'] as String,
        sshConfigId: sessionData['ssh_config_id'] as String,
        providerId: sessionData['provider_id'] as String,
        workingDirectory: sessionData['working_directory'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          sessionData['created_at'] as int,
        ),
        updatedAt: sessionData['updated_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                sessionData['updated_at'] as int,
              )
            : null,
      );

      return Right(session);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get session: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getAllSessions() async {
    try {
      final db = await databaseHelper.database;
      final results = await db.query(
        'sessions',
        orderBy: 'updated_at DESC',
      );

      final sessions = results.map((data) {
        return Session(
          id: data['id'] as String,
          name: data['name'] as String,
          sshConfigId: data['ssh_config_id'] as String,
          providerId: data['provider_id'] as String,
          workingDirectory: data['working_directory'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            data['created_at'] as int,
          ),
          updatedAt: data['updated_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  data['updated_at'] as int,
                )
              : null,
        );
      }).toList();

      return Right(sessions);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get sessions: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'sessions',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to delete session: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(Message message) async {
    try {
      final db = await databaseHelper.database;
      await db.insert('messages', {
        'id': message.id,
        'session_id': message.sessionId,
        'role': message.role.name,
        'content': message.content,
        'timestamp': message.timestamp.millisecondsSinceEpoch,
        'tool_calls': message.toolCalls != null
            ? jsonEncode(message.toolCalls!.map((tc) => tc.toJson()).toList())
            : null,
        'tool_results': message.toolResults != null
            ? jsonEncode(message.toolResults!.map((tr) => tr.toJson()).toList())
            : null,
        'status': message.status?.name,
      });

      // Update session updated_at
      await db.update(
        'sessions',
        {'updated_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [message.sessionId],
      );

      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to save message: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String sessionId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final db = await databaseHelper.database;
      final results = await db.query(
        'messages',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        orderBy: 'timestamp ASC',
        limit: limit,
        offset: offset,
      );

      final messages = results.map((data) {
        // Parse tool calls and results from JSON
        List<ToolCall>? toolCalls;
        if (data['tool_calls'] != null) {
          try {
            final toolCallsJson = jsonDecode(data['tool_calls'] as String) as List;
            toolCalls = toolCallsJson.map((tc) => ToolCall.fromJson(tc)).toList();
          } catch (e) {
            // Ignore parsing errors for backward compatibility
          }
        }

        List<ToolResult>? toolResults;
        if (data['tool_results'] != null) {
          try {
            final toolResultsJson = jsonDecode(data['tool_results'] as String) as List;
            toolResults = toolResultsJson.map((tr) => ToolResult.fromJson(tr)).toList();
          } catch (e) {
            // Ignore parsing errors for backward compatibility
          }
        }

        return Message(
          id: data['id'] as String,
          sessionId: data['session_id'] as String,
          role: MessageRole.values.firstWhere(
            (e) => e.name == data['role'],
          ),
          content: data['content'] as String,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            data['timestamp'] as int,
          ),
          toolCalls: toolCalls,
          toolResults: toolResults,
          status: data['status'] != null
              ? MessageStatus.values.firstWhere(
                  (e) => e.name == data['status'],
                )
              : null,
        );
      }).toList();

      return Right(messages);
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Failed to get messages: ${e.toString()}',
        details: e,
      ));
    }
  }
}
