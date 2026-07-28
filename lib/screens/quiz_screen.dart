import 'package:flutter/material.dart';

import '../providers/quiz_session.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.session});

  final QuizSession session;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    widget.session.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    widget.session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (widget.session.isFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(session: widget.session),
        ),
      );
    } else {
      setState(() {});
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmSubmit() async {
    final unanswered = widget.session.totalQuestions - widget.session.attemptedCount;
    final message = unanswered > 0
        ? 'You have $unanswered unanswered question(s). Submit anyway?'
        : 'Are you sure you want to submit your test?';

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (shouldSubmit == true) {
      widget.session.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final question = session.currentQuestion;
    final labels = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
        actions: [
          if (session.timeLimitSeconds > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  _formatTime(session.secondsRemaining),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: session.secondsRemaining < 60
                        ? Colors.amber.shade200
                        : Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: session.progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            color: AppTheme.primary,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          'Q ${session.currentIndex + 1} / ${session.totalQuestions}',
                        ),
                      ),
                      Chip(
                        label: Text(question.difficulty.label),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = session.selectedAnswer == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => session.selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isSelected
                                    ? AppTheme.primary
                                    : Colors.grey.shade200,
                                child: Text(
                                  labels[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(session.totalQuestions, (index) {
                      final answered = session.answerFor(index) != null;
                      final isCurrent = index == session.currentIndex;
                      return GestureDetector(
                        onTap: () => session.goToQuestion(index),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppTheme.primary
                                : answered
                                    ? AppTheme.accent.withValues(alpha: 0.2)
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: session.isFirst ? null : session.previous,
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: session.isLast ? _confirmSubmit : session.next,
                      child: Text(session.isLast ? 'Submit' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
