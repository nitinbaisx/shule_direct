import 'package:shule_direct/core/constants/import_files.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final secureStorage = sl<SecureStorage>();
    final hasToken = await secureStorage.hasToken();
    final isLoginRoute = state.matchedLocation == '/login';
    if (hasToken && isLoginRoute) return '/conversations';
    if (!hasToken && !isLoginRoute) return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/conversations',
      builder: (context, state) => const ConversationListScreen(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final name = state.extra as String? ?? 'Group Chat';
        return ChatScreen(conversationId: id, groupName: name);
      },
    ),
  ],
);