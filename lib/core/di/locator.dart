import 'package:ai_assistant/core/network/api_service.dart';
import 'package:ai_assistant/data/repositories/chat_repository_impl.dart';
import 'package:ai_assistant/domain/chat_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(locator<ApiService>()));
}
