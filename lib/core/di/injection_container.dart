import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/datasources/local/database_helper.dart';
import '../../data/datasources/local/local_storage_service.dart';
import '../../data/datasources/local/secure_storage_service.dart';
import '../../data/datasources/ssh/ssh_client_impl.dart';
import '../../data/datasources/api/anthropic_api_client.dart';
import '../../data/repositories/ssh_repository_impl.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../data/repositories/provider_repository_impl.dart';
import '../../data/repositories/tool_repository_impl.dart';
import '../../domain/repositories/ssh_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/repositories/provider_repository.dart';
import '../../domain/repositories/tool_repository.dart';
import '../../domain/usecases/ssh/connect_ssh.dart';
import '../../domain/usecases/ssh/disconnect_ssh.dart';
import '../../domain/usecases/ssh/execute_command.dart';
import '../../domain/usecases/session/create_session.dart';
import '../../domain/usecases/session/load_session.dart';
import '../../domain/usecases/session/save_message.dart';
import '../../domain/usecases/provider/add_provider.dart';
import '../../domain/usecases/provider/get_providers.dart';
import '../../domain/usecases/tool/execute_tool.dart';
import '../../presentation/blocs/connection/connection_bloc.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../../presentation/blocs/provider/provider_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  final database = await DatabaseHelper.instance.database;
  sl.registerLazySingleton(() => database);

  // Data Sources
  sl.registerLazySingleton(() => LocalStorageService(sl()));
  sl.registerLazySingleton(() => SecureStorageService(sl()));
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  sl.registerLazySingleton(() => SSHClientImpl());
  sl.registerLazySingleton(() => AnthropicApiClient());

  // Repositories
  sl.registerLazySingleton<SSHRepository>(
    () => SSHRepositoryImpl(sshClient: sl()),
  );
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ProviderRepository>(
    () => ProviderRepositoryImpl(
      localStorage: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<ToolRepository>(
    () => ToolRepositoryImpl(sshRepository: sl()),
  );

  // Use Cases - SSH
  sl.registerLazySingleton(() => ConnectSSH(sl()));
  sl.registerLazySingleton(() => DisconnectSSH(sl()));
  sl.registerLazySingleton(() => ExecuteCommand(sl()));

  // Use Cases - Session
  sl.registerLazySingleton(() => CreateSession(sl()));
  sl.registerLazySingleton(() => LoadSession(sl()));
  sl.registerLazySingleton(() => SaveMessage(sl()));

  // Use Cases - Provider
  sl.registerLazySingleton(() => AddProvider(sl()));
  sl.registerLazySingleton(() => GetProviders(sl()));

  // Use Cases - Tool
  sl.registerLazySingleton(() => ExecuteTool(sl()));

  // BLoCs
  sl.registerFactory(
    () => ConnectionBloc(
      connectSSH: sl(),
      disconnectSSH: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatBloc(
      executeTool: sl(),
      saveMessage: sl(),
      loadSession: sl(),
    ),
  );
  sl.registerFactory(
    () => ProviderBloc(
      addProvider: sl(),
      getProviders: sl(),
    ),
  );
}
