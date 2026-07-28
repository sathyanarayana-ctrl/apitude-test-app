import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/question.dart';

class QuizSession extends ChangeNotifier {
  QuizSession({
    required this.title,
    required List<Question> questions,
    this.timeLimitSeconds = 0,
  }) : _questions = List<Question>.from(questions) {
    if (_questions.isEmpty) {
      throw ArgumentError('Quiz must contain at least one question.');
    }
  }

  final String title;
  final List<Question> _questions;
  final int timeLimitSeconds;

  final Map<int, int?> _answers = {};
  int _currentIndex = 0;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isFinished = false;

  List<Question> get questions => List.unmodifiable(_questions);
  int get currentIndex => _currentIndex;
  Question get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;
  bool get isFinished => _isFinished;
  int get secondsRemaining => _secondsRemaining;

  int? get selectedAnswer => _answers[_currentIndex];
  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == totalQuestions - 1;
  double get progress => (_currentIndex + 1) / totalQuestions;

  void start() {
    if (timeLimitSeconds > 0) {
      _secondsRemaining = timeLimitSeconds;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsRemaining <= 1) {
          _secondsRemaining = 0;
          finish();
        } else {
          _secondsRemaining--;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  void selectAnswer(int optionIndex) {
    _answers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (!isLast) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (!isFirst) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void finish() {
    _isFinished = true;
    _timer?.cancel();
    notifyListeners();
  }

  int get attemptedCount =>
      _answers.values.where((answer) => answer != null).length;

  int get correctCount {
    var count = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  int get wrongCount => attemptedCount - correctCount;

  int get skippedCount => totalQuestions - attemptedCount;

  double get scorePercent =>
      totalQuestions == 0 ? 0 : (correctCount / totalQuestions) * 100;

  int? answerFor(int index) => _answers[index];

  bool isCorrect(int index) =>
      _answers[index] != null && _answers[index] == _questions[index].correctIndex;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
