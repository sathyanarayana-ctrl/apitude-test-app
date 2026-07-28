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

  factory Question.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? json['category'] as String?;
    final type = QuestionType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => QuestionType.generalAptitude,
    );

    final difficultyName = json['difficulty'] as String? ?? 'medium';
    final difficulty = Difficulty.values.firstWhere(
      (value) => value.name == difficultyName,
      orElse: () => Difficulty.medium,
    );

    return Question(
      id: json['id'] as String,
      type: type,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String? ?? '',
      difficulty: difficulty,
    );
  }
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
