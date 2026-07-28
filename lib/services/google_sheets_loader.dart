import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/test_papers_config.dart';
import '../models/question.dart';
import '../models/question_type.dart';
import '../models/test_paper.dart';

class GoogleSheetsLoader {
  Future<List<TestPaper>> loadAll() async {
    final papers = <TestPaper>[];

    for (final source in TestPapersConfig.googleSheetSources) {
      try {
        final paper = await loadFromSource(source);
        if (paper.questions.isNotEmpty) {
          papers.add(paper);
        }
      } catch (_) {
        // Skip failed imports; bundled papers still work offline.
      }
    }

    return papers;
  }

  Future<TestPaper> loadFromSource(GoogleSheetSource source) async {
    final response = await http.get(Uri.parse(source.exportUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load Google Sheet: ${source.title}');
    }

    final questions = _parseCsv(response.body, source.category);
    final category = QuestionType.values.firstWhere(
      (type) => type.name == source.category,
      orElse: () => QuestionType.generalAptitude,
    );

    return TestPaper(
      id: 'google_${source.sheetId}_${source.gid}',
      title: source.title,
      description: source.description,
      category: category,
      durationMinutes: source.durationMinutes,
      sourceUrl: source.viewUrl,
      sourceLabel: 'Google Sheets',
      questions: questions,
    );
  }

  List<Question> _parseCsv(String csvBody, String defaultCategory) {
    final rows = const LineSplitter().convert(csvBody.trim());
    if (rows.length <= 1) return [];

    final questions = <Question>[];
    for (var i = 1; i < rows.length; i++) {
      final columns = _splitCsvRow(rows[i]);
      if (columns.length < 8) continue;

      final typeName = columns.length > 9 ? columns[1].trim() : defaultCategory;
      final questionText = columns.length > 9 ? columns[2].trim() : columns[1].trim();
      final optionA = columns.length > 9 ? columns[3].trim() : columns[2].trim();
      final optionB = columns.length > 9 ? columns[4].trim() : columns[3].trim();
      final optionC = columns.length > 9 ? columns[5].trim() : columns[4].trim();
      final optionD = columns.length > 9 ? columns[6].trim() : columns[5].trim();
      final correctIndex = int.tryParse(
            columns.length > 9 ? columns[7].trim() : columns[6].trim(),
          ) ??
          0;
      final explanation = columns.length > 9 ? columns[8].trim() : columns[7].trim();
      final difficultyName =
          columns.length > 9 ? columns[9].trim() : (columns.length > 8 ? columns[8].trim() : 'medium');

      final type = QuestionType.values.firstWhere(
        (value) => value.name == typeName,
        orElse: () => QuestionType.generalAptitude,
      );
      final difficulty = Difficulty.values.firstWhere(
        (value) => value.name == difficultyName,
        orElse: () => Difficulty.medium,
      );

      questions.add(
        Question(
          id: columns[0].trim().isEmpty ? 'google_q_$i' : columns[0].trim(),
          type: type,
          question: questionText,
          options: [optionA, optionB, optionC, optionD],
          correctIndex: correctIndex.clamp(0, 3),
          explanation: explanation,
          difficulty: difficulty,
        ),
      );
    }

    return questions;
  }

  List<String> _splitCsvRow(String row) {
    final values = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < row.length; i++) {
      final char = row[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        values.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    values.add(buffer.toString());
    return values;
  }
}
