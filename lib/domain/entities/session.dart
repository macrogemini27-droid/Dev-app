import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    required String name,
    required String sshConfigId,
    required String providerId,
    required String workingDirectory,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<Message> messages,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
