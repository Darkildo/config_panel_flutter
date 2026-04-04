import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/responsive.dart';
import '../theme/retro_theme.dart';
import '../widgets/ascii_header.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_window.dart';
import '../widgets/scanline_overlay.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSwitchToRegister;

  const LoginPage({super.key, required this.onSwitchToRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    await auth.login(_loginController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isMobile = context.isMobile;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      body: ScanlineOverlay(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isMobile ? 16 : 24,
            ),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                if (!isMobile) const AsciiHeader(),
                if (!isMobile) const SizedBox(height: 32),

                if (isMobile) ...[
                  Text(
                    '[ CTRL PANEL ]',
                    style: GoogleFonts.vt323(
                      fontSize: 28,
                      color: RetroColors.neonGreen,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Device Configuration Manager v1.0',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 10,
                      color: RetroColors.neonCyan.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                RetroWindow(
                  title: 'AUTHORIZATION',
                  maxWidth: 440,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Text(
                          '> Enter your credentials to access the system_',
                          style: GoogleFonts.shareTechMono(
                            fontSize: isMobile ? 11 : 12,
                            color: RetroColors.textMuted,
                          ),
                        ),
                        SizedBox(height: isMobile ? 16 : 20),

                        RetroTextField(
                          controller: _loginController,
                          labelText: 'LOGIN',
                          hintText: 'enter username...',
                          prefixIcon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Login required'
                              : null,
                        ),
                        SizedBox(height: isMobile ? 12 : 16),

                        RetroTextField(
                          controller: _passwordController,
                          labelText: 'PASSWORD',
                          hintText: 'enter password...',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleLogin(),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Password required'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        if (auth.error != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: RetroColors.neonRed.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              color: RetroColors.neonRed.withValues(
                                alpha: 0.05,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber,
                                  size: 16,
                                  color: RetroColors.neonRed,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '[ERROR] ${auth.error}',
                                    style: GoogleFonts.shareTechMono(
                                      fontSize: 12,
                                      color: RetroColors.neonRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: isMobile ? 16 : 20),

                        RetroButton(
                          label: '[ LOGIN ]',
                          icon: Icons.login,
                          isLoading: auth.isLoading,
                          onPressed: _handleLogin,
                          expanded: true,
                        ),

                        SizedBox(height: isMobile ? 12 : 16),
                        const Divider(),
                        SizedBox(height: isMobile ? 8 : 12),

                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              'No account? ',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 12,
                                color: RetroColors.textMuted,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: widget.onSwitchToRegister,
                                child: Text(
                                  'REGISTER >>',
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 12,
                                    color: RetroColors.neonMagenta,
                                    decoration: TextDecoration.underline,
                                    decorationColor: RetroColors.neonMagenta,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 24),
                _buildFooter(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Text(
      isMobile
          ? '(c) 2025 CTRL PANEL TEAM'
          : '─── [ (c) 2025 CTRL PANEL TEAM // ALL RIGHTS REVERSED ] ───',
      style: GoogleFonts.shareTechMono(
        fontSize: 9,
        color: RetroColors.textDim,
        letterSpacing: 2,
      ),
    );
  }
}
