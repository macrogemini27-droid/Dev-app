import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/ssh_config_repository.dart';
import '../../domain/entities/ssh_config.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local/local_storage_service.dart';
import '../datasources/local/secure_storage_service.dart';

class SSHConfigRepositoryImpl implements SSHConfigRepository {
  final LocalStorageService localStorage;
  final SecureStorageService secureStorage;

  static const String _configsKey = 'ssh_configs';
  static const String _passwordPrefix = 'ssh_password_';

  SSHConfigRepositoryImpl({
    required this.localStorage,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, List<SSHConfig>>> getSavedConfigs() async {
    try {
      final configsJson = await localStorage.getString(_configsKey);
      if (configsJson == null) {
        return const Right([]);
      }

      final List<dynamic> configsList = jsonDecode(configsJson);
      final configs = <SSHConfig>[];

      for (var configMap in configsList) {
        final config = SSHConfig.fromJson(configMap);
        
        // Load password from secure storage if it exists
        if (config.authType == SSHAuthType.password) {
          final password = await secureStorage.read('$_passwordPrefix${config.id}');
          configs.add(config.copyWith(password: password));
        } else {
          configs.add(config);
        }
      }

      return Right(configs);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveConfig(SSHConfig config) async {
    try {
      // Get existing configs
      final configsResult = await getSavedConfigs();
      final configs = configsResult.fold(
        (failure) => <SSHConfig>[],
        (configs) => configs,
      );

      // Check if config already exists
      final existingIndex = configs.indexWhere((c) => c.id == config.id);
      if (existingIndex != -1) {
        configs[existingIndex] = config;
      } else {
        configs.add(config);
      }

      // Save password to secure storage
      if (config.password != null) {
        await secureStorage.write(
          '$_passwordPrefix${config.id}',
          config.password!,
        );
      }

      // Save configs without passwords
      final configsToSave = configs.map((c) => 
        c.copyWith(password: null).toJson()
      ).toList();

      await localStorage.saveString(_configsKey, jsonEncode(configsToSave));

      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConfig(String id) async {
    try {
      final configsResult = await getSavedConfigs();
      final configs = configsResult.fold(
        (failure) => <SSHConfig>[],
        (configs) => configs,
      );

      configs.removeWhere((c) => c.id == id);

      // Delete password from secure storage
      await secureStorage.delete('$_passwordPrefix$id');

      // Save updated configs
      final configsToSave = configs.map((c) => 
        c.copyWith(password: null).toJson()
      ).toList();

      await localStorage.saveString(_configsKey, jsonEncode(configsToSave));

      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SSHConfig>> getConfigById(String id) async {
    try {
      final configsResult = await getSavedConfigs();
      final configs = configsResult.fold(
        (failure) => <SSHConfig>[],
        (configs) => configs,
      );

      final config = configs.firstWhere(
        (c) => c.id == id,
        orElse: () => throw StorageException(message: 'Config not found'),
      );

      return Right(config);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateConfig(SSHConfig config) async {
    return saveConfig(config);
  }
}
