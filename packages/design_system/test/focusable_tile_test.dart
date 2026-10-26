import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teloche_design_system/teloche_design_system.dart';

void main() {
  testWidgets('Enter activates the focused tile', (tester) async {
    var activations = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: telocheTheme(),
        home: Scaffold(
          body: FocusableTile(label: 'Movies', autofocus: true, onActivate: () => activations++),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);

    expect(activations, 1);
  });

  testWidgets('a tile is a labelled button for screen readers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FocusableTile(label: 'Music', onActivate: () {}),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(FocusableTile)),
      matchesSemantics(label: 'Music', isButton: true, hasTapAction: true),
    );
  });
}
