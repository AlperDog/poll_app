import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/splash_auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/poll_detail_screen.dart';
import 'screens/live_results_screen.dart';
import 'screens/create_poll_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: PollApp()));
}

class PollApp extends StatelessWidget {
  const PollApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SplashAuthScreen(
            onContinue: (username) => context.go('/home'),
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(
            onPollTap: (pollId) => context.go('/poll/$pollId'),
            onCreatePoll: () => context.go('/create'),
            onAdmin: () => context.go('/admin'),
          ),
        ),
        GoRoute(
          path: '/poll/:pollId',
          builder: (context, state) {
            final pollId = state.pathParameters['pollId'] ?? '';
            return PollDetailScreen(
              pollId: pollId,
              onVote: (selected) => context.go('/results/$pollId'),
            );
          },
        ),
        GoRoute(
          path: '/results/:pollId',
          builder: (context, state) {
            final pollId = state.pathParameters['pollId'] ?? '';
            return LiveResultsScreen(pollId: pollId);
          },
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => CreatePollScreen(
            onCreate: (title, question, options, multiChoice) => context.go('/home'),
          ),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Poll App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
