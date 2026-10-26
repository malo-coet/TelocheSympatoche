import 'package:flutter/material.dart';
import 'package:teloche_design_system/teloche_design_system.dart';

/// Home screen: entry points to every section, navigable with the arrow keys.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const sections = [
    (label: 'Movies', icon: Icons.movie_outlined),
    (label: 'Series', icon: Icons.live_tv_outlined),
    (label: 'Music', icon: Icons.library_music_outlined),
    (label: 'Podcasts', icon: Icons.podcasts_outlined),
    (label: 'Extensions', icon: Icons.extension_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TelocheSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TelocheSympatoche', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: TelocheSpacing.xl),
            FocusTraversalGroup(
              child: Wrap(
                spacing: TelocheSpacing.l,
                runSpacing: TelocheSpacing.l,
                children: [
                  for (final (index, section) in sections.indexed)
                    FocusableTile(
                      label: section.label,
                      icon: section.icon,
                      autofocus: index == 0,
                      onActivate: () => _showComingSoon(context, section.label),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String section) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$section: coming soon')));
  }
}
