import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/config.dart';
import '../models/device.dart';
import '../providers/auth_provider.dart';
import '../providers/config_provider.dart';
import '../providers/device_provider.dart';
import '../theme/responsive.dart';
import '../theme/retro_theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_status_badge.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_window.dart';
import '../widgets/scanline_overlay.dart';

class DeviceDetailPage extends StatefulWidget {
  final int deviceId;
  final VoidCallback onBack;

  const DeviceDetailPage({
    super.key,
    required this.deviceId,
    required this.onBack,
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  final _versionController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _expandedConfigId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigProvider>().loadConfigs(widget.deviceId);
    });
  }

  @override
  void dispose() {
    _versionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final configProvider = context.watch<ConfigProvider>();
    final device = deviceProvider.getDeviceById(widget.deviceId);
    final isWide = context.isWide;

    return Scaffold(
      body: ScanlineOverlay(
        child: Column(
          children: [
            _buildTopBar(context, device),
            Expanded(
              child: isWide
                  ? _buildWideLayout(device, configProvider)
                  : _buildNarrowLayout(device, configProvider),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWideLayout(Device? device, ConfigProvider configProvider) {
    return Padding(
      padding: EdgeInsets.all(context.isDesktop ? 16 : 12),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDeviceInfo(device),
                  const SizedBox(height: 16),
                  _buildUploadForm(configProvider),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: _buildConfigHistory(configProvider)),
        ],
      ),
    );
  }
  Widget _buildNarrowLayout(Device? device, ConfigProvider configProvider) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: RetroColors.surface,
            child: TabBar(
              indicatorColor: RetroColors.neonGreen,
              labelColor: RetroColors.neonGreen,
              unselectedLabelColor: RetroColors.textMuted,
              labelStyle: GoogleFonts.shareTechMono(fontSize: 11),
              tabs: const [
                Tab(text: 'INFO'),
                Tab(text: 'HISTORY'),
                Tab(text: 'UPLOAD'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: _buildDeviceInfo(device),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildConfigHistory(configProvider),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: _buildUploadForm(configProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTopBar(BuildContext context, Device? device) {
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

          Expanded(
            child: Row(
              children: [
                Text(
                  isMobile
                      ? '#${widget.deviceId}'
                      : '[ DEVICE #${widget.deviceId} ]',
                  style: GoogleFonts.vt323(
                    fontSize: isMobile ? 18 : 24,
                    color: RetroColors.neonGreen,
                    letterSpacing: 2,
                  ),
                ),
                if (device != null && !isMobile) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      device.hostname,
                      style: GoogleFonts.shareTechMono(
                        fontSize: 16,
                        color: RetroColors.neonCyan,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          isMobile
              ? IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: RetroColors.neonRed,
                    size: 20,
                  ),
                  tooltip: 'Logout',
                  onPressed: () => context.read<AuthProvider>().logout(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
  Widget _buildDeviceInfo(Device? device) {
    if (device == null) {
      return RetroWindow(
        title: 'DEVICE INFO',
        child: Center(
          child: Text(
            'Device not found',
            style: GoogleFonts.shareTechMono(color: RetroColors.neonRed),
          ),
        ),
      );
    }

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return RetroWindow(
      title: 'DEVICE INFO',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _infoRow('HOSTNAME', device.hostname, RetroColors.neonCyan),
          _infoRow('IP ADDR', device.ip, RetroColors.neonGreen),
          _infoRow('LOCATION', device.location, RetroColors.neonYellow),
          _infoRow(
            'CREATED',
            dateFormat.format(device.createdAt),
            RetroColors.textMuted,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'STATUS:  ',
                style: GoogleFonts.shareTechMono(
                  fontSize: 12,
                  color: RetroColors.textMuted,
                ),
              ),
              RetroStatusBadge(
                label: device.isActive ? 'ONLINE' : 'OFFLINE',
                active: device.isActive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    final isMobile = context.isMobile;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: isMobile
          ? Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '$label:',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11,
                    color: RetroColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    fontSize: 13,
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: .start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    '$label:',
                    style: GoogleFonts.shareTechMono(
                      fontSize: 12,
                      color: RetroColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.shareTechMono(
                      fontSize: 13,
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  Widget _buildUploadForm(ConfigProvider configProvider) {
    return RetroWindow(
      title: 'UPLOAD NEW CONFIG',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Text(
              '> Paste configuration content below_',
              style: GoogleFonts.shareTechMono(
                fontSize: 11,
                color: RetroColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            RetroTextField(
              controller: _versionController,
              labelText: 'VERSION',
              hintText: 'e.g. v1.3.0',
              prefixIcon: Icons.tag,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Version required' : null,
            ),
            const SizedBox(height: 12),
            RetroTextField(
              controller: _contentController,
              labelText: 'CONFIGURATION CONTENT',
              hintText: '# paste config here...',
              maxLines: context.isMobile ? 5 : 8,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Content required' : null,
            ),
            const SizedBox(height: 16),
            if (configProvider.error != null) ...[
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
                  '[ERROR] ${configProvider.error}',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11,
                    color: RetroColors.neonRed,
                  ),
                ),
              ),
            ],
            RetroButton(
              label: '[ SAVE CONFIG ]',
              icon: Icons.save,
              isLoading: configProvider.isSaving,
              expanded: true,
              onPressed: () => _handleSave(configProvider),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave(ConfigProvider configProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await configProvider.createConfig(
      deviceId: widget.deviceId,
      version: _versionController.text.trim(),
      content: _contentController.text,
    );

    if (success && mounted) {
      _versionController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '> Config saved successfully',
            style: GoogleFonts.shareTechMono(color: RetroColors.neonGreen),
          ),
        ),
      );
    }
  }
  Widget _buildConfigHistory(ConfigProvider configProvider) {
    return RetroWindow(
      title: 'CONFIG HISTORY // ${configProvider.configs.length} VERSIONS',
      padding: EdgeInsets.zero,
      child: configProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : configProvider.configs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '--- NO CONFIGURATIONS ---',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 14,
                    color: RetroColors.textMuted,
                    letterSpacing: 3,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: configProvider.configs.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: RetroColors.surfaceBorder),
              itemBuilder: (context, index) {
                final config = configProvider.configs[index];
                return _ConfigTile(
                  config: config,
                  isExpanded: _expandedConfigId == config.id,
                  isMobile: context.isMobile,
                  onToggle: () {
                    setState(() {
                      _expandedConfigId = _expandedConfigId == config.id
                          ? null
                          : config.id;
                    });
                  },
                  onApply: config.isApplied
                      ? null
                      : () => _handleApply(configProvider, config),
                  isApplying: configProvider.isApplying,
                );
              },
            ),
    );
  }

  Future<void> _handleApply(
    ConfigProvider configProvider,
    DeviceConfig config,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('APPLY CONFIG ${config.version}?'),
        content: Text(
          'This will mark configuration ${config.version} as applied. Continue?',
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
            child: const Text('APPLY'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await configProvider.applyConfig(
        config.id,
        widget.deviceId,
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '> Config ${config.version} marked as applied',
              style: GoogleFonts.shareTechMono(color: RetroColors.neonGreen),
            ),
          ),
        );
      }
    }
  }
}
class _ConfigTile extends StatelessWidget {
  final DeviceConfig config;
  final bool isExpanded;
  final bool isMobile;
  final VoidCallback onToggle;
  final VoidCallback? onApply;
  final bool isApplying;

  const _ConfigTile({
    required this.config,
    required this.isExpanded,
    required this.isMobile,
    required this.onToggle,
    this.onApply,
    required this.isApplying,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 8 : 10,
            ),
            child: isMobile
                ? _buildMobileHeader(dateFormat)
                : _buildDesktopHeader(dateFormat),
          ),
        ),

        if (isExpanded)
          Container(
            margin: EdgeInsets.fromLTRB(
              isMobile ? 8 : 12,
              0,
              isMobile ? 8 : 12,
              isMobile ? 8 : 12,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1A),
              border: Border.all(color: RetroColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Text(
                      '// CONFIG CONTENT',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 11,
                        color: RetroColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'ID: #${config.id}',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 11,
                        color: RetroColors.textDim,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  config.content,
                  style: GoogleFonts.courierPrime(
                    fontSize: isMobile ? 12 : 13,
                    color: RetroColors.neonGreen.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  Widget _buildMobileHeader(DateFormat dateFormat) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: RetroColors.neonCyan,
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                config.version,
                style: GoogleFonts.shareTechMono(
                  fontSize: 13,
                  color: RetroColors.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (config.isApplied)
              const RetroStatusBadge(
                label: 'APPLIED',
                active: true,
                activeColor: RetroColors.neonGreen,
              )
            else
              const RetroStatusBadge(
                label: 'PENDING',
                active: false,
                inactiveColor: RetroColors.neonYellow,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'created: ${dateFormat.format(config.createdAt)}',
          style: GoogleFonts.shareTechMono(
            fontSize: 10,
            color: RetroColors.textMuted,
          ),
        ),
        if (config.isApplied)
          Text(
            'applied: ${dateFormat.format(config.appliedAt!)}',
            style: GoogleFonts.shareTechMono(
              fontSize: 10,
              color: RetroColors.neonGreen.withValues(alpha: 0.6),
            ),
          ),
        if (!config.isApplied) ...[
          const SizedBox(height: 6),
          RetroButton(
            label: 'APPLY',
            icon: Icons.check_circle_outline,
            accentColor: RetroColors.neonOrange,
            isLoading: isApplying,
            onPressed: onApply,
            expanded: true,
          ),
        ],
      ],
    );
  }
  Widget _buildDesktopHeader(DateFormat dateFormat) {
    return Row(
      children: [
        Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: RetroColors.neonCyan,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          config.version,
          style: GoogleFonts.shareTechMono(
            fontSize: 14,
            color: RetroColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'created: ${dateFormat.format(config.createdAt)}',
          style: GoogleFonts.shareTechMono(
            fontSize: 11,
            color: RetroColors.textMuted,
          ),
        ),
        const Spacer(),
        if (config.isApplied) ...[
          Text(
            'applied: ${dateFormat.format(config.appliedAt!)}',
            style: GoogleFonts.shareTechMono(
              fontSize: 11,
              color: RetroColors.neonGreen.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          const RetroStatusBadge(
            label: 'APPLIED',
            active: true,
            activeColor: RetroColors.neonGreen,
          ),
        ] else ...[
          const RetroStatusBadge(
            label: 'PENDING',
            active: false,
            inactiveColor: RetroColors.neonYellow,
          ),
          const SizedBox(width: 8),
          RetroButton(
            label: 'APPLY',
            icon: Icons.check_circle_outline,
            accentColor: RetroColors.neonOrange,
            isLoading: isApplying,
            onPressed: onApply,
          ),
        ],
      ],
    );
  }
}
