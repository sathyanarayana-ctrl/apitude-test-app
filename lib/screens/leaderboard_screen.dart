import 'package:flutter/material.dart';

import '../services/firebase_bootstrap.dart';
import '../services/leaderboard_service.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.enabled) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Leaderboard')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Firebase is not configured yet.\n\n'
              'Run:\n'
              '1. dart pub global activate flutterfire_cli\n'
              '2. flutterfire configure\n'
              '3. Restart the app',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Leaderboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.wifi, color: Colors.lightGreenAccent),
          ),
        ],
      ),
      body: StreamBuilder<List<LeaderboardEntry>>(
        stream: LeaderboardService.watchTopScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'No scores yet.\nComplete a test while logged in to appear here.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final medal = index == 0
                  ? '🥇'
                  : index == 1
                      ? '🥈'
                      : index == 2
                          ? '🥉'
                          : '${index + 1}';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      '$medal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(entry.userName),
                  subtitle: Text(
                    '${entry.testName} • '
                    '${entry.correctCount}/${entry.totalQuestions} correct',
                  ),
                  trailing: Text(
                    '${entry.score.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
