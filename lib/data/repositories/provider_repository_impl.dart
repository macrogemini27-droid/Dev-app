import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../core/errors/failures.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/provider_repository.dart';
import '../datasources/local/local_storage_service.dart';
import '../datasources/local/secure_storage_service.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final LocalStorageService localStorage;
  final SecureStorageService secureStorage;
  final _uuid = const Uuid();

  static const String _providersKey = 'providers';
  static const String _defaultProviderKey = 'default_provider';
  static const String _apiKeyPrefix = 'provider_api_key_';

  ProviderRepositoryImpl({
    required this.localStorage,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, void>> addProvider(ProviderConfig provider) async {
    try {
      // Save API key to secure storage
      await secureStorage.write(
        '$_apiKeyPrefix${provider.id}',
        provider.apiKey,
      );

      // Save provider config (without API key) to local storage
      final providers = await _getProvidersList();
      final providerWithoutKey = provider.copyWith(apiKey: '');
      providers.add(providerWithoutKey.toJson());

      await localStorage.saveString(_providersKey, jsonEncode(providers));

      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to add provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProviderConfig>>> getAllProviders() async {
    try {
      final providers = await _getProvidersList();
      final providerConfigs = <ProviderConfig>[];

      for (final providerJson in providers) {
        final provider = ProviderConfig.fromJson(providerJson);
        final apiKey = await secureStorage.read(
          '$_apiKeyPrefix${provider.id}',
        );

        providerConfigs.add(provider.copyWith(apiKey: apiKey ?? ''));
      }

      return Right(providerConfigs);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to get providers: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ProviderConfig>> getProvider(String id) async {
    try {
      final providers = await _getProvidersList();
      final providerJson = providers.firstWhere(
        (p) => p['id'] == id,
        orElse: () => throw Exception('Provider not found'),
      );

      final provider = ProviderConfig.fromJson(providerJson);
      final apiKey = await secureStorage.read('$_apiKeyPrefix$id');

      return Right(provider.copyWith(apiKey: apiKey ?? ''));
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to get provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateProvider(ProviderConfig provider) async {
    try {
      // Update API key in secure storage
      await secureStorage.write(
        '$_apiKeyPrefix${provider.id}',
        provider.apiKey,
      );

      // Update provider config in local storage
      final providers = await _getProvidersList();
      final index = providers.indexWhere((p) => p['id'] == provider.id);

      if (index == -1) {
        return const Left(StorageFailure(message: 'Provider not found'));
      }

      final providerWithoutKey = provider.copyWith(apiKey: '');
      providers[index] = providerWithoutKey.toJson();

      await localStorage.saveString(_providersKey, jsonEncode(providers));

      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to update provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProvider(String id) async {
    try {
      // Delete API key from secure storage
      await secureStorage.delete('$_apiKeyPrefix$id');

      // Delete provider from local storage
      final providers = await _getProvidersList();
      providers.removeWhere((p) => p['id'] == id);

      await localStorage.saveString(_providersKey, jsonEncode(providers));

      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to delete provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ProviderConfig?>> getDefaultProvider() async {
    try {
      final defaultId = localStorage.getString(_defaultProviderKey);
      if (defaultId == null) return const Right(null);

      return await getProvider(defaultId);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to get default provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultProvider(String id) async {
    try {
      await localStorage.saveString(_defaultProviderKey, id);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to set default provider: ${e.toString()}',
        details: e,
      ));
    }
  }

  Future<List<Map<String, dynamic>>> _getProvidersList() async {
    final jsonString = localStorage.getString(_providersKey);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }
}
