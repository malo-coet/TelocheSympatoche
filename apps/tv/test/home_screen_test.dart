import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teloche_tv/main.dart';

bool hasFocus(WidgetTester tester, String label) => Focus.of(tester.element(find.text(label))).hasPrimaryFocus;

void main() {
  testWidgets('the first section is focused on launch', (tester) async {
    await tester.pumpWidget(const TelocheTvApp());
    await tester.pumpAndSettle();

    expect(hasFocus(tester, 'Movies'), isTrue);
  });

  testWidgets('arrow keys move the focus between sections', (tester) async {
    await tester.pumpWidget(const TelocheTvApp());
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(hasFocus(tester, 'Series'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(hasFocus(tester, 'Movies'), isTrue);
  });

  testWidgets('home screen meets the accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const TelocheTvApp());
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}
