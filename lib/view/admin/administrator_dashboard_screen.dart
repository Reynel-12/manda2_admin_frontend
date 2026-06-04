import 'package:flutter/material.dart' hide Chip;
import 'package:intl/intl.dart';
import 'package:manda2_admin_frontend/const/colors.dart';
import 'package:manda2_admin_frontend/view/admin/screens/admin_users_screen.dart';
import 'package:manda2_admin_frontend/view/admin/screens/admin_businesses_screen.dart';
import 'package:manda2_admin_frontend/view/admin/screens/admin_reports_screen.dart';
import 'package:manda2_admin_frontend/view/widgets/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS & MODELS
// ─────────────────────────────────────────────────────────────────────────────
class AppStat {
  final String title, value, change;
  final IconData icon;
  final Color color;
  AppStat({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });
}

class ActivityItem {
  final String title, subtitle, time;
  final IconData icon;
  final Color color;
  final ActivityType type;
  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
    required this.type,
  });
}

enum ActivityType { newBusiness, report, payment, security, newUser, order }

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEMS
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  final int index;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
}

const _navItems = [
  _NavItem(
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
    label: 'Dashboard',
    index: 0,
  ),
  _NavItem(
    icon: Icons.people_outlined,
    activeIcon: Icons.people_rounded,
    label: 'Usuarios',
    index: 1,
  ),
  _NavItem(
    icon: Icons.store_outlined,
    activeIcon: Icons.store_rounded,
    label: 'Negocios',
    index: 2,
  ),
  // _NavItem(
  //   icon: Icons.delivery_dining_outlined,
  //   activeIcon: Icons.delivery_dining_rounded,
  //   label: 'Repartidores',
  //   index: 3,
  // ),
  _NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'Reportes',
    index: 4,
  ),
  _NavItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    label: 'Config.',
    index: 3,
  ),
  _NavItem(
    icon: Icons.security_outlined,
    activeIcon: Icons.security_rounded,
    label: 'Seguridad',
    index: 5,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  final _periodPresets = const [
    'Hoy',
    'Esta semana',
    'Este mes',
    'Ultimos 30 dias',
  ];
  String _selectedPeriod = 'Este mes';
  DateTime? _customDate;
  DateTimeRange? _customRange;

  // ── DATA ──────────────────────────────────────────────────────────────────

  final _activities = [
    ActivityItem(
      title: 'Nuevo negocio registrado',
      subtitle: 'Panadería Dulce Hogar se unió a la plataforma',
      time: 'Hace 15 min',
      icon: Icons.storefront_outlined,
      color: C.success,
      type: ActivityType.newBusiness,
    ),
    ActivityItem(
      title: 'Reporte de problema',
      subtitle: 'Usuario reportó problema con pedido #ORD12345',
      time: 'Hace 30 min',
      icon: Icons.warning_amber_outlined,
      color: C.warning,
      type: ActivityType.report,
    ),
    ActivityItem(
      title: 'Nuevo usuario registrado',
      subtitle: 'Ana García creó su cuenta de cliente',
      time: 'Hace 1 h',
      icon: Icons.person_add_outlined,
      color: C.primary,
      type: ActivityType.newUser,
    ),
    ActivityItem(
      title: 'Liquidación procesada',
      subtitle: 'Liquidación #LIQ789 completada — L 12,500',
      time: 'Hace 2 h',
      icon: Icons.payments_outlined,
      color: C.purple,
      type: ActivityType.payment,
    ),
    ActivityItem(
      title: 'Intento bloqueado',
      subtitle: 'Acceso sospechoso desde IP 192.168.1.100',
      time: 'Hace 5 h',
      icon: Icons.gpp_bad_outlined,
      color: C.error,
      type: ActivityType.security,
    ),
    ActivityItem(
      title: 'Pedido completado',
      subtitle: 'Pedido #ORD98765 entregado exitosamente',
      time: 'Hace 6 h',
      icon: Icons.check_circle_outlined,
      color: C.success,
      type: ActivityType.order,
    ),
  ];
  final _appStats = [
    AppStat(
      title: 'Usuarios activos',
      value: '1,245',
      change: '+12%',
      icon: Icons.people_outlined,
      color: C.primary,
    ),
    AppStat(
      title: 'Pedidos hoy',
      value: '356',
      change: '+8%',
      icon: Icons.shopping_cart_outlined,
      color: C.accent,
    ),
    AppStat(
      title: 'Negocios activos',
      value: '89',
      change: '+5%',
      icon: Icons.store_outlined,
      color: C.success,
    ),
    AppStat(
      title: 'Repartidores',
      value: '45',
      change: '+15%',
      icon: Icons.delivery_dining_outlined,
      color: C.purple,
    ),
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: C.bg,
      body: Row(
        children: [
          if (isWide) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(isWide),
                // Search bar for list sections
                if (_selectedIndex == 1 ||
                    _selectedIndex == 2 ||
                    _selectedIndex == 3)
                  _buildSearchBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? S.lg : S.md,
                      vertical: S.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(),
                        const SizedBox(height: S.md),
                        _buildQuickStats(isWide),
                        const SizedBox(height: S.md),
                        _buildSelectedContent(isWide),
                        const SizedBox(height: S.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isWide ? _buildBottomNavBar() : null,
    );
  }

  // ── TOP BAR ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(bool isWide) {
    final now = DateTime.now();
    final dateLabel = DateFormat('EEEE, d MMMM yyyy').format(now);

    if (!isWide) {
      return Container(
        padding: const EdgeInsets.fromLTRB(S.md, 12, S.md, 12),
        decoration: BoxDecoration(
          color: C.surface,
          border: Border(bottom: BorderSide(color: C.divider.withOpacity(0.9))),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: C.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Panel de administracion',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: C.primary,
                      ),
                    ),
                  ),
                  _TopBarAction(
                    icon: Icons.notifications_outlined,
                    badge: '3',
                    onTap: () => _showNotifications(context),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showAdminProfile(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: C.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: C.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                dateLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: C.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isWide ? S.lg : S.md),
      decoration: BoxDecoration(
        color: C.surface,
        border: Border(bottom: BorderSide(color: C.divider.withOpacity(0.9))),
      ),
      child: Row(
        children: [
          if (!isWide) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: C.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: S.sm),
          ],
          Expanded(
            child: Text(
              dateLabel,
              style: const TextStyle(
                fontSize: 13,
                color: C.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _TopBarAction(
            icon: Icons.notifications_outlined,
            badge: '3',
            onTap: () => _showNotifications(context),
          ),
          const SizedBox(width: S.sm),
          GestureDetector(
            onTap: () => _showAdminProfile(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: C.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: C.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    final hints = {
      1: 'Buscar usuarios...',
      2: 'Buscar negocios...',
      3: 'Buscar repartidores...',
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(S.md, 10, S.md, 10),
      color: C.surface,
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontSize: 14, color: C.textSec),
        decoration: InputDecoration(
          hintText: hints[_selectedIndex] ?? 'Buscar...',
          hintStyle: const TextStyle(color: C.textMuted, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: C.primary,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: C.textMuted,
                  ),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: C.bg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(R.input),
            borderSide: const BorderSide(color: C.divider, width: 0.8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(R.input),
            borderSide: const BorderSide(color: C.divider, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(R.input),
            borderSide: const BorderSide(color: C.primary, width: 1.3),
          ),
        ),
      ),
    );
  }

  // ── SIDEBAR ───────────────────────────────────────────────────────────────

  Widget _buildSidebar() {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(right: BorderSide(color: C.divider, width: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: S.md),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: C.divider, width: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: C.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: S.sm),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manda2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: C.primary,
                      ),
                    ),
                    Text(
                      'Panel Admin',
                      style: TextStyle(fontSize: 11, color: C.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: S.sm,
                vertical: S.sm,
              ),
              child: Column(
                children: [
                  ..._navItems
                      .take(4)
                      .map(
                        (item) => _SidebarItem(
                          item: item,
                          isSelected: _selectedIndex == item.index,
                          onTap: () => setState(() {
                            _selectedIndex = item.index;
                            _searchQuery = '';
                            _searchCtrl.clear();
                          }),
                        ),
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: S.sm,
                      vertical: S.sm,
                    ),
                    child: Divider(height: 1, color: C.divider),
                  ),
                  ..._navItems
                      .skip(4)
                      .map(
                        (item) => _SidebarItem(
                          item: item,
                          isSelected: _selectedIndex == item.index,
                          onTap: () => setState(() {
                            _selectedIndex = item.index;
                            _searchQuery = '';
                            _searchCtrl.clear();
                          }),
                        ),
                      ),
                ],
              ),
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(S.md),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text(
                      'Nuevo usuario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(R.button),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: S.sm),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: TextButton.icon(
                    onPressed: () => _confirmLogout(context),
                    icon: const Icon(Icons.logout_rounded, size: 14),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(foregroundColor: C.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────────────────────

  Widget _buildBottomNavBar() {
    final mobileItems = _navItems;
    final currentIdx = mobileItems.indexWhere((i) => i.index == _selectedIndex);
    final safeIdx = currentIdx < 0 ? 0 : currentIdx;

    return Container(
      decoration: BoxDecoration(
        color: C.surface,
        border: Border(top: BorderSide(color: C.divider.withOpacity(0.9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: mobileItems.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                final isActive = safeIdx == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedIndex = item.index;
                      _searchQuery = '';
                      _searchCtrl.clear();
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      constraints: const BoxConstraints(minWidth: 88),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? C.primarySoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isActive
                            ? Border.all(
                                color: C.primary.withOpacity(0.2),
                                width: 0.8,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: 20,
                            color: isActive ? C.primary : C.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isActive ? C.primary : C.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ── SECTION HEADER ────────────────────────────────────────────────────────

  Widget _buildSectionHeader() {
    final showPeriodControls = _selectedIndex == 0 || _selectedIndex == 5;
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getSectionTitle(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: C.primary,
                  letterSpacing: -0.35,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getSubtitle(),
                style: const TextStyle(
                  fontSize: 13,
                  color: C.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (showPeriodControls) _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    final isCustom = _customDate != null || _customRange != null;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.divider, width: 0.8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(Icons.expand_more_rounded, color: C.textMuted),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: C.textSec,
              ),
              items: _periodPresets
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedPeriod = value;
                  _customDate = null;
                  _customRange = null;
                });
              },
            ),
          ),
        ),
        InkWell(
          onTap: _showPeriodCalendarPicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isCustom ? C.primarySoft : C.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCustom ? C.primary.withOpacity(0.35) : C.divider,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: C.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _periodLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCustom ? C.primary : C.textSec,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPeriodCalendarPicker() async {
    final mode = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetHandle(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Seleccion de fecha',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: C.textSec,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _calendarOptionTile(
                  icon: Icons.calendar_today_rounded,
                  title: 'Fecha especifica',
                  subtitle: 'Selecciona un unico dia',
                  onTap: () => Navigator.pop(ctx, 'single'),
                ),
                const SizedBox(height: 10),
                _calendarOptionTile(
                  icon: Icons.date_range_rounded,
                  title: 'Rango de fechas',
                  subtitle: 'Selecciona un periodo personalizado',
                  onTap: () => Navigator.pop(ctx, 'range'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mode == null) return;

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final lastDate = DateTime(now.year + 2);

    if (mode == 'single') {
      final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: _customDate ?? now,
        helpText: 'Selecciona una fecha',
        cancelText: 'Cancelar',
        confirmText: 'Aplicar',
      );
      if (pickedDate != null) {
        setState(() {
          _customDate = pickedDate;
          _customRange = null;
          _selectedPeriod = 'Fecha personalizada';
        });
      }
      return;
    }

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: _customRange,
      helpText: 'Selecciona un periodo',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
    );

    if (pickedRange != null) {
      setState(() {
        _customRange = pickedRange;
        _customDate = null;
        _selectedPeriod = 'Periodo personalizado';
      });
    }
  }

  Widget _calendarOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: C.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.divider, width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: C.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: C.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: C.textSec,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: C.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: C.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  String _periodLabel() {
    if (_customRange != null) {
      final start = DateFormat('dd/MM/yyyy').format(_customRange!.start);
      final end = DateFormat('dd/MM/yyyy').format(_customRange!.end);
      return '$start - $end';
    }
    if (_customDate != null) {
      return DateFormat('dd/MM/yyyy').format(_customDate!);
    }
    return 'Calendario';
  }

  String _getSectionTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Usuarios';
      case 2:
        return 'Negocios';
      // case 3:
      //   return 'Repartidores';
      case 3:
        return 'Configuración';
      case 4:
        return 'Reportes';
      case 5:
        return 'Seguridad';
      default:
        return 'Dashboard';
    }
  }

  String _getSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Resumen de la plataforma';
      case 1:
        return 'Gestion de usuarios de la plataforma';
      case 2:
        return 'Gestion de negocios de la plataforma';
      // case 3:
      //   return 'Gestion de repartidores de la plataforma';
      case 3:
        return 'Configuración de la plataforma';
      case 4:
        return 'Reportes y análisis de datos';
      case 5:
        return 'Seguridad y permisos del sistema';
      default:
        return '';
    }
  }

  // ── STATS CARDS ───────────────────────────────────────────────────────────

  Widget _buildQuickStats(bool isWide) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: isWide ? 1.65 : 1.35,
      ),
      itemCount: _appStats.length,
      itemBuilder: (_, i) => _StatCard(stat: _appStats[i]),
    );
  }

  // ── CONTENT ROUTER ────────────────────────────────────────────────────────

  Widget _buildSelectedContent(bool isWide) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(isWide);
      case 1:
        return AdminUsersScreen(searchQuery: _searchQuery);
      case 2:
        return AdminBusinessesScreen(searchQuery: _searchQuery);
      // case 3:
      //   return AdminDeliveryScreen(searchQuery: _searchQuery);
      case 3:
        return _buildSettings();
      case 4:
        return const AdminReportsScreen();
      case 5:
        return _buildSecurity();
      default:
        return _buildDashboard(isWide);
    }
  }

  // ── DASHBOARD ─────────────────────────────────────────────────────────────

  Widget _buildDashboard(bool isWide) {
    return Column(
      children: [
        ContentCard(
          header: CardHeader(
            title: 'Actividad reciente',
            action: TextButton(
              onPressed: () => _showAllActivity(context),
              style: TextButton.styleFrom(
                foregroundColor: C.accent,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Ver todo',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: Column(
            children: _activities.take(4).toList().asMap().entries.map((e) {
              final isLast = e.key == 3;
              return Column(
                children: [
                  _ActivityRow(item: e.value),
                  if (!isLast) const RowSep(),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: S.md),
        if (isWide)
          Row(
            children: [
              Expanded(child: _buildMiniStats()),
              const SizedBox(width: S.sm),
              Expanded(child: _buildPendingActions()),
            ],
          )
        else ...[
          _buildMiniStats(),
          const SizedBox(height: S.sm),
          _buildPendingActions(),
        ],
        const SizedBox(height: S.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Agregar negocio',
                icon: Icons.store_outlined,
                color: C.primary,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ),
            const SizedBox(width: S.sm),
            Expanded(
              child: _QuickActionButton(
                label: 'Agregar repartidor',
                icon: Icons.delivery_dining_outlined,
                color: C.accent,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStats() {
    return ContentCard(
      header: const CardHeader(title: 'Estado del sistema'),
      child: Column(
        children: [
          _MiniStatRow(
            label: 'Usuarios bloqueados',
            value: '3',
            color: C.error,
          ),
          const RowSep(),
          _MiniStatRow(
            label: 'Negocios pendientes',
            value: '1',
            color: C.warning,
          ),
          const RowSep(),
          _MiniStatRow(
            label: 'Reportes sin resolver',
            value: '2',
            color: C.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActions() {
    return ContentCard(
      header: const CardHeader(title: 'Acciones pendientes'),
      child: Column(
        children: [
          _PendingActionRow(
            label: 'Aprobar negocio',
            subtitle: 'Cafetería Central esperando',
            icon: Icons.store_outlined,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          const RowSep(),
          _PendingActionRow(
            label: 'Ver reporte',
            subtitle: 'Pedido #ORD12345 reportado',
            icon: Icons.warning_amber_outlined,
            onTap: () => setState(() => _selectedIndex = 5),
          ),
        ],
      ),
    );
  }

  //  DELIVERY ──────────────────────────────────────────────────────────────
  //  SETTINGS ──────────────────────────────────────────────────────────────

  Widget _buildSettings() {
    return ContentCard(
      child: Column(
        children: [
          _SettingRow(
            icon: Icons.percent_outlined,
            label: 'Comisiones',
            subtitle: 'Porcentajes por tipo de negocio',
            onTap: () {},
          ),
          const RowSep(),
          _SettingRow(
            icon: Icons.credit_card_outlined,
            label: 'Métodos de pago',
            subtitle: 'Gestionar métodos aceptados',
            onTap: () {},
          ),
          const RowSep(),
          _SettingRow(
            icon: Icons.notifications_outlined,
            label: 'Notificaciones',
            subtitle: 'Sistema push y email',
            onTap: () {},
          ),
          const RowSep(),
          _SettingRow(
            icon: Icons.map_outlined,
            label: 'Regiones y zonas',
            subtitle: 'Zonas de cobertura del servicio',
            onTap: () {},
          ),
          const RowSep(),
          _SettingRow(
            icon: Icons.backup_outlined,
            label: 'Backup y restauración',
            subtitle: 'Copias de seguridad',
            onTap: () {},
          ),
          const RowSep(),
          _SettingRow(
            icon: Icons.logout_rounded,
            label: 'Cerrar sesión',
            subtitle: 'Salir de la cuenta de administrador',
            onTap: () => _confirmLogout(context),
            isDanger: true,
          ),
        ],
      ),
    );
  }

  // ── REPORTS ───────────────────────────────────────────────────────────────
  //SECURITY ──────────────────────────────────────────────────────────────

  Widget _buildSecurity() {
    return Column(
      children: [
        ContentCard(
          header: const CardHeader(title: 'Configuración de seguridad'),
          child: Column(
            children: [
              _SecuritySwitch(
                icon: Icons.phonelink_lock_outlined,
                label: 'Autenticación de dos factores',
                subtitle: 'Requerir 2FA para administradores',
                value: true,
                onChanged: (v) {},
              ),
              const RowSep(),
              _SecuritySwitch(
                icon: Icons.history_outlined,
                label: 'Registro de actividad',
                subtitle: 'Guardar log de todas las acciones',
                value: true,
                onChanged: (v) {},
              ),
              const RowSep(),
              _SecuritySwitch(
                icon: Icons.mark_email_read_outlined,
                label: 'Verificación de email',
                subtitle: 'Requerir verificación para nuevos usuarios',
                value: true,
                onChanged: (v) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: S.md),
        ContentCard(
          child: Column(
            children: [
              _SettingRow(
                icon: Icons.manage_accounts_outlined,
                label: 'Roles y permisos',
                subtitle: 'Gestionar permisos por tipo de usuario',
                onTap: () {},
              ),
              const RowSep(),
              _SettingRow(
                icon: Icons.shield_outlined,
                label: 'Historial de seguridad',
                subtitle: 'Ver eventos de seguridad recientes',
                onTap: () {},
              ),
              const RowSep(),
              _SettingRow(
                icon: Icons.block_outlined,
                label: 'IPs bloqueadas',
                subtitle: '3 direcciones actualmente bloqueadas',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAllActivity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(R.sheet)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, S.sm),
                child: Row(
                  children: [
                    const Text(
                      'Actividad reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: C.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: C.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_activities.length} eventos',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: C.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 4,
                width: 36,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: C.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Divider(height: 1, color: C.divider),
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  padding: const EdgeInsets.all(S.md),
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => const RowSep(),
                  itemBuilder: (_, i) =>
                      _ActivityRow(item: _activities[i], showFull: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── ADD DIALOGS ───────────────────────────────────────────────────────────  // ?????? LOGOUT ────────────────────────────────────────────────────────────────

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Cerrar sesión',
        body:
            '¿Deseas cerrar la sesión de administrador? Deberás iniciar sesión nuevamente.',
        confirmLabel: 'Cerrar sesión',
        confirmColor: C.error,
        icon: Icons.logout_rounded,
        onConfirm: () {
          Navigator.pop(context);
          // Navigate to login
        },
      ),
    );
  }

  // ── SNACKBAR ──────────────────────────────────────────────────────────────

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.35,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: S.sm),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: C.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(S.md, 0, S.md, S.sm),
              child: Row(
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: C.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: C.textMuted, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: C.divider),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(S.md),
                children: [
                  _NotifItem(
                    title: 'Nuevo negocio registrado',
                    subtitle: 'Panadería Dulce Hogar',
                    time: 'Hace 15 min',
                    isRead: false,
                    icon: Icons.store_outlined,
                    color: C.success,
                  ),
                  _NotifItem(
                    title: 'Reporte resuelto',
                    subtitle: 'Problema con #ORD12345',
                    time: 'Hace 2 h',
                    isRead: true,
                    icon: Icons.check_circle_outline_rounded,
                    color: C.primary,
                  ),
                  _NotifItem(
                    title: 'Actualización del sistema',
                    subtitle: 'Nueva versión disponible',
                    time: 'Hace 5 h',
                    isRead: true,
                    icon: Icons.system_update_alt_outlined,
                    color: C.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(R.card),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: C.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: C.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: S.md),
            const Text(
              'Administrador Principal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: C.primary,
              ),
            ),
            const Text(
              'admin@manda2.com',
              style: TextStyle(fontSize: 13, color: C.textMuted),
            ),
            const SizedBox(height: S.md),
            const Divider(color: C.divider),
            _SettingRow(
              icon: Icons.lock_outline_rounded,
              label: 'Cambiar contraseña',
              subtitle: '',
              onTap: () => Navigator.pop(context),
            ),
            _SettingRow(
              icon: Icons.tune_rounded,
              label: 'Preferencias',
              subtitle: '',
              onTap: () => Navigator.pop(context),
            ),
            _SettingRow(
              icon: Icons.logout_rounded,
              label: 'Cerrar sesión',
              subtitle: '',
              onTap: () {
                Navigator.pop(context);
                _confirmLogout(context);
              },
              isDanger: true,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: C.textMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBCOMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _TopBarAction extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;
  const _TopBarAction({required this.icon, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: C.bg,
              borderRadius: BorderRadius.circular(R.badge),
            ),
            child: Icon(icon, size: 18, color: C.textSec),
          ),
          if (badge != null)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: C.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _SidebarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? C.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: C.primary.withOpacity(0.18), width: 0.8)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 18,
              color: isSelected ? C.primary : C.textMuted,
            ),
            const SizedBox(width: S.sm),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? C.primary : C.textSec,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: C.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final AppStat stat;
  const _StatCard({required this.stat});

  Color get _bgColor {
    if (stat.color == C.primary) return C.primarySoft;
    if (stat.color == C.accent) return C.accentSoft;
    if (stat.color == C.success) return C.successBg;
    if (stat.color == C.purple) return C.purpleBg;
    return C.bg;
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = stat.change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.divider.withOpacity(0.9), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(R.badge),
                ),
                child: Icon(stat.icon, color: stat.color, size: 17),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? C.successBg : C.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stat.change,
                  style: TextStyle(
                    color: isPositive ? C.success : C.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: stat.color,
                  letterSpacing: -0.4,
                ),
              ),
              Text(
                stat.title,
                style: const TextStyle(
                  fontSize: 11,
                  color: C.textMuted,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;
  final bool showFull;
  const _ActivityRow({required this.item, this.showFull = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: item.color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: C.textSec,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: C.textMuted,
                  height: 1.3,
                ),
                maxLines: showFull ? null : 1,
                overflow: showFull
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: S.sm),
        Text(
          item.time,
          style: const TextStyle(fontSize: 11, color: C.textMuted),
        ),
      ],
    );
  }
}

class _MiniStatRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: C.textSec),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingActionRow extends StatelessWidget {
  final String label, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _PendingActionRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: C.primarySoft,
              borderRadius: BorderRadius.circular(R.badge),
            ),
            child: Icon(icon, size: 16, color: C.primary),
          ),
          const SizedBox(width: S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: C.textSec,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: C.textMuted),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: C.textMuted,
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(R.card),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: S.sm),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Delivery list tile ─────────────────────────────────────────────────────
//// ?????? Status badges ──────────────────────────────────────────────────────────
// ── Setting row ────────────────────────────────────────────────────────────
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;
  final bool isDanger;
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? C.error : C.primary;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDanger ? C.error.withOpacity(0.08) : C.primarySoft,
              borderRadius: BorderRadius.circular(R.badge),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDanger ? C.error : C.textSec,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: C.textMuted),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: isDanger ? C.error.withOpacity(0.5) : C.textMuted,
          ),
        ],
      ),
    );
  }
}

// ── Security switch ────────────────────────────────────────────────────────
class _SecuritySwitch extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SecuritySwitch({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: value ? C.primarySoft : C.divider.withOpacity(0.5),
            borderRadius: BorderRadius.circular(R.badge),
          ),
          child: Icon(icon, size: 16, color: value ? C.primary : C.textMuted),
        ),
        const SizedBox(width: S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: C.textSec,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: C.textMuted),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: C.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

// ── Report row ─────────────────────────────────────────────────────────────
class _NotifItem extends StatelessWidget {
  final String title, subtitle, time;
  final bool isRead;
  final IconData icon;
  final Color color;
  const _NotifItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: S.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
                    color: C.textSec,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: C.textMuted),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: C.textMuted),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: C.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
