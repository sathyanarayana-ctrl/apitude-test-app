import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/test_paper.dart';
import '../services/google_sheets_loader.dart';
import 'questions_repository.dart';

class TestPapersRepository {
  TestPapersRepository._();

  static final GoogleSheetsLoader _googleLoader = GoogleSheetsLoader();
  static List<TestPaper>? _cachedPapers;

  static Future<List<TestPaper>> loadAll({bool forceRefresh = false}) async {
    if (_cachedPapers != null && !forceRefresh) {
      return _cachedPapers!;
    }

    final bundled = await _loadBundledPapers();
    final googlePapers = await _googleLoader.loadAll();
    _cachedPapers = [...bundled, ...googlePapers];
    return _cachedPapers!;
  }

  static Future<List<TestPaper>> _loadBundledPapers() async {
    final raw = await rootBundle.loadString('assets/test_papers/all_papers.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final papersJson = decoded['papers'] as List<dynamic>;

    return papersJson
        .map((item) => TestPaper.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<TestPaper?> byId(String id) async {
    final papers = await loadAll();
    for (final paper in papers) {
      if (paper.id == id) return paper;
    }
    return null;
  }

  static Future<int> totalQuestionCount() async {
    final papers = await loadAll();
    return papers.fold<int>(0, (sum, paper) => sum + paper.questionCount) +
        QuestionsRepository.allQuestions.length;
  }
}
