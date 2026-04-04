import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../theme/responsive.dart';
import '../theme/retro_theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_status_badge.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_window.dart';
import '../widgets/scanline_overlay.dart';

class UserListPage extends StatefulWidget {
  final VoidCallback onBack;

  const UserListPage({super.key, required this.onBack});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openEditDialog(User user) {
    final isMobile = context.isMobile;

    if (isMobile) {
      Navigator.of(context).push(
        MaterialPageRoute<bool>(
          fullscreenDialog: true,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<UserProvider>(),
            child: _EditUserFullScreenPage(user: user),
          ),
        ),
      );
    } else {
      showDialog<bool>(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<UserProvider>(),
          child: _EditUserDialog(user: user),
        ),
      );
    }
  }

  Future<void> _confirmDelete(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('DELETE USER #${user.id}?'),
        content: Text(
          'This will permanently remove user "${user.login}". Continue?',
          style: GoogleFonts.shareTechMono(
            fontSize: 13,
            color: RetroColors.neonGreen,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<UserProvider>().deleteUser(user.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '> User "${user.login}" deleted',
              style: GoogleFonts.shareTechMono(color: RetroColors.neonGreen),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      body: ScanlineOverlay(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ResponsivePadding(
                child: RetroWindow(
                  title: 'USER REGISTRY // ${provider.users.length} ENTRIES',
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFilters(context, provider),
                      const Divider(height: 1),
                      Expanded(
                        child: provider.isLoading
                            ? _buildLoading()
                            : provider.error != null
                            ? _buildError(provider.error!)
                            : provider.users.isEmpty
                            ? _buildEmpty()
                            : context.isWide
                            ? _buildTable(context, provider, dateFormat)
                            : _buildCardList(context, provider, dateFormat),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 8),
      decoration: const BoxDecoration(
        color: RetroColors.surface,
        border: Border(bottom: BorderSide(color: RetroColors.surfaceBorder)),
      ),
      child: Row(
        children: [
          isMobile
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: RetroColors.neonCyan,
                    size: 20,
                  ),
                  tooltip: 'Back',
                  onPressed: widget.onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : RetroButton(
                  label: '<< BACK',
                  icon: Icons.arrow_back,
                  accentColor: RetroColors.neonCyan,
                  onPressed: widget.onBack,
                ),
          SizedBox(width: isMobile ? 8 : 16),
          Text(
            '[ USERS ]',
            style: GoogleFonts.vt323(
              fontSize: isMobile ? 20 : 24,
              color: RetroColors.neonGreen,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            Text(
              'SYS.TIME: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
              style: GoogleFonts.shareTechMono(
                fontSize: 11,
                color: RetroColors.textMuted,
              ),
            ),
            const SizedBox(width: 20),
          ],
          isMobile
              ? IconButton(
                  icon: const Icon(Icons.logout, color: RetroColors.neonRed),
                  iconSize: 20,
                  tooltip: 'Logout',
                  onPressed: () => context.read<AuthProvider>().logout(),
                )
              : RetroButton(
                  label: 'LOGOUT',
                  icon: Icons.logout,
                  accentColor: RetroColors.neonRed,
                  onPressed: () => context.read<AuthProvider>().logout(),
                ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, UserProvider provider) {
    final isMobile = context.isMobile;
    final padding = isMobile ? 8.0 : 12.0;

    if (isMobile) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Expanded(
              child: RetroTextField(
                controller: _searchController,
                hintText: '> search login...',
                prefixIcon: Icons.search,
                onChanged: (v) => provider.setSearch(v),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, color: RetroColors.neonCyan),
              iconSize: 20,
              tooltip: 'Refresh',
              onPressed: () => provider.loadUsers(),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: RetroTextField(
              controller: _searchController,
              hintText: '> search by login...',
              prefixIcon: Icons.search,
              onChanged: (v) => provider.setSearch(v),
            ),
          ),
          const SizedBox(width: 12),
          RetroButton(
            label: 'REFRESH',
            icon: Icons.refresh,
            accentColor: RetroColors.neonCyan,
            onPressed: () => provider.loadUsers(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading user registry...',
            style: GoogleFonts.shareTechMono(
              fontSize: 14,
              color: RetroColors.neonGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: RetroColors.neonRed,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              '[FATAL] $error',
              style: GoogleFonts.shareTechMono(
                fontSize: 14,
                color: RetroColors.neonRed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        '--- NO USERS FOUND ---',
        style: GoogleFonts.shareTechMono(
          fontSize: 16,
          color: RetroColors.textMuted,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    UserProvider provider,
    DateFormat dateFormat,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: context.isDesktop ? 24 : 16,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 56,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('LOGIN')),
                  DataColumn(label: Text('CREATED')),
                  DataColumn(label: Text('ACTIONS')),
                ],
                rows: provider.users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${user.id}')),
                      DataCell(
                        Text(
                          user.login,
                          style: const TextStyle(
                            color: RetroColors.neonCyan,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(Text(dateFormat.format(user.createdAt))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                                color: RetroColors.neonCyan,
                              ),
                              tooltip: 'Edit',
                              onPressed: () => _openEditDialog(user),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: RetroColors.neonRed,
                              ),
                              tooltip: 'Delete',
                              onPressed: () => _confirmDelete(user),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardList(
    BuildContext context,
    UserProvider provider,
    DateFormat dateFormat,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: provider.users.length,
      itemBuilder: (context, index) {
        final user = provider.users[index];
        return _UserCard(
          user: user,
          dateFormat: dateFormat,
          onEdit: () => _openEditDialog(user),
          onDelete: () => _confirmDelete(user),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final DateFormat dateFormat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.dateFormat,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RetroColors.surface,
          border: Border.all(color: RetroColors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${user.id}',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11,
                    color: RetroColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.login,
                    style: GoogleFonts.shareTechMono(
                      fontSize: 14,
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                    color: RetroColors.neonCyan,
                  ),
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: RetroColors.neonRed,
                  ),
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: RetroColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(user.createdAt),
                  style: GoogleFonts.shareTechMono(
                    fontSize: 12,
                    color: RetroColors.neonGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditUserFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final bool isSaving;
  final String? error;
  final VoidCallback onSave;
  final bool compact;

  const _EditUserFormBody({
    required this.formKey,
    required this.loginController,
    required this.passwordController,
    required this.isSaving,
    required this.error,
    required this.onSave,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = compact ? 10.0 : 14.0;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '> Update user details below_',
            style: GoogleFonts.shareTechMono(
              fontSize: 11,
              color: RetroColors.textMuted,
            ),
          ),
          SizedBox(height: spacing),
          RetroTextField(
            controller: loginController,
            labelText: 'LOGIN',
            hintText: 'e.g. admin',
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Login required' : null,
          ),
          SizedBox(height: spacing),
          RetroTextField(
            controller: passwordController,
            labelText: 'PASSWORD (optional)',
            hintText: 'leave blank to keep current',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          SizedBox(height: spacing),
          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: RetroColors.neonRed.withValues(alpha: 0.5),
                ),
                color: RetroColors.neonRed.withValues(alpha: 0.05),
              ),
              child: Text(
                '[ERROR] $error',
                style: GoogleFonts.shareTechMono(
                  fontSize: 11,
                  color: RetroColors.neonRed,
                ),
              ),
            ),
          ],
          RetroButton(
            label: '[ SAVE USER ]',
            icon: Icons.save,
            isLoading: isSaving,
            expanded: true,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

class _EditUserDialog extends StatefulWidget {
  final User user;

  const _EditUserDialog({required this.user});

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _loginController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController(text: widget.user.login);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final password = _passwordController.text.trim();
    final success = await provider.updateUser(
      id: widget.user.id,
      login: _loginController.text.trim(),
      password: password.isEmpty ? null : password,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: RetroWindow(
          title: 'EDIT USER // #${widget.user.id}',
          actions: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  '[ X ]',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 12,
                    color: RetroColors.neonRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          child: SingleChildScrollView(
            child: _EditUserFormBody(
              formKey: _formKey,
              loginController: _loginController,
              passwordController: _passwordController,
              isSaving: provider.isSaving,
              error: provider.error,
              onSave: _handleSave,
            ),
          ),
        ),
      ),
    );
  }
}

class _EditUserFullScreenPage extends StatefulWidget {
  final User user;

  const _EditUserFullScreenPage({required this.user});

  @override
  State<_EditUserFullScreenPage> createState() =>
      _EditUserFullScreenPageState();
}

class _EditUserFullScreenPageState extends State<_EditUserFullScreenPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _loginController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController(text: widget.user.login);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final password = _passwordController.text.trim();
    final success = await provider.updateUser(
      id: widget.user.id,
      login: _loginController.text.trim(),
      password: password.isEmpty ? null : password,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      body: ScanlineOverlay(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: const BoxDecoration(
                color: RetroColors.surface,
                border: Border(
                  bottom: BorderSide(color: RetroColors.surfaceBorder),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: RetroColors.neonRed,
                      size: 20,
                    ),
                    tooltip: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '[ EDIT USER ]',
                    style: GoogleFonts.vt323(
                      fontSize: 20,
                      color: RetroColors.neonGreen,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: RetroWindow(
                  title: 'EDIT USER // #${widget.user.id}',
                  child: _EditUserFormBody(
                    formKey: _formKey,
                    loginController: _loginController,
                    passwordController: _passwordController,
                    isSaving: provider.isSaving,
                    error: provider.error,
                    onSave: _handleSave,
                    compact: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
