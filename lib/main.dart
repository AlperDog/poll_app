import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/splash_auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/poll_detail_screen.dart';
import 'screens/live_results_screen.dart';
import 'screens/create_poll_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/user_profile_screen.dart';

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
          path: '/profile',
          builder: (context, state) => const UserProfileScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(
            onPollTap: (pollId) => context.go('/poll/$pollId'),
            onCreatePoll: () => context.go('/create'),
            onAdmin: () => context.go('/admin'),
            onProfile: () => context.go('/profile'),
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
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => CreatePollScreen(
              onCreate: (title, question, options, multiChoice, {bool isDraft = false}) {
                final polls = ref.read(pollsProvider.notifier);
                final uuid = UniqueKey().toString();
                final now = DateTime.now();
                final pollOptions = options.map((opt) => PollOption(id: UniqueKey().toString(), text: opt)).toList();
                final newPoll = Poll(
                  id: uuid,
                  title: title,
                  question: question,
                  options: pollOptions,
                  status: isDraft ? PollStatus.draft : PollStatus.live,
                  allowMultipleChoices: multiChoice,
                  createdAt: now,
                );
                polls.addPoll(newPoll);
                context.go('/home');
              },
            ),
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
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
