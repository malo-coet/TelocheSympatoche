import 'package:flutter_test/flutter_test.dart';
import 'package:teloche_remote/main.dart';

void main() {
  testWidgets('pairing screen offers to find a TV', (tester) async {
    await tester.pumpWidget(const TelocheRemoteApp());

    expect(find.text('Find a TV'), findsOneWidget);
  });

  testWidgets('pairing screen meets the Android accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const TelocheRemoteApp());

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });
}
