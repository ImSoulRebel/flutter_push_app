import 'package:flutter_push/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Define your routes here
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/notification-detail/:id',
      builder: (context, state) {
        final pushMessageId = state.pathParameters['id']!;
        return NotificationDetailScreen(pushMessageId: pushMessageId);
      },
    ),
  ],
);
