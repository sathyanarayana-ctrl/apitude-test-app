import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';
import 'firebase_bootstrap.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.id,
    required this.userName,
    required this.testName,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.createdAt,
  });

  final String id;
  final String userName;
  final String testName;
  final double score;
  final int correctCount;
  final int totalQuestions;
  final DateTime createdAt;

  factory LeaderboardEntry.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LeaderboardEntry(
      id: doc.id,
      userName: data['userName'] as String? ?? 'Anonymous',
      testName: data['testName'] as String? ?? 'Test',
      score: (data['score'] as num?)?.toDouble() ?? 0,
      correctCount: data['correctCount'] as int? ?? 0,
      totalQuestions: data['totalQuestions'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class LeaderboardService {
  static const String _collection = 'leaderboard';

  static CollectionReference<Map<String, dynamic>>? get _leaderboard {
    if (!FirebaseBootstrap.enabled) return null;
    return FirebaseFirestore.instance.collection(_collection);
  }

  static Stream<List<LeaderboardEntry>> watchTopScores({int limit = 20}) {
    final collection = _leaderboard;
    if (collection == null) {
      return Stream.value(const []);
    }

    return collection
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(LeaderboardEntry.fromDoc)
              .toList(),
        );
  }

  static Future<void> saveScore({
    required String userId,
    required String userName,
    required String testName,
    required double score,
    required int correctCount,
    required int totalQuestions,
  }) async {
    final collection = _leaderboard;
    if (collection == null) return;

    await collection.add({
      'userId': userId,
      'userName': userName,
      'testName': testName,
      'score': score,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class FirestoreQuestionsService {
  static const String _collection = 'questions';

  static Stream<List<Question>> watchLiveQuestions() {
    if (!FirebaseBootstrap.enabled) {
      return Stream.value(const []);
    }

    return FirebaseFirestore.instance
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Question.fromJson(data);
      }).toList();
    });
  }
}
