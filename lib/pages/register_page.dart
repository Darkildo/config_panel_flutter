import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/retro_theme.dart';
import '../widgets/ascii_header.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_window.dart';
import '../widgets/scanline_overlay.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const RegisterPage({super.key, required this.onSwitchToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    await auth.register(_loginController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: ScanlineOverlay(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                const AsciiHeader(),
                const SizedBox(height: 32),
                RetroWindow(
                  title: 'NEW USER REGISTRATION',
                  maxWidth: 440,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Text(
                          '> Create new credentials for system access_',
                          style: GoogleFonts.shareTechMono(
                            fontSize: 12,
                            color: RetroColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),

                        RetroTextField(
                          controller: _loginController,
                          labelText: 'LOGIN',
                          hintText: 'choose username...',
                          prefixIcon: Icons.person_add_outlined,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Login required';
                            }
                            if (v.trim().length < 3) {
                              return 'Min 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        RetroTextField(
                          controller: _passwordController,
                          labelText: 'PASSWORD',
                          hintText: 'choose password...',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password required';
                            }
                            if (v.length < 4) return 'Min 4 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        RetroTextField(
                          controller: _confirmController,
                          labelText: 'CONFIRM PASSWORD',
                          hintText: 'repeat password...',
                          prefixIcon: Icons.lock_reset,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleRegister(),
                          validator: (v) {
                            if (v != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        if (auth.error != null) ...[
                          const SizedBox(height: 12),
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

                        const SizedBox(height: 20),

                        RetroButton(
                          label: '[ REGISTER ]',
                          icon: Icons.how_to_reg,
                          isLoading: auth.isLoading,
                          onPressed: _handleRegister,
                          expanded: true,
                          accentColor: RetroColors.neonCyan,
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              'Already registered? ',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 12,
                                color: RetroColors.textMuted,
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: widget.onSwitchToLogin,
                                child: Text(
                                  '<< LOGIN',
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
                const SizedBox(height: 24),
                Text(
                  '─── [ (c) 2025 CTRL PANEL TEAM // ALL RIGHTS REVERSED ] ───',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 9,
                    color: RetroColors.textDim,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
