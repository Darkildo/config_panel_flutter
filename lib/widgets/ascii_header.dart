import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/retro_theme.dart';

class AsciiHeader extends StatelessWidget {
  const AsciiHeader({super.key});

  static const String _art = r'''
 ██████╗ ████████╗██████╗ ██╗         ██████╗  █████╗ ███╗   ██╗███████╗██╗     
██╔════╝ ╚══██╔══╝██╔══██╗██║         ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
██║         ██║   ██████╔╝██║         ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
██║         ██║   ██╔══██╗██║         ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
╚██████╗    ██║   ██║  ██║███████╗    ██║     ██║  ██║██║ ╚████║███████╗███████╗
 ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
''';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _art,
            style: GoogleFonts.courierPrime(
              fontSize: 10,
              color: RetroColors.neonGreen.withValues(alpha: 0.7),
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '[ Device Configuration Control Panel v1.0 ]',
          style: GoogleFonts.shareTechMono(
            fontSize: 12,
            color: RetroColors.neonCyan.withValues(alpha: 0.6),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'cracked by 0xDEADBEEF // 2025',
          style: GoogleFonts.shareTechMono(
            fontSize: 10,
            color: RetroColors.neonMagenta.withValues(alpha: 0.4),
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
