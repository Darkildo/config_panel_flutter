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
                    crossAxisAlignment: .stretch,
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

  // ── TOP BAR ──

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

  // ── FILTERS ──

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
        ],
      ),
    );
  }

  // ── STATES ──

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

  // ── DESKTOP TABLE ──

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

  // ── MOBILE CARD LIST ──

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

// ══════════════════════════════════════════════════════════════
//  MOBILE DEVICE CARD
// ══════════════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════════════
//  FILTER CHIPS
// ══════════════════════════════════════════════════════════════

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
