import 'package:flutter/material.dart';

import '../data/questions_repository.dart';
import '../models/question_type.dart';
import '../providers/quiz_session.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Category')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: QuestionType.values.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final type = QuestionType.values[index];
          final count = QuestionsRepository.countByType(type);

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(type.icon),
              ),
              title: Text(type.label),
              subtitle: Text('${type.description}\n$count questions'),
              isThreeLine: true,
              trailing: const Icon(Icons.play_arrow),
              onTap: count == 0
                  ? null
                  : () {
                      final session = QuizSession(
                        title: type.label,
                        questions: QuestionsRepository.byType(type),
                      )..start();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(session: session),
                        ),
                      ).then((_) => session.dispose());
                    },
            ),
          );
        },
      ),
    );
  }
}
