import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_session.dart';
import '../services/auth_service.dart';
import '../services/firebase_bootstrap.dart';
import '../services/leaderboard_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.session});

  final QuizSession session;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _scoreSaved = false;

  @override
  void initState() {
    super.initState();
    _saveScoreIfPossible();
  }

  Future<void> _saveScoreIfPossible() async {
    if (_scoreSaved || !FirebaseBootstrap.enabled) return;

    final auth = context.read<AuthService>();
    final user = auth.currentUser;
    if (user == null) return;

    await LeaderboardService.saveScore(
      userId: user.uid,
      userName: auth.displayName,
      testName: widget.session.title,
      score: widget.session.scorePercent,
      correctCount: widget.session.correctCount,
      totalQuestions: widget.session.totalQuestions,
    );

    if (mounted) {
      setState(() => _scoreSaved = true);
    }
  }

  String get _grade {
    final score = widget.session.scorePercent;
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Very Good';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    return 'Needs Practice';
  }

  Color get _gradeColor {
    final score = widget.session.scorePercent;
    if (score >= 75) return AppTheme.success;
    if (score >= 40) return Colors.orange;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final auth = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_scoreSaved)
              Card(
                color: Colors.green.shade50,
                child: const ListTile(
                  leading: Icon(Icons.cloud_upload, color: Colors.green),
                  title: Text('Score saved to live leaderboard'),
                ),
              ),
            if (FirebaseBootstrap.enabled && !auth.isLoggedIn)
              Card(
                color: Colors.orange.shade50,
                child: const ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.orange),
                  title: Text('Login to save your score to the leaderboard'),
                ),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '${session.scorePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: _gradeColor,
                      ),
                    ),
                    Text(
                      _grade,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: _gradeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(session.title),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Correct',
              value: '${session.correctCount}',
              color: AppTheme.success,
            ),
            _StatRow(
              label: 'Wrong',
              value: '${session.wrongCount}',
              color: AppTheme.error,
            ),
            _StatRow(
              label: 'Skipped',
              value: '${session.skippedCount}',
              color: Colors.grey,
            ),
            _StatRow(
              label: 'Total Questions',
              value: '${session.totalQuestions}',
              color: AppTheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Review Answers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...List.generate(session.totalQuestions, (index) {
              final question = session.questions[index];
              final selected = session.answerFor(index);
              final correct = session.isCorrect(index);
              final skipped = selected == null;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Q${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            skipped
                                ? Icons.remove_circle_outline
                                : correct
                                    ? Icons.check_circle
                                    : Icons.cancel,
                            color: skipped
                                ? Colors.grey
                                : correct
                                    ? AppTheme.success
                                    : AppTheme.error,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(question.question),
                      const SizedBox(height: 8),
                      if (!skipped)
                        Text(
                          'Your answer: ${question.options[selected]}',
                          style: TextStyle(
                            color: correct ? AppTheme.success : AppTheme.error,
                          ),
                        ),
                      if (!correct)
                        Text(
                          'Correct answer: ${question.correctAnswer}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.success,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(Icons.circle, color: color, size: 12),
        ),
        title: Text(label),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
