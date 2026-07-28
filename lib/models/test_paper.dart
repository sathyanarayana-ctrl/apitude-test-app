import 'question.dart';
import 'question_type.dart';

class TestPaper {
  const TestPaper({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    this.durationMinutes = 30,
    this.sourceUrl = '',
    this.sourceLabel = 'Built-in',
  });

  final String id;
  final String title;
  final String description;
  final QuestionType category;
  final List<Question> questions;
  final int durationMinutes;
  final String sourceUrl;
  final String sourceLabel;

  int get questionCount => questions.length;

  factory TestPaper.fromJson(Map<String, dynamic> json) {
    final categoryName = json['category'] as String;
    final category = QuestionType.values.firstWhere(
      (type) => type.name == categoryName,
      orElse: () => QuestionType.generalAptitude,
    );

    final questionsJson = json['questions'] as List<dynamic>;
    return TestPaper(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: category,
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      sourceUrl: json['sourceUrl'] as String? ?? '',
      sourceLabel: json['sourceLabel'] as String? ?? 'Built-in',
      questions: questionsJson
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
