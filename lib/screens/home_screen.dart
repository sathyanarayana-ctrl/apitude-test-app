import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions_repository.dart';
import '../models/question_type.dart';
import '../providers/quiz_session.dart';
import '../services/auth_service.dart';
import '../services/firebase_bootstrap.dart';
import 'category_screen.dart';
import 'leaderboard_screen.dart';
import 'login_screen.dart';
import 'quiz_screen.dart';
import 'test_papers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalQuestions = QuestionsRepository.allQuestions.length;
    final categoryCount = QuestionType.values.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aptitude Test'),
        actions: [
          if (FirebaseBootstrap.enabled)
            IconButton(
              tooltip: 'Live Leaderboard',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              ),
              icon: const Icon(Icons.leaderboard),
            ),
          IconButton(
            tooltip: context.watch<AuthService>().isLoggedIn ? 'Logout' : 'Login',
            onPressed: () async {
              final auth = context.read<AuthService>();
              if (auth.isLoggedIn) {
                await auth.signOut();
              } else {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            icon: Icon(
              context.watch<AuthService>().isLoggedIn
                  ? Icons.logout
                  : Icons.login,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (FirebaseBootstrap.enabled)
                Card(
                  color: Colors.green.shade50,
                  child: const ListTile(
                    leading: Icon(Icons.cloud_done, color: Colors.green),
                    title: Text('Real-time mode active'),
                    subtitle: Text('Scores sync live to Firebase leaderboard'),
                  ),
                )
              else
                Card(
                  color: Colors.orange.shade50,
                  child: const ListTile(
                    leading: Icon(Icons.cloud_off, color: Colors.orange),
                    title: Text('Offline mode'),
                    subtitle: Text('Run flutterfire configure to enable real-time'),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        '🎓',
                        style: TextStyle(fontSize: 56),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Master Every Aptitude Topic',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$categoryCount categories • $totalQuestions practice questions',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _ActionCard(
                icon: '📚',
                title: 'Practice by Category',
                subtitle: 'Choose one topic and practice MCQs',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: '📄',
                title: 'Test Papers',
                subtitle: '13 full test papers — all aptitude types',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestPapersScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: '🏆',
                title: 'Live Leaderboard',
                subtitle: 'Real-time top scores from all users',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: '⏱️',
                title: 'Full Mock Test',
                subtitle: '20 mixed questions with 20-minute timer',
                onTap: () => _startMockTest(context, timed: true),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: '📝',
                title: 'Quick Practice',
                subtitle: '10 random questions, no timer',
                onTap: () => _startMockTest(context, timed: false),
              ),
              const SizedBox(height: 24),
              Text(
                'All question types included',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: QuestionType.values
                    .map(
                      (type) => Chip(
                        avatar: Text(type.icon),
                        label: Text(
                          type.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startMockTest(BuildContext context, {required bool timed}) {
    final questions = QuestionsRepository.mixed(count: timed ? 20 : 10);
    final session = QuizSession(
      title: timed ? 'Full Mock Test' : 'Quick Practice',
      questions: questions,
      timeLimitSeconds: timed ? 20 * 60 : 0,
    )..start();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(session: session),
      ),
    ).then((_) => session.dispose());
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
