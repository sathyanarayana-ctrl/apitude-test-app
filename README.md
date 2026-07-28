# Aptitude Test App

A cross-platform Flutter application for practicing aptitude questions across all major competitive exam topics. Built for Android, iOS, and Web.

## Features

- **13 aptitude categories** covering quantitative, logical, verbal, and analytical topics
- **Practice by category** — focus on one topic at a time
- **Full mock test** — 20 mixed questions with a 20-minute timer
- **Quick practice** — 10 random questions with no timer
- **MCQ format** with A / B / C / D options
- **Question navigator** — jump to any question during a test
- **Results & review** — score, grade, and explanations for every answer
- **35+ sample questions** included (easy to extend)

## Question Categories

| Category | Topics |
|----------|--------|
| Quantitative Aptitude | Percentages, ratios, speed, algebra |
| Logical Reasoning | Statements, assumptions, conclusions |
| Verbal Ability | Synonyms, antonyms, grammar |
| Data Interpretation | Charts, tables, averages |
| Analytical Reasoning | Seating, ranking, direction |
| Non-Verbal Reasoning | Patterns, mirror images, figures |
| Syllogism | Logical conclusions from statements |
| Blood Relations | Family tree puzzles |
| Coding & Decoding | Letter and number codes |
| Clock & Calendar | Angles, days, dates |
| Series | Number and letter series |
| Puzzles | Brain teasers and logic puzzles |
| General Aptitude | SI, HCF, work & time, mixed |

## Screenshots

> Run the app and add screenshots here after your first build.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.2 or later)
- Android Studio / Xcode (for mobile builds)
- Chrome (optional, for web)

### Installation

```bash
# Clone the repository
git clone https://github.com/sathyanarayana-ctrl/apitude-test-app.git
cd apitude-test-app

# Generate platform folders (first time only)
flutter create .

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Run on specific platforms

```bash
flutter run -d chrome    # Web
flutter run -d android   # Android
flutter run -d ios       # iOS (macOS only)
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── data/
│   └── questions_repository.dart  # Question bank (add questions here)
├── models/
│   ├── question.dart              # Question model
│   └── question_type.dart         # Category definitions
├── providers/
│   └── quiz_session.dart          # Quiz state & timer logic
├── screens/
│   ├── home_screen.dart           # Home & test mode selection
│   ├── category_screen.dart       # Category list
│   ├── quiz_screen.dart           # Active quiz UI
│   └── result_screen.dart         # Score & answer review
└── theme/
    └── app_theme.dart             # App colors & styling
```

## Adding Questions

Edit `lib/data/questions_repository.dart` and add a new `Question`:

```dart
const Question(
  id: 'unique_id',
  type: QuestionType.quantitative,
  question: 'Your question here?',
  options: ['Option A', 'Option B', 'Option C', 'Option D'],
  correctIndex: 0,  // 0 = A, 1 = B, 2 = C, 3 = D
  explanation: 'Why this answer is correct.',
  difficulty: Difficulty.medium,
),
```

## Tech Stack

- **Flutter** — cross-platform UI framework
- **Dart** — programming language
- **Material Design 3** — modern UI components

## Roadmap

- [ ] Add more questions (100+ per category)
- [ ] User login and score history
- [ ] Hindi / regional language support
- [ ] Offline mode with local database
- [ ] Play Store & App Store release

## License

This project is open source and available for personal and educational use.

## Author

**Satyanarayana** — [GitHub](https://github.com/sathyanarayana-ctrl)
