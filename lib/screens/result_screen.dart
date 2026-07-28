import 'package:flutter/material.dart';

import '../providers/quiz_session.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.session});

  final QuizSession session;

  String get _grade {
    final score = session.scorePercent;
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Very Good';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    return 'Needs Practice';
  }

  Color get _gradeColor {
    final score = session.scorePercent;
    if (score >= 75) return AppTheme.success;
    if (score >= 40) return Colors.orange;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
