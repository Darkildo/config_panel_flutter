import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/device.dart';
import '../providers/auth_provider.dart';
import '../providers/device_provider.dart';
import '../theme/responsive.dart';
import '../theme/retro_theme.dart';
import '../widgets/retro_button.dart';
import '../widgets/retro_status_badge.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_window.dart';
import '../widgets/scanline_overlay.dart';

class DeviceListPage extends StatefulWidget {
  final void Function(int deviceId) onDeviceTap;

  const DeviceListPage({super.key, required this.onDeviceTap});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceProvider>().loadDevices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDeviceDialog() {
    final isMobile = context.isMobile;

    if (isMobile) {
      Navigator.of(context).push(
        MaterialPageRoute<bool>(
          fullscreenDialog: true,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<DeviceProvider>(),
            child: const _AddDeviceFullScreenPage(),
          ),
        ),
      );
    } else {
      showDialog<bool>(
        context: context,
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<DeviceProvider>(),
          child: const _AddDeviceDialog(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      body: ScanlineOverlay(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ResponsivePadding(
                child: RetroWindow(
                  title:
                      'DEVICE REGISTRY // ${deviceProvider.devices.length} ENTRIES',
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFilters(context, deviceProvider),
                      const Divider(height: 1),
                      Expanded(
                        child: deviceProvider.isLoading
                            ? _buildLoading()
                            : deviceProvider.error != null
                            ? _buildError(deviceProvider.error!)
                            : deviceProvider.devices.isEmpty
                            ? _buildEmpty()
                            : context.isWide
                            ? _buildTable(context, deviceProvider, dateFormat)
                            : _buildCardList(
                                context,
                                deviceProvider,
                                dateFormat,
                              ),
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
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 16,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: RetroColors.surface,
        border: Border(bottom: BorderSide(color: RetroColors.surfaceBorder)),
      ),
      child: Row(
        children: [
          Text(
            isMobile ? '[CTRL]' : '[ CTRL PANEL ]',
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
  Widget _buildFilters(BuildContext context, DeviceProvider provider) {
    final isMobile = context.isMobile;
    final padding = isMobile ? 8.0 : 12.0;

    if (isMobile) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            RetroTextField(
              controller: _searchController,
              hintText: '> search hostname...',
              prefixIcon: Icons.search,
              onChanged: (v) => provider.setSearch(v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _FilterChipRow(
                    currentFilter: provider.filterActive,
                    onChanged: provider.setFilter,
                    compact: true,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh, color: RetroColors.neonCyan),
                  iconSize: 20,
                  tooltip: 'Refresh',
                  onPressed: () => provider.loadDevices(),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: RetroColors.neonGreen,
                  ),
                  iconSize: 20,
                  tooltip: 'Add Device',
                  onPressed: _openAddDeviceDialog,
                ),
              ],
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
              hintText: '> search by hostname...',
              prefixIcon: Icons.search,
              onChanged: (v) => provider.setSearch(v),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _FilterChipRow(
              currentFilter: provider.filterActive,
              onChanged: provider.setFilter,
            ),
          ),
          const SizedBox(width: 12),
          RetroButton(
            label: 'REFRESH',
            icon: Icons.refresh,
            accentColor: RetroColors.neonCyan,
            onPressed: () => provider.loadDevices(),
          ),
          const SizedBox(width: 8),
          RetroButton(
            label: 'ADD DEVICE',
            icon: Icons.add_circle_outline,
            accentColor: RetroColors.neonGreen,
            onPressed: _openAddDeviceDialog,
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
            'Loading device registry...',
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
        '--- NO DEVICES FOUND ---',
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
    DeviceProvider provider,
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
                  DataColumn(label: Text('HOSTNAME')),
                  DataColumn(label: Text('IP ADDRESS')),
                  DataColumn(label: Text('LOCATION')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('CREATED')),
                ],
                rows: provider.devices.map((device) {
                  return DataRow(
                    onSelectChanged: (_) => widget.onDeviceTap(device.id),
                    cells: [
                      DataCell(Text('#${device.id}')),
                      DataCell(
                        Text(
                          device.hostname,
                          style: const TextStyle(
                            color: RetroColors.neonCyan,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(Text(device.ip)),
                      DataCell(
                        Text(device.location, overflow: TextOverflow.ellipsis),
                      ),
                      DataCell(
                        RetroStatusBadge(
                          label: device.isActive ? 'ONLINE' : 'OFFLINE',
                          active: device.isActive,
                        ),
                      ),
                      DataCell(Text(dateFormat.format(device.createdAt))),
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
    DeviceProvider provider,
    DateFormat dateFormat,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: provider.devices.length,
      itemBuilder: (context, index) {
        final device = provider.devices[index];
        return _DeviceCard(
          device: device,
          dateFormat: dateFormat,
          onTap: () => widget.onDeviceTap(device.id),
        );
      },
    );
  }
}
class _DeviceCard extends StatelessWidget {
  final Device device;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const _DeviceCard({
    required this.device,
    required this.dateFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: RetroColors.surface,
              border: Border.all(color: RetroColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${device.id}',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 11,
                        color: RetroColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        device.hostname,
                        style: GoogleFonts.shareTechMono(
                          fontSize: 14,
                          color: RetroColors.neonCyan,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    RetroStatusBadge(
                      label: device.isActive ? 'ON' : 'OFF',
                      active: device.isActive,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.lan_outlined,
                      size: 12,
                      color: RetroColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      device.ip,
                      style: GoogleFonts.shareTechMono(
                        fontSize: 12,
                        color: RetroColors.neonGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: RetroColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        device.location,
                        style: GoogleFonts.shareTechMono(
                          fontSize: 12,
                          color: RetroColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dateFormat.format(device.createdAt),
                      style: GoogleFonts.shareTechMono(
                        fontSize: 10,
                        color: RetroColors.textDim,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: RetroColors.neonGreen,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _FilterChipRow extends StatelessWidget {
  final bool? currentFilter;
  final void Function(bool?) onChanged;
  final bool compact;

  const _FilterChipRow({
    required this.currentFilter,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chip(context, label: 'ALL', value: null),
        SizedBox(width: compact ? 4 : 6),
        _chip(context, label: compact ? 'ON' : 'ONLINE', value: true),
        SizedBox(width: compact ? 4 : 6),
        _chip(context, label: compact ? 'OFF' : 'OFFLINE', value: false),
      ],
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool? value,
  }) {
    final selected = currentFilter == value;
    final color = value == null
        ? RetroColors.neonCyan
        : value
        ? RetroColors.neonGreen
        : RetroColors.neonRed;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 10,
              vertical: 4,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              border: Border.all(
                color: selected ? color : RetroColors.surfaceBorder,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.shareTechMono(
                fontSize: compact ? 10 : 11,
                color: selected ? color : RetroColors.textMuted,
                letterSpacing: 1,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
class _AddDeviceFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController hostnameController;
  final TextEditingController ipController;
  final TextEditingController locationController;
  final bool isActive;
  final ValueChanged<bool> onActiveChanged;
  final bool isSaving;
  final String? error;
  final VoidCallback onSave;
  final bool compact;

  const _AddDeviceFormBody({
    required this.formKey,
    required this.hostnameController,
    required this.ipController,
    required this.locationController,
    required this.isActive,
    required this.onActiveChanged,
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
            '> Fill in device details below_',
            style: GoogleFonts.shareTechMono(
              fontSize: 11,
              color: RetroColors.textMuted,
            ),
          ),
          SizedBox(height: spacing),
          RetroTextField(
            controller: hostnameController,
            labelText: 'HOSTNAME',
            hintText: 'e.g. srv-web-01.dc1.local',
            prefixIcon: Icons.dns_outlined,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Hostname required' : null,
          ),
          SizedBox(height: spacing),
          RetroTextField(
            controller: ipController,
            labelText: 'IP ADDRESS',
            hintText: 'e.g. 192.168.1.10',
            prefixIcon: Icons.lan_outlined,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'IP address required' : null,
          ),
          SizedBox(height: spacing),
          RetroTextField(
            controller: locationController,
            labelText: 'LOCATION',
            hintText: 'e.g. DC-1 Rack A3',
            prefixIcon: Icons.location_on_outlined,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Location required' : null,
          ),
          SizedBox(height: spacing),

          _ActiveToggle(
            isActive: isActive,
            onChanged: onActiveChanged,
            compact: compact,
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
            label: '[ CREATE DEVICE ]',
            icon: Icons.add_circle_outline,
            isLoading: isSaving,
            expanded: true,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}
class _ActiveToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final bool compact;

  const _ActiveToggle({
    required this.isActive,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!isActive),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 12,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? RetroColors.neonGreen.withValues(alpha: 0.08)
                : RetroColors.neonRed.withValues(alpha: 0.08),
            border: Border.all(
              color: isActive
                  ? RetroColors.neonGreen.withValues(alpha: 0.4)
                  : RetroColors.surfaceBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? Icons.power : Icons.power_off,
                size: compact ? 16 : 18,
                color: isActive ? RetroColors.neonGreen : RetroColors.neonRed,
              ),
              const SizedBox(width: 10),
              Text(
                'STATUS:',
                style: GoogleFonts.shareTechMono(
                  fontSize: compact ? 11 : 12,
                  color: RetroColors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              RetroStatusBadge(
                label: isActive ? 'ONLINE' : 'OFFLINE',
                active: isActive,
              ),
              const Spacer(),
              Text(
                isActive ? '[ ON ]' : '[ OFF ]',
                style: GoogleFonts.shareTechMono(
                  fontSize: compact ? 10 : 11,
                  color: isActive ? RetroColors.neonGreen : RetroColors.neonRed,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _AddDeviceDialog extends StatefulWidget {
  const _AddDeviceDialog();

  @override
  State<_AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<_AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hostnameController = TextEditingController();
  final _ipController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _hostnameController.dispose();
    _ipController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DeviceProvider>();
    final success = await provider.createDevice(
      hostname: _hostnameController.text.trim(),
      ip: _ipController.text.trim(),
      location: _locationController.text.trim(),
      isActive: _isActive,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: RetroWindow(
          title: 'NEW DEVICE // REGISTER',
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
            child: _AddDeviceFormBody(
              formKey: _formKey,
              hostnameController: _hostnameController,
              ipController: _ipController,
              locationController: _locationController,
              isActive: _isActive,
              onActiveChanged: (v) => setState(() => _isActive = v),
              isSaving: provider.isCreating,
              error: provider.createError,
              onSave: _handleCreate,
            ),
          ),
        ),
      ),
    );
  }
}
class _AddDeviceFullScreenPage extends StatefulWidget {
  const _AddDeviceFullScreenPage();

  @override
  State<_AddDeviceFullScreenPage> createState() =>
      _AddDeviceFullScreenPageState();
}

class _AddDeviceFullScreenPageState extends State<_AddDeviceFullScreenPage> {
  final _formKey = GlobalKey<FormState>();
  final _hostnameController = TextEditingController();
  final _ipController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _hostnameController.dispose();
    _ipController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DeviceProvider>();
    final success = await provider.createDevice(
      hostname: _hostnameController.text.trim(),
      ip: _ipController.text.trim(),
      location: _locationController.text.trim(),
      isActive: _isActive,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();

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
                    '[ NEW DEVICE ]',
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
                  title: 'REGISTER DEVICE',
                  child: _AddDeviceFormBody(
                    formKey: _formKey,
                    hostnameController: _hostnameController,
                    ipController: _ipController,
                    locationController: _locationController,
                    isActive: _isActive,
                    onActiveChanged: (v) => setState(() => _isActive = v),
                    isSaving: provider.isCreating,
                    error: provider.createError,
                    onSave: _handleCreate,
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
