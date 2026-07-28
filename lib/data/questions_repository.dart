import '../models/question.dart';
import '../models/question_type.dart';

class QuestionsRepository {
  static List<Question> get allQuestions => _questions;

  static List<Question> byType(QuestionType type) =>
      _questions.where((q) => q.type == type).toList();

  static List<Question> mixed({int count = 20}) {
    final shuffled = List<Question>.from(_questions)..shuffle();
    return shuffled.take(count).toList();
  }

  static int countByType(QuestionType type) => byType(type).length;

  static final List<Question> _questions = [
    // Quantitative Aptitude
    const Question(
      id: 'q1',
      type: QuestionType.quantitative,
      question: 'If 20% of a number is 50, what is the number?',
      options: ['200', '250', '300', '350'],
      correctIndex: 1,
      explanation: '20% of x = 50 → x = 50 × 100 / 20 = 250',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'q2',
      type: QuestionType.quantitative,
      question: 'A train 120 m long passes a pole in 6 seconds. Speed in km/h?',
      options: ['60', '72', '80', '90'],
      correctIndex: 1,
      explanation: 'Speed = 120/6 = 20 m/s = 20 × 18/5 = 72 km/h',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'q3',
      type: QuestionType.quantitative,
      question: 'Ratio of A:B is 3:4 and B:C is 2:5. Find A:C.',
      options: ['3:10', '6:10', '3:5', '2:5'],
      correctIndex: 0,
      explanation: 'A:B = 3:4, B:C = 2:5 → A:B:C = 6:8:20 → A:C = 6:20 = 3:10',
      difficulty: Difficulty.medium,
    ),

    // Logical Reasoning
    const Question(
      id: 'l1',
      type: QuestionType.logicalReasoning,
      question: 'All cats are animals. Some animals are pets. Which is definitely true?',
      options: [
        'All cats are pets',
        'Some cats may be pets',
        'No cat is a pet',
        'All pets are cats',
      ],
      correctIndex: 1,
      explanation: 'We cannot conclude all cats are pets, but some cats may be pets.',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'l2',
      type: QuestionType.logicalReasoning,
      question: 'If CODE is written as DPEF, how is GAME written?',
      options: ['HBNF', 'FZLD', 'IBOG', 'FCLD'],
      correctIndex: 0,
      explanation: 'Each letter is shifted +1: G→H, A→B, M→N, E→F → HBNF',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'l3',
      type: QuestionType.logicalReasoning,
      question: 'Statement: All managers are leaders. Some leaders are innovators.\nConclusion: Some managers are innovators.',
      options: [
        'Definitely true',
        'Definitely false',
        'Cannot be determined',
        'Partially true',
      ],
      correctIndex: 2,
      explanation: 'The conclusion does not necessarily follow from the given statements.',
      difficulty: Difficulty.hard,
    ),

    // Verbal Ability
    const Question(
      id: 'v1',
      type: QuestionType.verbalAbility,
      question: 'Choose the synonym of "ABUNDANT".',
      options: ['Scarce', 'Plentiful', 'Tiny', 'Weak'],
      correctIndex: 1,
      explanation: 'Abundant means existing in large quantities; plentiful is a synonym.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'v2',
      type: QuestionType.verbalAbility,
      question: 'Fill in the blank: She has been working here ___ 2019.',
      options: ['for', 'since', 'from', 'by'],
      correctIndex: 1,
      explanation: '"Since" is used with a point in time (2019).',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'v3',
      type: QuestionType.verbalAbility,
      question: 'Antonym of "BENEvolent"?',
      options: ['Kind', 'Malevolent', 'Generous', 'Charitable'],
      correctIndex: 1,
      explanation: 'Benevolent means kind; malevolent means wishing harm.',
      difficulty: Difficulty.medium,
    ),

    // Data Interpretation
    const Question(
      id: 'd1',
      type: QuestionType.dataInterpretation,
      question:
          'Sales: Jan=100, Feb=120, Mar=90, Apr=150. What is average monthly sales?',
      options: ['110', '115', '120', '125'],
      correctIndex: 1,
      explanation: '(100+120+90+150)/4 = 460/4 = 115',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'd2',
      type: QuestionType.dataInterpretation,
      question:
          'Company A: 40% market share, Company B: 25%. Rest is others. What % is others?',
      options: ['25%', '30%', '35%', '40%'],
      correctIndex: 2,
      explanation: '100 - 40 - 25 = 35%',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'd3',
      type: QuestionType.dataInterpretation,
      question: 'Profit rose from ₹200 to ₹250. Percentage increase?',
      options: ['20%', '25%', '30%', '50%'],
      correctIndex: 1,
      explanation: 'Increase = 50; 50/200 × 100 = 25%',
      difficulty: Difficulty.medium,
    ),

    // Analytical Reasoning
    const Question(
      id: 'a1',
      type: QuestionType.analyticalReasoning,
      question:
          'Five people sit in a row. A is left of B. C is right of B. D is at an end. Who can be in the middle?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 1,
      explanation: 'Order possibilities place B in the middle in valid arrangements.',
      difficulty: Difficulty.hard,
    ),
    const Question(
      id: 'a2',
      type: QuestionType.analyticalReasoning,
      question: 'Facing North, turn right, then right again. Which direction now?',
      options: ['North', 'South', 'East', 'West'],
      correctIndex: 1,
      explanation: 'North → East (right) → South (right again)',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'a3',
      type: QuestionType.analyticalReasoning,
      question: 'In a queue, Ravi is 7th from front and 12th from back. Total people?',
      options: ['18', '19', '20', '21'],
      correctIndex: 0,
      explanation: 'Total = 7 + 12 - 1 = 18',
      difficulty: Difficulty.medium,
    ),

    // Non-Verbal Reasoning
    const Question(
      id: 'n1',
      type: QuestionType.nonVerbalReasoning,
      question: 'Series: ○, △, □, ○, △, ?',
      options: ['○', '△', '□', '◇'],
      correctIndex: 2,
      explanation: 'Pattern repeats every 3 shapes: circle, triangle, square.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'n2',
      type: QuestionType.nonVerbalReasoning,
      question: 'Mirror image of "b" looks like:',
      options: ['b', 'd', 'p', 'q'],
      correctIndex: 1,
      explanation: 'Horizontal mirror flips b to d.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'n3',
      type: QuestionType.nonVerbalReasoning,
      question: 'Count the number of triangles in a figure with one large triangle divided into 4 small triangles.',
      options: ['4', '5', '6', '8'],
      correctIndex: 1,
      explanation: '4 small + 1 large = 5 triangles (basic division pattern).',
      difficulty: Difficulty.medium,
    ),

    // Syllogism
    const Question(
      id: 's1',
      type: QuestionType.syllogism,
      question: 'All roses are flowers. All flowers fade. Conclusion: All roses fade.',
      options: ['True', 'False', 'Uncertain', 'None'],
      correctIndex: 0,
      explanation: 'If all roses are flowers and all flowers fade, all roses fade.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 's2',
      type: QuestionType.syllogism,
      question: 'No cats are dogs. Some dogs are pets. Conclusion: Some pets are not cats.',
      options: ['True', 'False', 'Uncertain', 'None'],
      correctIndex: 2,
      explanation: 'Cannot definitively conclude without more information.',
      difficulty: Difficulty.hard,
    ),

    // Blood Relations
    const Question(
      id: 'b1',
      type: QuestionType.bloodRelations,
      question: 'A is the brother of B. B is the sister of C. How is A related to C?',
      options: ['Brother', 'Sister', 'Cousin', 'Uncle'],
      correctIndex: 0,
      explanation: 'A and B are siblings; B and C are siblings → A is C\'s brother.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'b2',
      type: QuestionType.bloodRelations,
      question:
          'Pointing to a photo, Arun said, "He is the son of my father\'s only son." Who is in the photo?',
      options: ['Arun\'s son', 'Arun\'s brother', 'Arun himself', 'Arun\'s father'],
      correctIndex: 0,
      explanation:
          'Father\'s only son is Arun; the son of Arun is Arun\'s son.',
      difficulty: Difficulty.medium,
    ),

    // Coding Decoding  
    const Question(
      id: 'c1',
      type: QuestionType.codingDecoding,
      question: 'If CAT = 24, DOG = 26, then BAT = ?',
      options: ['22', '23', '24', '25'],
      correctIndex: 1,
      explanation: 'Sum of letter positions: B(2)+A(1)+T(20)=23',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'c2',
      type: QuestionType.codingDecoding,
      question: 'In a code, FRIEND is written as GSJFOE. How is MOTHER written?',
      options: ['NPUIFS', 'LNSGDQ', 'NPUIGS', 'OPVJGT'],
      correctIndex: 0,
      explanation: 'Each letter +1: M→N, O→P, T→U, H→I, E→F, R→S → NPUIFS',
      difficulty: Difficulty.medium,
    ),

    // Clock & Calendar
    const Question(
      id: 'cl1',
      type: QuestionType.clockCalendar,
      question: 'Angle between hour and minute hands at 3:00?',
      options: ['60°', '75°', '90°', '120°'],
      correctIndex: 2,
      explanation: 'At 3:00, hands are 3 hours apart = 3 × 30° = 90°',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'cl2',
      type: QuestionType.clockCalendar,
      question: 'If today is Monday, what day will it be after 50 days?',
      options: ['Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      correctIndex: 0,
      explanation: '50 ÷ 7 leaves remainder 1; Monday + 1 day = Tuesday.',
      difficulty: Difficulty.easy,
    ),

    // Series
    const Question(
      id: 'sr1',
      type: QuestionType.series,
      question: 'Find the next number: 2, 6, 12, 20, 30, ?',
      options: ['40', '42', '44', '48'],
      correctIndex: 1,
      explanation: 'Differences: +4, +6, +8, +10, next +12 → 30+12=42',
      difficulty: Difficulty.medium,
    ),
    const Question(
      id: 'sr2',
      type: QuestionType.series,
      question: 'Letter series: A, C, F, J, ?',
      options: ['M', 'N', 'O', 'P'],
      correctIndex: 2,
      explanation: 'Gaps +2, +3, +4, +5 → J+5=O',
      difficulty: Difficulty.medium,
    ),

    // Puzzles
    const Question(
      id: 'p1',
      type: QuestionType.puzzles,
      question: 'A farmer has 17 sheep. All but 9 die. How many are left?',
      options: ['8', '9', '17', '0'],
      correctIndex: 1,
      explanation: '"All but 9 die" means 9 survive.',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'p2',
      type: QuestionType.puzzles,
      question: 'If 5 machines make 5 widgets in 5 minutes, how long for 100 machines to make 100 widgets?',
      options: ['5 min', '20 min', '100 min', '1 min'],
      correctIndex: 0,
      explanation: 'Each machine makes 1 widget in 5 minutes; 100 machines make 100 in 5 min.',
      difficulty: Difficulty.medium,
    ),

    // General Aptitude
    const Question(
      id: 'g1',
      type: QuestionType.generalAptitude,
      question: 'Simple interest on ₹5000 at 10% for 2 years?',
      options: ['₹500', '₹1000', '₹1500', '₹2000'],
      correctIndex: 1,
      explanation: 'SI = P×R×T/100 = 5000×10×2/100 = ₹1000',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'g2',
      type: QuestionType.generalAptitude,
      question: 'HCF of 24 and 36?',
      options: ['6', '8', '12', '18'],
      correctIndex: 2,
      explanation: 'HCF(24, 36) = 12',
      difficulty: Difficulty.easy,
    ),
    const Question(
      id: 'g3',
      type: QuestionType.generalAptitude,
      question: 'A completes work in 10 days, B in 15 days. Together in how many days?',
      options: ['5', '6', '7', '8'],
      correctIndex: 1,
      explanation: '1/10 + 1/15 = 5/30 = 1/6 → 6 days',
      difficulty: Difficulty.medium,
    ),
  ];
}
