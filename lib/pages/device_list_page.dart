import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/device_provider.dart';
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
            // ── Top bar ──
            _buildTopBar(context),

            // ── Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RetroWindow(
                  title:
                      'DEVICE REGISTRY // ${deviceProvider.devices.length} ENTRIES',
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      // ── Filters ──
                      _buildFilters(context, deviceProvider),
                      const Divider(height: 1),

                      // ── Table ──
                      Expanded(
                        child: deviceProvider.isLoading
                            ? _buildLoading()
                            : deviceProvider.error != null
                            ? _buildError(deviceProvider.error!)
                            : deviceProvider.devices.isEmpty
                            ? _buildEmpty()
                            : _buildTable(context, deviceProvider, dateFormat),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: RetroColors.surface,
        border: Border(bottom: BorderSide(color: RetroColors.surfaceBorder)),
      ),
      child: Row(
        children: [
          // ASCII logo
          Text(
            '[ CTRL PANEL ]',
            style: GoogleFonts.vt323(
              fontSize: 24,
              color: RetroColors.neonGreen,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          // System info
          Text(
            'SYS.TIME: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
            style: GoogleFonts.shareTechMono(
              fontSize: 11,
              color: RetroColors.textMuted,
            ),
          ),
          const SizedBox(width: 20),
          // Logout
          RetroButton(
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Search
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

          // Activity filter
          Expanded(
            flex: 2,
            child: _FilterChipRow(
              currentFilter: provider.filterActive,
              onChanged: provider.setFilter,
            ),
          ),

          const SizedBox(width: 12),

          // Refresh
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: RetroColors.neonRed, size: 48),
          const SizedBox(height: 16),
          Text(
            '[FATAL] $error',
            style: GoogleFonts.shareTechMono(
              fontSize: 14,
              color: RetroColors.neonRed,
            ),
          ),
        ],
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
    return SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 24,
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
                ),
              ),
              DataCell(Text(device.ip)),
              DataCell(Text(device.location)),
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
    );
  }
}

/// Filter chips for activity status.
class _FilterChipRow extends StatelessWidget {
  final bool? currentFilter;
  final void Function(bool?) onChanged;

  const _FilterChipRow({required this.currentFilter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chip(context, label: 'ALL', value: null),
        const SizedBox(width: 6),
        _chip(context, label: 'ONLINE', value: true),
        const SizedBox(width: 6),
        _chip(context, label: 'OFFLINE', value: false),
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              fontSize: 11,
              color: selected ? color : RetroColors.textMuted,
              letterSpacing: 1,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
