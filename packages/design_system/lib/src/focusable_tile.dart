import 'package:flutter/material.dart';

import 'tokens.dart';

/// A tile navigable with the arrow keys and activated with Enter.
///
/// When focused it gets a thick outline and grows slightly, so the focus is
/// visible from a distance and does not rely on color alone.
class FocusableTile extends StatefulWidget {
  const FocusableTile({required this.label, required this.onActivate, this.icon, this.autofocus = false, super.key});

  final String label;
  final IconData? icon;
  final VoidCallback onActivate;
  final bool autofocus;

  @override
  State<FocusableTile> createState() => _FocusableTileState();
}

class _FocusableTileState extends State<FocusableTile> {
  var _focused = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onActivate,
      child: FocusableActionDetector(
        autofocus: widget.autofocus,
        onShowFocusHighlight: (focused) => setState(() => _focused = focused),
        actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => widget.onActivate())},
        child: GestureDetector(
          onTap: widget.onActivate,
          child: AnimatedScale(
            scale: _focused ? TelocheFocus.scale : 1,
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 120),
            child: Container(
              constraints: const BoxConstraints(minWidth: 220, minHeight: 140),
              padding: const EdgeInsets.all(TelocheSpacing.m),
              decoration: BoxDecoration(
                color: TelocheColors.surface,
                borderRadius: BorderRadius.circular(TelocheFocus.radius),
                border: Border.all(
                  color: _focused ? TelocheColors.focus : Colors.transparent,
                  width: TelocheFocus.outlineWidth,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) Icon(widget.icon, size: 40, color: TelocheColors.onBackground),
                  const SizedBox(height: TelocheSpacing.s),
                  Text(widget.label, style: textTheme.titleLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
