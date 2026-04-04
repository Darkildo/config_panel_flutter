import 'package:flutter/material.dart';
import '../theme/retro_theme.dart';

class RetroButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? accentColor;
  final IconData? icon;
  final bool expanded;

  const RetroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.accentColor,
    this.icon,
    this.expanded = false,
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? RetroColors.neonGreen;
    final textTheme = Theme.of(context).textTheme;

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: RetroColors.buttonGradient,
          border: Border.all(
            color: _hovered ? accent : accent.withValues(alpha: 0.6),
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            splashColor: accent.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: widget.isLoading
                  ? Center(
                      heightFactor: 1,
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(accent),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: widget.expanded
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: .center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 16, color: accent),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label.toUpperCase(),
                          style: textTheme.titleSmall?.copyWith(
                            color: accent,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    return widget.expanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
