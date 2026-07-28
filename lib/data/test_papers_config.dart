/// Add your Google Sheets / Drive links here.
///
/// Google Sheet format (first row = header):
/// id | type | question | option_a | option_b | option_c | option_d | correct_index | explanation | difficulty
///
/// Steps:
/// 1. Create a Google Sheet with the columns above
/// 2. File → Share → Anyone with the link → Viewer
/// 3. Copy the Sheet ID from the URL:
///    https://docs.google.com/spreadsheets/d/SHEET_ID/edit
/// 4. Add an entry below with sheetId and gid (tab id from URL #gid=0)
class GoogleSheetSource {
  const GoogleSheetSource({
    required this.sheetId,
    required this.title,
    required this.description,
    this.gid = '0',
    this.durationMinutes = 30,
    this.category = 'generalAptitude',
  });

  final String sheetId;
  final String gid;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;

  String get exportUrl =>
      'https://docs.google.com/spreadsheets/d/$sheetId/export?format=csv&gid=$gid';

  String get viewUrl =>
      'https://docs.google.com/spreadsheets/d/$sheetId/edit#gid=$gid';
}

class TestPapersConfig {
  static const List<GoogleSheetSource> googleSheetSources = [
    GoogleSheetSource(
      sheetId: '1wqayZDw8mLilWHrrSHVtOO20gr1PyfTCITlAMBd5o-o',
      gid: '0',
      title: 'Aptitude Test Paper (Google Sheet)',
      description: 'Imported from shared Google Sheets link',
      durationMinutes: 45,
      category: 'generalAptitude',
    ),
  ];
}
