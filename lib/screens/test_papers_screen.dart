import 'package:flutter/material.dart';

import '../data/test_papers_repository.dart';
import '../models/test_paper.dart';
import '../providers/quiz_session.dart';
import 'quiz_screen.dart';

class TestPapersScreen extends StatefulWidget {
  const TestPapersScreen({super.key});

  @override
  State<TestPapersScreen> createState() => _TestPapersScreenState();
}

class _TestPapersScreenState extends State<TestPapersScreen> {
  late Future<List<TestPaper>> _papersFuture;

  @override
  void initState() {
    super.initState();
    _papersFuture = TestPapersRepository.loadAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _papersFuture = TestPapersRepository.loadAll(forceRefresh: true);
    });
    await _papersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Papers'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from Google Sheets',
          ),
        ],
      ),
      body: FutureBuilder<List<TestPaper>>(
        future: _papersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to load test papers: ${snapshot.error}'),
              ),
            );
          }

          final papers = snapshot.data ?? [];
          if (papers.isEmpty) {
            return const Center(
              child: Text('No test papers available yet.'),
            );
          }

          final totalQuestions =
              papers.fold<int>(0, (sum, paper) => sum + paper.questionCount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${papers.length} test papers • $totalQuestions questions',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: papers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final paper = papers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(paper.category.icon),
                        ),
                        title: Text(paper.title),
                        subtitle: Text(
                          '${paper.category.label}\n'
                          '${paper.questionCount} questions • '
                          '${paper.durationMinutes} min • '
                          '${paper.sourceLabel}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () => _startPaper(context, paper),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _startPaper(BuildContext context, TestPaper paper) {
    final session = QuizSession(
      title: paper.title,
      questions: paper.questions,
      timeLimitSeconds: paper.durationMinutes * 60,
    )..start();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizScreen(session: session)),
    ).then((_) => session.dispose());
  }
}
