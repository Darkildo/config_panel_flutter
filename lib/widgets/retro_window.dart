import 'package:flutter/material.dart';
import '../theme/retro_theme.dart';

class RetroWindow extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double? width;
  final double? maxWidth;
  final EdgeInsets? padding;

  const RetroWindow({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.width,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      decoration: BoxDecoration(
        color: RetroColors.surface,
        border: Border.all(color: RetroColors.surfaceBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: RetroColors.neonGreen.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RetroColors.titleBarGradient,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                _TitleBarDot(color: RetroColors.neonRed),
                const SizedBox(width: 4),
                _TitleBarDot(color: RetroColors.neonYellow),
                const SizedBox(width: 4),
                _TitleBarDot(color: RetroColors.neonGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBarDot extends StatelessWidget {
  final Color color;
  const _TitleBarDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
    );
  }
}
