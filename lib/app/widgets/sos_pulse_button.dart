import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SosPulseButton extends StatefulWidget {
  const SosPulseButton({
    required this.onPressed,
    this.label = 'SOS',
    super.key,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  State<SosPulseButton> createState() => _SosPulseButtonState();
}

class _SosPulseButtonState extends State<SosPulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.96,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double diameter = 170;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulse.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.danger.withValues(alpha: 0.2),
                  blurRadius: 22 * _pulse.value,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.danger,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            textStyle: const TextStyle(
              fontSize: 40,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w800,
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(widget.label),
        ),
      ),
    );
  }
}
