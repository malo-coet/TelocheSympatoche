import 'package:flutter/material.dart';
import 'package:teloche_design_system/teloche_design_system.dart';

import 'home/home_screen.dart';

void main() => runApp(const TelocheTvApp());

class TelocheTvApp extends StatelessWidget {
  const TelocheTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TelocheSympatoche',
      debugShowCheckedModeBanner: false,
      theme: telocheTheme(),
      home: const HomeScreen(),
    );
  }
}
