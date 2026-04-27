import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final lower = text.toLowerCase();
    Color color;

    if (lower.contains('critical') || lower.contains('emergency')) {
      color = AppTheme.danger;
    } else if (lower.contains('open') || lower.contains('pending')) {
      color = AppTheme.warning;
    } else if (lower.contains('progress')) {
      color = AppTheme.primary;
    } else if (lower.contains('resolved') || lower.contains('done')) {
      color = AppTheme.accent;
    } else {
      color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
