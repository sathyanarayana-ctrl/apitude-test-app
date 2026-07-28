import 'question_type.dart';

class Question {
  const Question({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = Difficulty.medium,
  });

  final String id;
  final QuestionType type;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final Difficulty difficulty;

  String get correctAnswer => options[correctIndex];
}

enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }
}
