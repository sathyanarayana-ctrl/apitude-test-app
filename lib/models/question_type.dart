enum QuestionType {
  quantitative,
  logicalReasoning,
  verbalAbility,
  dataInterpretation,
  analyticalReasoning,
  nonVerbalReasoning,
  syllogism,
  bloodRelations,
  codingDecoding,
  clockCalendar,
  series,
  puzzles,
  generalAptitude,
}

extension QuestionTypeX on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.quantitative:
        return 'Quantitative Aptitude';
      case QuestionType.logicalReasoning:
        return 'Logical Reasoning';
      case QuestionType.verbalAbility:
        return 'Verbal Ability';
      case QuestionType.dataInterpretation:
        return 'Data Interpretation';
      case QuestionType.analyticalReasoning:
        return 'Analytical Reasoning';
      case QuestionType.nonVerbalReasoning:
        return 'Non-Verbal Reasoning';
      case QuestionType.syllogism:
        return 'Syllogism';
      case QuestionType.bloodRelations:
        return 'Blood Relations';
      case QuestionType.codingDecoding:
        return 'Coding & Decoding';
      case QuestionType.clockCalendar:
        return 'Clock & Calendar';
      case QuestionType.series:
        return 'Series (Number/Letter)';
      case QuestionType.puzzles:
        return 'Puzzles';
      case QuestionType.generalAptitude:
        return 'General Aptitude';
    }
  }

  String get description {
    switch (this) {
      case QuestionType.quantitative:
        return 'Percentages, ratios, algebra, geometry, and arithmetic';
      case QuestionType.logicalReasoning:
        return 'Deduction, assumptions, conclusions, and arguments';
      case QuestionType.verbalAbility:
        return 'Grammar, vocabulary, synonyms, and comprehension';
      case QuestionType.dataInterpretation:
        return 'Charts, tables, graphs, and data analysis';
      case QuestionType.analyticalReasoning:
        return 'Seating, ranking, direction, and arrangement';
      case QuestionType.nonVerbalReasoning:
        return 'Patterns, mirror images, and figure series';
      case QuestionType.syllogism:
        return 'Statements and logical conclusions';
      case QuestionType.bloodRelations:
        return 'Family tree and relationship puzzles';
      case QuestionType.codingDecoding:
        return 'Letter/number coding patterns';
      case QuestionType.clockCalendar:
        return 'Time, dates, and calendar problems';
      case QuestionType.series:
        return 'Number, letter, and mixed series';
      case QuestionType.puzzles:
        return 'Brain teasers and mixed logic puzzles';
      case QuestionType.generalAptitude:
        return 'Mixed aptitude for competitive exams';
    }
  }

  String get icon {
    switch (this) {
      case QuestionType.quantitative:
        return '🔢';
      case QuestionType.logicalReasoning:
        return '🧠';
      case QuestionType.verbalAbility:
        return '📖';
      case QuestionType.dataInterpretation:
        return '📊';
      case QuestionType.analyticalReasoning:
        return '🔍';
      case QuestionType.nonVerbalReasoning:
        return '🧩';
      case QuestionType.syllogism:
        return '⚖️';
      case QuestionType.bloodRelations:
        return '👨‍👩‍👧';
      case QuestionType.codingDecoding:
        return '🔐';
      case QuestionType.clockCalendar:
        return '🕐';
      case QuestionType.series:
        return '🔁';
      case QuestionType.puzzles:
        return '🎯';
      case QuestionType.generalAptitude:
        return '⭐';
    }
  }
}
