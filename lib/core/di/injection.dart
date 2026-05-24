import 'package:shule_direct/core/constants/import_files.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

  sl.registerLazySingleton<SecureStorage>(() => SecureStorage(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  sl.registerLazySingleton<ApiService>(() => ApiService(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiService>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        secureStorage: sl(),
      ));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerFactory(() => AuthCubit(sl()));

  sl.registerLazySingleton<ConversationRemoteDataSource>(
      () => ConversationRemoteDataSourceImpl(sl<ApiService>()));
  sl.registerLazySingleton<ConversationRepository>(
      () => ConversationRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetConversationsUsecase(sl()));
  sl.registerFactory(() => ConversationCubit(sl()));

  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(sl<ApiService>()));
  sl.registerFactory(() => ChatWebSocketDataSource());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        remoteDataSource: sl(),
        secureStorage: sl(),
      ));
  sl.registerLazySingleton(() => GetMessagesUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => DeleteMessageUsecase(sl()));
  sl.registerFactory(() => ChatCubit(
        getMessagesUsecase: sl(),
        sendMessageUsecase: sl(),
        deleteMessageUsecase: sl(),
        webSocketDataSource: sl(),
        secureStorage: sl(),
      ));
}
