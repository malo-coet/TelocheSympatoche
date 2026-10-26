import 'package:flutter/material.dart';
import 'package:teloche_design_system/teloche_design_system.dart';

void main() => runApp(const TelocheRemoteApp());

class TelocheRemoteApp extends StatelessWidget {
  const TelocheRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TelocheSympatoche Remote',
      debugShowCheckedModeBanner: false,
      theme: telocheTheme(),
      home: const PairingScreen(),
    );
  }
}

/// First screen of the remote: find a TV on the network and pair with it.
class PairingScreen extends StatelessWidget {
  const PairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TelocheSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('No TV paired yet', style: textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: TelocheSpacing.m),
              Text(
                'Make sure your phone and your TV are on the same network.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TelocheSpacing.xl),
              FilledButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Discovery: coming soon'))),
                child: const Text('Find a TV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
