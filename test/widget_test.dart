import 'package:flutter_test/flutter_test.dart';
import 'package:studylog_flutter/main.dart';

void main() {
  testWidgets('STUDYLOG Portal Mahasiswa renders Beranda', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyLogApp());
    expect(find.text('STUDYLOG'), findsOneWidget);
    expect(find.text('3,65'), findsOneWidget);
  });
}
