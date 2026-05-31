import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const primary = Color(0xFF05386B);
  static const accent = Color(0xFFFF6B00);
  static const bg = Color(0xFFF9FAFB);
  static const surface = Colors.white;
  static const textSec = Color(0xFF2C3E50);
  static const textMuted = Color(0xFF7F8C8D);
  static const divider = Color(0xFFECF0F1);
  static const error = Color(0xFFE74C3C);
  static const success = Color(0xFF27AE60);
  static const successBg = Color(0xFFEAF6EE);
  static const warning = Color(0xFFF39C12);
  static const purple = Color(0xFF6B5BEF);
  static const purpleBg = Color(0xFFF0EFFE);
  static const primarySoft = Color(0xFFE8EFF7);
  static const accentSoft = Color(0xFFFFF3EC);
}

class _R {
  static const card = 16.0;
  static const input = 12.0;
  static const button = 12.0;
  static const badge = 8.0;
  static const sheet = 24.0;
}

class _S {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS & MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum UserType { business, customer, delivery, admin }

enum UserStatus { active, idle, inactive, blocked }

enum BusinessStatus { active, pending, suspended, inactive }

enum DeliveryStatus { active, offline, onDelivery, unavailable }

class ActiveUser {
  final String id, name, email, phone;
  final UserType type;
  final DateTime lastActive;
  final UserStatus status;
  final int ordersCount;
  final double totalSpent;
  ActiveUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.lastActive,
    required this.status,
    this.ordersCount = 0,
    this.totalSpent = 0,
  });
}

class Business {
  final String id, name, email, phone, category;
  final BusinessStatus status;
  final DateTime registrationDate;
  final double totalSales;
  final int totalOrders;
  final double rating;
  Business({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.category,
    required this.status,
    required this.registrationDate,
    required this.totalSales,
    this.totalOrders = 0,
    this.rating = 4.5,
  });
}

class DeliveryPerson {
  final String id, name, email, phone, vehicle;
  final DeliveryStatus status;
  final double rating;
  final int totalDeliveries;
  final double totalEarnings;
  DeliveryPerson({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicle,
    required this.status,
    required this.rating,
    required this.totalDeliveries,
    this.totalEarnings = 0,
  });
}

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
  _NavItem(
    icon: Icons.delivery_dining_outlined,
    activeIcon: Icons.delivery_dining_rounded,
    label: 'Repartidores',
    index: 3,
  ),
  _NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: 'Reportes',
    index: 5,
  ),
  _NavItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    label: 'Config.',
    index: 4,
  ),
  _NavItem(
    icon: Icons.security_outlined,
    activeIcon: Icons.security_rounded,
    label: 'Seguridad',
    index: 6,
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
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  int _selectedIndex = 0;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  // ── DATA ──────────────────────────────────────────────────────────────────

  final _activities = [
    ActivityItem(
      title: 'Nuevo negocio registrado',
      subtitle: 'Panadería Dulce Hogar se unió a la plataforma',
      time: 'Hace 15 min',
      icon: Icons.storefront_outlined,
      color: _C.success,
      type: ActivityType.newBusiness,
    ),
    ActivityItem(
      title: 'Reporte de problema',
      subtitle: 'Usuario reportó problema con pedido #ORD12345',
      time: 'Hace 30 min',
      icon: Icons.warning_amber_outlined,
      color: _C.warning,
      type: ActivityType.report,
    ),
    ActivityItem(
      title: 'Nuevo usuario registrado',
      subtitle: 'Ana García creó su cuenta de cliente',
      time: 'Hace 1 h',
      icon: Icons.person_add_outlined,
      color: _C.primary,
      type: ActivityType.newUser,
    ),
    ActivityItem(
      title: 'Liquidación procesada',
      subtitle: 'Liquidación #LIQ789 completada — L 12,500',
      time: 'Hace 2 h',
      icon: Icons.payments_outlined,
      color: _C.purple,
      type: ActivityType.payment,
    ),
    ActivityItem(
      title: 'Intento bloqueado',
      subtitle: 'Acceso sospechoso desde IP 192.168.1.100',
      time: 'Hace 5 h',
      icon: Icons.gpp_bad_outlined,
      color: _C.error,
      type: ActivityType.security,
    ),
    ActivityItem(
      title: 'Pedido completado',
      subtitle: 'Pedido #ORD98765 entregado exitosamente',
      time: 'Hace 6 h',
      icon: Icons.check_circle_outlined,
      color: _C.success,
      type: ActivityType.order,
    ),
  ];

  final _activeUsers = [
    ActiveUser(
      id: 'USR001',
      name: 'Juan Pérez',
      email: 'juan@negocio.com',
      phone: '+504 1234-5678',
      type: UserType.business,
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      status: UserStatus.active,
      ordersCount: 145,
      totalSpent: 12500,
    ),
    ActiveUser(
      id: 'USR002',
      name: 'María García',
      email: 'maria@cliente.com',
      phone: '+504 2345-6789',
      type: UserType.customer,
      lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      status: UserStatus.active,
      ordersCount: 28,
      totalSpent: 890,
    ),
    ActiveUser(
      id: 'DLV001',
      name: 'Carlos Rodríguez',
      email: 'carlos@repartidor.com',
      phone: '+504 3456-7890',
      type: UserType.delivery,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      status: UserStatus.active,
      ordersCount: 312,
      totalSpent: 0,
    ),
    ActiveUser(
      id: 'USR003',
      name: 'Ana Martínez',
      email: 'ana@negocio.com',
      phone: '+504 4567-8901',
      type: UserType.business,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      status: UserStatus.idle,
      ordersCount: 67,
      totalSpent: 5400,
    ),
    ActiveUser(
      id: 'USR004',
      name: 'Pedro López',
      email: 'pedro@cliente.com',
      phone: '+504 5678-9012',
      type: UserType.customer,
      lastActive: DateTime.now().subtract(const Duration(hours: 5)),
      status: UserStatus.inactive,
      ordersCount: 12,
      totalSpent: 320,
    ),
    ActiveUser(
      id: 'USR005',
      name: 'Luis Torres',
      email: 'luis@cliente.com',
      phone: '+504 6789-0123',
      type: UserType.customer,
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
      status: UserStatus.blocked,
      ordersCount: 3,
      totalSpent: 80,
    ),
  ];

  final _businesses = [
    Business(
      id: 'BUS001',
      name: 'Restaurante La Esquina',
      email: 'contacto@laesquina.com',
      phone: '+504 1111-2222',
      category: 'Restaurante',
      status: BusinessStatus.active,
      registrationDate: DateTime.now().subtract(const Duration(days: 30)),
      totalSales: 125000,
      totalOrders: 890,
      rating: 4.8,
    ),
    Business(
      id: 'BUS002',
      name: 'Cafetería Central',
      email: 'info@cafeteria.com',
      phone: '+504 2222-3333',
      category: 'Cafetería',
      status: BusinessStatus.pending,
      registrationDate: DateTime.now().subtract(const Duration(days: 15)),
      totalSales: 45000,
      totalOrders: 320,
      rating: 4.2,
    ),
    Business(
      id: 'BUS003',
      name: 'Pizzería Italiana',
      email: 'italiana@pizza.com',
      phone: '+504 3333-4444',
      category: 'Pizzería',
      status: BusinessStatus.suspended,
      registrationDate: DateTime.now().subtract(const Duration(days: 45)),
      totalSales: 89000,
      totalOrders: 640,
      rating: 3.9,
    ),
    Business(
      id: 'BUS004',
      name: 'Farmacia El Alivio',
      email: 'alivio@farmacia.com',
      phone: '+504 4444-5555',
      category: 'Farmacia',
      status: BusinessStatus.active,
      registrationDate: DateTime.now().subtract(const Duration(days: 90)),
      totalSales: 67000,
      totalOrders: 1200,
      rating: 4.6,
    ),
  ];

  final _deliveryPersons = [
    DeliveryPerson(
      id: 'DLV001',
      name: 'Carlos Rodríguez',
      email: 'carlos@repartidor.com',
      phone: '+504 1234-5678',
      vehicle: 'Moto Honda CB190',
      status: DeliveryStatus.active,
      rating: 4.8,
      totalDeliveries: 156,
      totalEarnings: 4800,
    ),
    DeliveryPerson(
      id: 'DLV002',
      name: 'Luis Fernández',
      email: 'luis@repartidor.com',
      phone: '+504 2345-6789',
      vehicle: 'Moto Yamaha YBR125',
      status: DeliveryStatus.offline,
      rating: 4.5,
      totalDeliveries: 89,
      totalEarnings: 2700,
    ),
    DeliveryPerson(
      id: 'DLV003',
      name: 'Pedro Sánchez',
      email: 'pedro@repartidor.com',
      phone: '+504 3456-7890',
      vehicle: 'Moto Suzuki GN125',
      status: DeliveryStatus.onDelivery,
      rating: 4.9,
      totalDeliveries: 210,
      totalEarnings: 6300,
    ),
    DeliveryPerson(
      id: 'DLV004',
      name: 'Miguel Ángel',
      email: 'miguel@repartidor.com',
      phone: '+504 4567-8901',
      vehicle: 'Bicicleta',
      status: DeliveryStatus.unavailable,
      rating: 4.1,
      totalDeliveries: 45,
      totalEarnings: 1350,
    ),
  ];

  final _appStats = [
    AppStat(
      title: 'Usuarios activos',
      value: '1,245',
      change: '+12%',
      icon: Icons.people_outlined,
      color: _C.primary,
    ),
    AppStat(
      title: 'Pedidos hoy',
      value: '356',
      change: '+8%',
      icon: Icons.shopping_cart_outlined,
      color: _C.accent,
    ),
    AppStat(
      title: 'Negocios activos',
      value: '89',
      change: '+5%',
      icon: Icons.store_outlined,
      color: _C.success,
    ),
    AppStat(
      title: 'Repartidores',
      value: '45',
      change: '+15%',
      icon: Icons.delivery_dining_outlined,
      color: _C.purple,
    ),
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<ActiveUser> get _filteredUsers => _searchQuery.isEmpty
      ? _activeUsers
      : _activeUsers
            .where(
              (u) =>
                  u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  u.email.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

  List<Business> get _filteredBusinesses => _searchQuery.isEmpty
      ? _businesses
      : _businesses
            .where(
              (b) =>
                  b.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  b.email.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

  List<DeliveryPerson> get _filteredDelivery => _searchQuery.isEmpty
      ? _deliveryPersons
      : _deliveryPersons
            .where(
              (d) =>
                  d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  d.phone.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} días';
  }

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
      backgroundColor: _C.bg,
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
                      horizontal: isWide ? _S.lg : _S.md,
                      vertical: _S.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(),
                        const SizedBox(height: _S.md),
                        _buildQuickStats(isWide),
                        const SizedBox(height: _S.md),
                        _buildSelectedContent(isWide),
                        const SizedBox(height: _S.xl),
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
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isWide ? _S.lg : _S.md),
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(bottom: BorderSide(color: _C.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          if (!isWide) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _C.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: _S.sm),
          ],
          Expanded(
            child: Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 13, color: _C.textMuted),
            ),
          ),
          _TopBarAction(
            icon: Icons.notifications_outlined,
            badge: '3',
            onTap: () => _showNotifications(context),
          ),
          const SizedBox(width: _S.sm),
          GestureDetector(
            onTap: () => _showAdminProfile(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: _C.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _C.primary,
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
      padding: const EdgeInsets.fromLTRB(_S.md, _S.sm, _S.md, 0),
      color: _C.surface,
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontSize: 14, color: _C.textSec),
        decoration: InputDecoration(
          hintText: hints[_selectedIndex] ?? 'Buscar...',
          hintStyle: const TextStyle(color: _C.textMuted, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _C.primary,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: _C.textMuted,
                  ),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: _C.bg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_R.input),
            borderSide: const BorderSide(color: _C.divider, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_R.input),
            borderSide: const BorderSide(color: _C.divider, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_R.input),
            borderSide: const BorderSide(color: _C.primary, width: 1.5),
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
        color: _C.surface,
        border: Border(right: BorderSide(color: _C.divider, width: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: _S.md),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _C.divider, width: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _C.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: _S.sm),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manda2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _C.primary,
                      ),
                    ),
                    Text(
                      'Panel Admin',
                      style: TextStyle(fontSize: 11, color: _C.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _S.sm,
                vertical: _S.sm,
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
                      horizontal: _S.sm,
                      vertical: _S.sm,
                    ),
                    child: Divider(height: 1, color: _C.divider),
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
            padding: const EdgeInsets.all(_S.md),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddUserDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text(
                      'Nuevo usuario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.button),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _S.sm),
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
                    style: TextButton.styleFrom(foregroundColor: _C.error),
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
    final mobileItems = _navItems.take(5).toList();
    final currentIdx = mobileItems.indexWhere((i) => i.index == _selectedIndex);
    final safeIdx = currentIdx < 0 ? 0 : currentIdx;

    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(top: BorderSide(color: _C.divider, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: mobileItems.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = safeIdx == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedIndex = item.index;
                    _searchQuery = '';
                    _searchCtrl.clear();
                  }),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: isActive ? _C.accent : _C.textMuted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive ? _C.accent : _C.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── SECTION HEADER ────────────────────────────────────────────────────────

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getSectionTitle(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _C.primary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getSubtitle(),
                style: const TextStyle(fontSize: 13, color: _C.textMuted),
              ),
            ],
          ),
        ),
        if (_selectedIndex == 1)
          _ActionButton(
            label: 'Agregar',
            icon: Icons.person_add_outlined,
            onTap: () => _showAddUserDialog(context),
          ),
        if (_selectedIndex == 2)
          _ActionButton(
            label: 'Agregar',
            icon: Icons.add_business_outlined,
            onTap: () => _showAddBusinessDialog(context),
          ),
        if (_selectedIndex == 3)
          _ActionButton(
            label: 'Agregar',
            icon: Icons.person_add_outlined,
            onTap: () => _showAddDeliveryDialog(context),
          ),
      ],
    );
  }

  String _getSectionTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Usuarios';
      case 2:
        return 'Negocios';
      case 3:
        return 'Repartidores';
      case 4:
        return 'Configuración';
      case 5:
        return 'Reportes';
      case 6:
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
        return '${_filteredUsers.length} usuario${_filteredUsers.length != 1 ? 's' : ''}';
      case 2:
        return '${_filteredBusinesses.length} negocio${_filteredBusinesses.length != 1 ? 's' : ''}';
      case 3:
        return '${_filteredDelivery.length} repartidor${_filteredDelivery.length != 1 ? 'es' : ''}';
      case 4:
        return 'Configuración de la plataforma';
      case 5:
        return 'Reportes y análisis de datos';
      case 6:
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
        crossAxisSpacing: _S.sm,
        mainAxisSpacing: _S.sm,
        childAspectRatio: isWide ? 1.6 : 1.4,
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
        return _buildUsers(isWide);
      case 2:
        return _buildBusinesses(isWide);
      case 3:
        return _buildDelivery(isWide);
      case 4:
        return _buildSettings();
      case 5:
        return _buildReports();
      case 6:
        return _buildSecurity();
      default:
        return _buildDashboard(isWide);
    }
  }

  // ── DASHBOARD ─────────────────────────────────────────────────────────────

  Widget _buildDashboard(bool isWide) {
    return Column(
      children: [
        _ContentCard(
          header: _CardHeader(
            title: 'Actividad reciente',
            action: TextButton(
              onPressed: () => _showAllActivity(context),
              style: TextButton.styleFrom(
                foregroundColor: _C.accent,
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
                  if (!isLast) const _RowSep(),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: _S.md),
        if (isWide)
          Row(
            children: [
              Expanded(child: _buildMiniStats()),
              const SizedBox(width: _S.sm),
              Expanded(child: _buildPendingActions()),
            ],
          )
        else ...[
          _buildMiniStats(),
          const SizedBox(height: _S.sm),
          _buildPendingActions(),
        ],
        const SizedBox(height: _S.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'Agregar negocio',
                icon: Icons.store_outlined,
                color: _C.primary,
                onTap: () => _showAddBusinessDialog(context),
              ),
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: _QuickActionButton(
                label: 'Agregar repartidor',
                icon: Icons.delivery_dining_outlined,
                color: _C.accent,
                onTap: () => _showAddDeliveryDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStats() {
    return _ContentCard(
      header: const _CardHeader(title: 'Estado del sistema'),
      child: Column(
        children: [
          _MiniStatRow(
            label: 'Usuarios bloqueados',
            value: '3',
            color: _C.error,
          ),
          const _RowSep(),
          _MiniStatRow(
            label: 'Negocios pendientes',
            value: '1',
            color: _C.warning,
          ),
          const _RowSep(),
          _MiniStatRow(
            label: 'Reportes sin resolver',
            value: '2',
            color: _C.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActions() {
    return _ContentCard(
      header: const _CardHeader(title: 'Acciones pendientes'),
      child: Column(
        children: [
          _PendingActionRow(
            label: 'Aprobar negocio',
            subtitle: 'Cafetería Central esperando',
            icon: Icons.store_outlined,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          const _RowSep(),
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

  // ── USERS ─────────────────────────────────────────────────────────────────

  Widget _buildUsers(bool isWide) {
    final users = _filteredUsers;
    if (users.isEmpty)
      return _buildEmptyState(
        'No se encontraron usuarios',
        Icons.people_outlined,
      );

    return _ContentCard(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (_, __) => const _RowSep(),
        itemBuilder: (_, i) => _UserListTile(
          user: users[i],
          timeAgo: _getTimeAgo(users[i].lastActive),
          onView: () => _showUserDetails(context, users[i]),
          onEdit: () => _showEditUser(context, users[i]),
          onBlock: () => _confirmBlockUser(context, users[i]),
        ),
      ),
    );
  }

  // ── BUSINESSES ────────────────────────────────────────────────────────────

  Widget _buildBusinesses(bool isWide) {
    final businesses = _filteredBusinesses;
    if (businesses.isEmpty)
      return _buildEmptyState(
        'No se encontraron negocios',
        Icons.store_outlined,
      );

    return _ContentCard(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: businesses.length,
        separatorBuilder: (_, __) => const _RowSep(),
        itemBuilder: (_, i) => _BusinessListTile(
          business: businesses[i],
          dateFormat: _dateFormat,
          onView: () => _showBusinessDetails(context, businesses[i]),
          onEdit: () => _showEditBusiness(context, businesses[i]),
          onToggleStatus: () => _toggleBusinessStatus(context, businesses[i]),
          onContact: () =>
              _showSuccess('Correo enviado a ${businesses[i].name}'),
        ),
      ),
    );
  }

  // ── DELIVERY ──────────────────────────────────────────────────────────────

  Widget _buildDelivery(bool isWide) {
    final delivery = _filteredDelivery;
    if (delivery.isEmpty)
      return _buildEmptyState(
        'No se encontraron repartidores',
        Icons.delivery_dining_outlined,
      );

    return _ContentCard(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: delivery.length,
        separatorBuilder: (_, __) => const _RowSep(),
        itemBuilder: (_, i) => _DeliveryListTile(
          delivery: delivery[i],
          onView: () => _showDeliveryDetails(context, delivery[i]),
          onEdit: () => _showEditDelivery(context, delivery[i]),
          onTrack: () => _showSuccess('Rastreando a ${delivery[i].name}'),
          onBlock: () => _confirmBlockDelivery(context, delivery[i]),
        ),
      ),
    );
  }

  // ── SETTINGS ──────────────────────────────────────────────────────────────

  Widget _buildSettings() {
    return _ContentCard(
      child: Column(
        children: [
          _SettingRow(
            icon: Icons.percent_outlined,
            label: 'Comisiones',
            subtitle: 'Porcentajes por tipo de negocio',
            onTap: () {},
          ),
          const _RowSep(),
          _SettingRow(
            icon: Icons.credit_card_outlined,
            label: 'Métodos de pago',
            subtitle: 'Gestionar métodos aceptados',
            onTap: () {},
          ),
          const _RowSep(),
          _SettingRow(
            icon: Icons.notifications_outlined,
            label: 'Notificaciones',
            subtitle: 'Sistema push y email',
            onTap: () {},
          ),
          const _RowSep(),
          _SettingRow(
            icon: Icons.map_outlined,
            label: 'Regiones y zonas',
            subtitle: 'Zonas de cobertura del servicio',
            onTap: () {},
          ),
          const _RowSep(),
          _SettingRow(
            icon: Icons.backup_outlined,
            label: 'Backup y restauración',
            subtitle: 'Copias de seguridad',
            onTap: () {},
          ),
          const _RowSep(),
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

  Widget _buildReports() {
    return Column(
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _ReportSummaryCard(
                title: 'Ingresos totales',
                value: 'L 1.2M',
                change: '+18%',
                icon: Icons.trending_up_outlined,
                color: _C.success,
              ),
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: _ReportSummaryCard(
                title: 'Pedidos este mes',
                value: '4,891',
                change: '+11%',
                icon: Icons.shopping_bag_outlined,
                color: _C.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: _S.sm),
        Row(
          children: [
            Expanded(
              child: _ReportSummaryCard(
                title: 'Comisiones cobradas',
                value: 'L 120K',
                change: '+9%',
                icon: Icons.percent_outlined,
                color: _C.accent,
              ),
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: _ReportSummaryCard(
                title: 'Nuevos usuarios',
                value: '234',
                change: '+22%',
                icon: Icons.person_add_outlined,
                color: _C.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: _S.md),
        // Report buttons
        _ContentCard(
          header: const _CardHeader(title: 'Generar reportes'),
          child: Column(
            children: [
              _ReportRow(
                icon: Icons.trending_up_outlined,
                label: 'Reporte de ventas',
                subtitle: 'Ventas por período, negocio y categoría',
                color: _C.success,
                onTap: () => _showReportOptions(context, 'Ventas'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.people_outlined,
                label: 'Reporte de usuarios',
                subtitle: 'Registro, actividad y segmentación',
                color: _C.primary,
                onTap: () => _showReportOptions(context, 'Usuarios'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.store_outlined,
                label: 'Reporte de negocios',
                subtitle: 'Desempeño, ratings y cumplimiento',
                color: _C.accent,
                onTap: () => _showReportOptions(context, 'Negocios'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.delivery_dining_outlined,
                label: 'Reporte de repartidores',
                subtitle: 'Entregas, tiempo y calificaciones',
                color: _C.purple,
                onTap: () => _showReportOptions(context, 'Repartidores'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.account_balance_outlined,
                label: 'Reporte financiero',
                subtitle: 'Flujo de caja, comisiones y liquidaciones',
                color: const Color(0xFF00A86B),
                onTap: () => _showReportOptions(context, 'Financiero'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.bar_chart_outlined,
                label: 'Reporte de pedidos',
                subtitle: 'Pedidos por estado, hora y zona',
                color: _C.warning,
                onTap: () => _showReportOptions(context, 'Pedidos'),
              ),
              const _RowSep(),
              _ReportRow(
                icon: Icons.star_outlined,
                label: 'Reporte de calificaciones',
                subtitle: 'Satisfacción de clientes por negocio',
                color: const Color(0xFFF1C40F),
                onTap: () => _showReportOptions(context, 'Calificaciones'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECURITY ──────────────────────────────────────────────────────────────

  Widget _buildSecurity() {
    return Column(
      children: [
        _ContentCard(
          header: const _CardHeader(title: 'Configuración de seguridad'),
          child: Column(
            children: [
              _SecuritySwitch(
                icon: Icons.phonelink_lock_outlined,
                label: 'Autenticación de dos factores',
                subtitle: 'Requerir 2FA para administradores',
                value: true,
                onChanged: (v) {},
              ),
              const _RowSep(),
              _SecuritySwitch(
                icon: Icons.history_outlined,
                label: 'Registro de actividad',
                subtitle: 'Guardar log de todas las acciones',
                value: true,
                onChanged: (v) {},
              ),
              const _RowSep(),
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
        const SizedBox(height: _S.md),
        _ContentCard(
          child: Column(
            children: [
              _SettingRow(
                icon: Icons.manage_accounts_outlined,
                label: 'Roles y permisos',
                subtitle: 'Gestionar permisos por tipo de usuario',
                onTap: () {},
              ),
              const _RowSep(),
              _SettingRow(
                icon: Icons.shield_outlined,
                label: 'Historial de seguridad',
                subtitle: 'Ver eventos de seguridad recientes',
                onTap: () {},
              ),
              const _RowSep(),
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

  // ── EMPTY STATE ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _C.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 40, color: _C.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _C.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(fontSize: 13, color: _C.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ── DETAIL SHEETS ──────────────────────────────────────────────────────────

  void _showUserDetails(BuildContext context, ActiveUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _UserDetailSheet(
        user: user,
        onEdit: () {
          Navigator.pop(context);
          _showEditUser(context, user);
        },
        onBlock: () {
          Navigator.pop(context);
          _confirmBlockUser(context, user);
        },
      ),
    );
  }

  void _showEditUser(BuildContext context, ActiveUser user) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Editar usuario',
        subtitle: user.name,
        icon: Icons.edit_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Usuario actualizado');
        },
        fields: [
          _DialogField(
            label: 'Nombre completo',
            icon: Icons.person_outline,
            initialValue: user.name,
          ),
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: user.email,
          ),
          _DialogField(
            label: 'Teléfono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            initialValue: user.phone,
          ),
        ],
      ),
    );
  }

  void _confirmBlockUser(BuildContext context, ActiveUser user) {
    final isBlocked = user.status == UserStatus.blocked;
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: isBlocked ? 'Desbloquear usuario' : 'Bloquear usuario',
        body: isBlocked
            ? '¿Deseas desbloquear a ${user.name}? Podrá acceder nuevamente a la plataforma.'
            : '¿Deseas bloquear a ${user.name}? No podrá acceder a la plataforma.',
        confirmLabel: isBlocked ? 'Desbloquear' : 'Bloquear',
        confirmColor: isBlocked ? _C.success : _C.error,
        onConfirm: () {
          Navigator.pop(context);
          _showSuccess(
            isBlocked ? '${user.name} desbloqueado' : '${user.name} bloqueado',
          );
        },
      ),
    );
  }

  void _showBusinessDetails(BuildContext context, Business business) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BusinessDetailSheet(
        business: business,
        dateFormat: _dateFormat,
        onEdit: () {
          Navigator.pop(context);
          _showEditBusiness(context, business);
        },
        onToggle: () {
          Navigator.pop(context);
          _toggleBusinessStatus(context, business);
        },
        onContact: () {
          Navigator.pop(context);
          _showSuccess('Correo enviado a ${business.name}');
        },
      ),
    );
  }

  void _showEditBusiness(BuildContext context, Business business) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Editar negocio',
        subtitle: business.name,
        icon: Icons.store_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Negocio actualizado');
        },
        fields: [
          _DialogField(
            label: 'Nombre del negocio',
            icon: Icons.store_outlined,
            initialValue: business.name,
          ),
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: business.email,
          ),
          _DialogField(
            label: 'Teléfono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            initialValue: business.phone,
          ),
        ],
      ),
    );
  }

  void _toggleBusinessStatus(BuildContext context, Business business) {
    final isSuspended = business.status == BusinessStatus.suspended;
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: isSuspended ? 'Activar negocio' : 'Suspender negocio',
        body: isSuspended
            ? '¿Deseas reactivar "${business.name}"?'
            : '¿Deseas suspender "${business.name}"? No podrá recibir pedidos.',
        confirmLabel: isSuspended ? 'Activar' : 'Suspender',
        confirmColor: isSuspended ? _C.success : _C.error,
        onConfirm: () {
          Navigator.pop(context);
          _showSuccess(
            isSuspended
                ? '${business.name} activado'
                : '${business.name} suspendido',
          );
        },
      ),
    );
  }

  void _showDeliveryDetails(BuildContext context, DeliveryPerson delivery) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DeliveryDetailSheet(
        delivery: delivery,
        onEdit: () {
          Navigator.pop(context);
          _showEditDelivery(context, delivery);
        },
        onBlock: () {
          Navigator.pop(context);
          _confirmBlockDelivery(context, delivery);
        },
      ),
    );
  }

  void _showEditDelivery(BuildContext context, DeliveryPerson delivery) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Editar repartidor',
        subtitle: delivery.name,
        icon: Icons.delivery_dining_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Repartidor actualizado');
        },
        fields: [
          _DialogField(
            label: 'Nombre completo',
            icon: Icons.badge_outlined,
            initialValue: delivery.name,
          ),
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: delivery.email,
          ),
          _DialogField(
            label: 'Teléfono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            initialValue: delivery.phone,
          ),
          _DialogField(
            label: 'Vehículo',
            icon: Icons.two_wheeler_outlined,
            initialValue: delivery.vehicle,
          ),
        ],
      ),
    );
  }

  void _confirmBlockDelivery(BuildContext context, DeliveryPerson delivery) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Desactivar repartidor',
        body:
            '¿Deseas desactivar a ${delivery.name}? No podrá recibir pedidos.',
        confirmLabel: 'Desactivar',
        confirmColor: _C.error,
        onConfirm: () {
          Navigator.pop(context);
          _showSuccess('${delivery.name} desactivado');
        },
      ),
    );
  }

  // ── REPORT OPTIONS ────────────────────────────────────────────────────────

  void _showReportOptions(BuildContext context, String reportType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReportOptionsSheet(
        reportType: reportType,
        onGenerate: (period) {
          Navigator.pop(context);
          _showSuccess('Reporte de $reportType ($period) generado');
        },
      ),
    );
  }

  // ── ALL ACTIVITY ──────────────────────────────────────────────────────────

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
            color: _C.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(_S.md, _S.md, _S.md, _S.sm),
                child: Row(
                  children: [
                    const Text(
                      'Actividad reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _C.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _C.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_activities.length} eventos',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _C.primary,
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
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Divider(height: 1, color: _C.divider),
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  padding: const EdgeInsets.all(_S.md),
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => const _RowSep(),
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

  // ── ADD DIALOGS ───────────────────────────────────────────────────────────

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Nuevo usuario',
        subtitle: 'Se enviará un correo con credenciales temporales',
        icon: Icons.person_add_outlined,
        actionLabel: 'Enviar invitación',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Invitación enviada');
        },
        fields: const [
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
        dropdown: _DialogDropdown(
          label: 'Tipo de usuario',
          items: ['Negocio', 'Repartidor', 'Administrador'],
        ),
      ),
    );
  }

  void _showAddBusinessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Nuevo negocio',
        subtitle: 'El negocio recibirá un correo de bienvenida',
        icon: Icons.add_business_outlined,
        actionLabel: 'Agregar negocio',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Negocio agregado exitosamente');
        },
        fields: const [
          _DialogField(label: 'Nombre del negocio', icon: Icons.store_outlined),
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          _DialogField(
            label: 'Teléfono de contacto',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  void _showAddDeliveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AdminDialog(
        title: 'Nuevo repartidor',
        subtitle: 'Recibirá correo para activar su cuenta',
        icon: Icons.delivery_dining_outlined,
        actionLabel: 'Agregar repartidor',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Repartidor agregado exitosamente');
        },
        fields: const [
          _DialogField(label: 'Nombre completo', icon: Icons.badge_outlined),
          _DialogField(
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          _DialogField(
            label: 'Teléfono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // ── LOGOUT ────────────────────────────────────────────────────────────────

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Cerrar sesión',
        body:
            '¿Deseas cerrar la sesión de administrador? Deberás iniciar sesión nuevamente.',
        confirmLabel: 'Cerrar sesión',
        confirmColor: _C.error,
        icon: Icons.logout_rounded,
        onConfirm: () {
          Navigator.pop(context);
          // Navigate to login
        },
      ),
    );
  }

  // ── SNACKBAR ──────────────────────────────────────────────────────────────

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: _S.sm),
            Text(msg),
          ],
        ),
        backgroundColor: _C.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_R.badge),
        ),
        margin: const EdgeInsets.all(_S.md),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.surface,
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
              margin: const EdgeInsets.only(top: 12, bottom: _S.sm),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _C.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(_S.md, 0, _S.md, _S.sm),
              child: Row(
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _C.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: _C.textMuted, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _C.divider),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(_S.md),
                children: [
                  _NotifItem(
                    title: 'Nuevo negocio registrado',
                    subtitle: 'Panadería Dulce Hogar',
                    time: 'Hace 15 min',
                    isRead: false,
                    icon: Icons.store_outlined,
                    color: _C.success,
                  ),
                  _NotifItem(
                    title: 'Reporte resuelto',
                    subtitle: 'Problema con #ORD12345',
                    time: 'Hace 2 h',
                    isRead: true,
                    icon: Icons.check_circle_outline_rounded,
                    color: _C.primary,
                  ),
                  _NotifItem(
                    title: 'Actualización del sistema',
                    subtitle: 'Nueva versión disponible',
                    time: 'Hace 5 h',
                    isRead: true,
                    icon: Icons.system_update_alt_outlined,
                    color: _C.purple,
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
          borderRadius: BorderRadius.circular(_R.card),
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
                color: _C.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _C.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: _S.md),
            const Text(
              'Administrador Principal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _C.primary,
              ),
            ),
            const Text(
              'admin@manda2.com',
              style: TextStyle(fontSize: 13, color: _C.textMuted),
            ),
            const SizedBox(height: _S.md),
            const Divider(color: _C.divider),
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
              child: const Text(
                'Cerrar',
                style: TextStyle(color: _C.textMuted),
              ),
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
              color: _C.bg,
              borderRadius: BorderRadius.circular(_R.badge),
            ),
            child: Icon(icon, size: 18, color: _C.textSec),
          ),
          if (badge != null)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: _C.accent,
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
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: _S.sm, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _C.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(_R.badge),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 18,
              color: isSelected ? _C.primary : _C.textMuted,
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? _C.primary : _C.textSec,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _C.accent,
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
    if (stat.color == _C.primary) return _C.primarySoft;
    if (stat.color == _C.accent) return _C.accentSoft;
    if (stat.color == _C.success) return _C.successBg;
    if (stat.color == _C.purple) return _C.purpleBg;
    return _C.bg;
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = stat.change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(_R.badge),
                ),
                child: Icon(stat.icon, color: stat.color, size: 17),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? _C.successBg : _C.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stat.change,
                  style: TextStyle(
                    color: isPositive ? _C.success : _C.error,
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
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: stat.color,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                stat.title,
                style: const TextStyle(
                  fontSize: 11,
                  color: _C.textMuted,
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

class _ContentCard extends StatelessWidget {
  final Widget child;
  final _CardHeader? header;
  const _ContentCard({required this.child, this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(_S.md, _S.md, _S.md, 0),
              child: header!,
            ),
          Padding(
            padding: EdgeInsets.all(header != null ? _S.md : _S.md),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const _CardHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _C.textSec,
          ),
        ),
        const Spacer(),
        if (action != null) action!,
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: _S.sm),
        decoration: BoxDecoration(
          color: _C.accent,
          borderRadius: BorderRadius.circular(_R.button),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: _S.xs),
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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(_R.badge),
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
                  fontWeight: FontWeight.w700,
                  color: _C.textSec,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: _C.textMuted,
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
        const SizedBox(width: _S.sm),
        Text(
          item.time,
          style: const TextStyle(fontSize: 11, color: _C.textMuted),
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
            style: const TextStyle(fontSize: 13, color: _C.textSec),
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
              color: _C.primarySoft,
              borderRadius: BorderRadius.circular(_R.badge),
            ),
            child: Icon(icon, size: 16, color: _C.primary),
          ),
          const SizedBox(width: _S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.textSec,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: _C.textMuted,
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
          borderRadius: BorderRadius.circular(_R.card),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: _S.sm),
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

// ── User list tile ─────────────────────────────────────────────────────────

class _UserListTile extends StatelessWidget {
  final ActiveUser user;
  final String timeAgo;
  final VoidCallback onView, onEdit, onBlock;
  const _UserListTile({
    required this.user,
    required this.timeAgo,
    required this.onView,
    required this.onEdit,
    required this.onBlock,
  });

  Color _typeColor() {
    switch (user.type) {
      case UserType.business:
        return _C.primary;
      case UserType.customer:
        return _C.success;
      case UserType.delivery:
        return _C.purple;
      case UserType.admin:
        return _C.accent;
    }
  }

  IconData _typeIcon() {
    switch (user.type) {
      case UserType.business:
        return Icons.store_outlined;
      case UserType.customer:
        return Icons.person_outlined;
      case UserType.delivery:
        return Icons.delivery_dining_outlined;
      case UserType.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  String _typeLabel() {
    switch (user.type) {
      case UserType.business:
        return 'Negocio';
      case UserType.customer:
        return 'Cliente';
      case UserType.delivery:
        return 'Repartidor';
      case UserType.admin:
        return 'Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _typeColor().withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_typeIcon(), color: _typeColor(), size: 18),
        ),
        const SizedBox(width: _S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textSec,
                ),
              ),
              Row(
                children: [
                  Text(
                    _typeLabel(),
                    style: TextStyle(
                      fontSize: 11,
                      color: _typeColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    ' · ',
                    style: TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        _StatusBadge(status: user.status),
        const SizedBox(width: _S.xs),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: _C.textMuted,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_R.card),
          ),
          offset: const Offset(0, 8),
          itemBuilder: (_) => [
            _popItem(
              'view',
              Icons.visibility_outlined,
              'Ver detalles',
              _C.primary,
            ),
            _popItem('edit', Icons.edit_outlined, 'Editar', _C.accent),
            _popItem(
              'block',
              user.status == UserStatus.blocked
                  ? Icons.lock_open_outlined
                  : Icons.block_outlined,
              user.status == UserStatus.blocked ? 'Desbloquear' : 'Bloquear',
              _C.error,
            ),
          ],
          onSelected: (v) {
            if (v == 'view') onView();
            if (v == 'edit') onEdit();
            if (v == 'block') onBlock();
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _popItem(
    String value,
    IconData icon,
    String label,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: _S.sm),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

// ── Business list tile ─────────────────────────────────────────────────────

class _BusinessListTile extends StatelessWidget {
  final Business business;
  final DateFormat dateFormat;
  final VoidCallback onView, onEdit, onToggleStatus, onContact;
  const _BusinessListTile({
    required this.business,
    required this.dateFormat,
    required this.onView,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: _C.primarySoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.store_outlined, color: _C.primary, size: 18),
        ),
        const SizedBox(width: _S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textSec,
                ),
              ),
              Row(
                children: [
                  Text(
                    business.category,
                    style: const TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                  const Text(
                    ' · ',
                    style: TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                  Text(
                    'L ${NumberFormat('#,###').format(business.totalSales)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _C.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _BusinessStatusBadge(status: business.status),
        const SizedBox(width: _S.xs),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: _C.textMuted,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_R.card),
          ),
          offset: const Offset(0, 8),
          itemBuilder: (_) => [
            _popItem(
              'view',
              Icons.visibility_outlined,
              'Ver detalles',
              _C.primary,
            ),
            _popItem('edit', Icons.edit_outlined, 'Editar', _C.accent),
            _popItem('contact', Icons.email_outlined, 'Contactar', _C.success),
            _popItem(
              'toggle',
              business.status == BusinessStatus.suspended
                  ? Icons.check_circle_outlined
                  : Icons.block_outlined,
              business.status == BusinessStatus.suspended
                  ? 'Activar'
                  : 'Suspender',
              business.status == BusinessStatus.suspended
                  ? _C.success
                  : _C.error,
            ),
          ],
          onSelected: (v) {
            if (v == 'view') onView();
            if (v == 'edit') onEdit();
            if (v == 'contact') onContact();
            if (v == 'toggle') onToggleStatus();
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _popItem(
    String value,
    IconData icon,
    String label,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: _S.sm),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

// ── Delivery list tile ─────────────────────────────────────────────────────

class _DeliveryListTile extends StatelessWidget {
  final DeliveryPerson delivery;
  final VoidCallback onView, onEdit, onTrack, onBlock;
  const _DeliveryListTile({
    required this.delivery,
    required this.onView,
    required this.onEdit,
    required this.onTrack,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: _C.purpleBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delivery_dining_outlined,
            color: _C.purple,
            size: 18,
          ),
        ),
        const SizedBox(width: _S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                delivery.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _C.textSec,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: Color(0xFFF39C12),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    delivery.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 11,
                      color: _C.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    ' · ',
                    style: TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                  Text(
                    '${delivery.totalDeliveries} entregas',
                    style: const TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        _DeliveryStatusBadge(status: delivery.status),
        const SizedBox(width: _S.xs),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: _C.textMuted,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_R.card),
          ),
          offset: const Offset(0, 8),
          itemBuilder: (_) => [
            _popItem(
              'view',
              Icons.visibility_outlined,
              'Ver detalles',
              _C.primary,
            ),
            _popItem('edit', Icons.edit_outlined, 'Editar', _C.accent),
            _popItem(
              'track',
              Icons.location_on_outlined,
              'Rastrear',
              _C.success,
            ),
            _popItem('block', Icons.block_outlined, 'Desactivar', _C.error),
          ],
          onSelected: (v) {
            if (v == 'view') onView();
            if (v == 'edit') onEdit();
            if (v == 'track') onTrack();
            if (v == 'block') onBlock();
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _popItem(
    String value,
    IconData icon,
    String label,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: _S.sm),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

// ── Status badges ──────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final UserStatus status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case UserStatus.active:
        return _C.success;
      case UserStatus.idle:
        return _C.warning;
      case UserStatus.inactive:
        return _C.textMuted;
      case UserStatus.blocked:
        return _C.error;
    }
  }

  String get _label {
    switch (status) {
      case UserStatus.active:
        return 'Activo';
      case UserStatus.idle:
        return 'Inactivo';
      case UserStatus.inactive:
        return 'Desconectado';
      case UserStatus.blocked:
        return 'Bloqueado';
    }
  }

  @override
  Widget build(BuildContext context) => _Chip(label: _label, color: _color);
}

class _BusinessStatusBadge extends StatelessWidget {
  final BusinessStatus status;
  const _BusinessStatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case BusinessStatus.active:
        return _C.success;
      case BusinessStatus.pending:
        return _C.warning;
      case BusinessStatus.suspended:
        return _C.error;
      case BusinessStatus.inactive:
        return _C.textMuted;
    }
  }

  String get _label {
    switch (status) {
      case BusinessStatus.active:
        return 'Activo';
      case BusinessStatus.pending:
        return 'Pendiente';
      case BusinessStatus.suspended:
        return 'Suspendido';
      case BusinessStatus.inactive:
        return 'Inactivo';
    }
  }

  @override
  Widget build(BuildContext context) => _Chip(label: _label, color: _color);
}

class _DeliveryStatusBadge extends StatelessWidget {
  final DeliveryStatus status;
  const _DeliveryStatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case DeliveryStatus.active:
        return _C.success;
      case DeliveryStatus.offline:
        return _C.textMuted;
      case DeliveryStatus.onDelivery:
        return _C.accent;
      case DeliveryStatus.unavailable:
        return _C.error;
    }
  }

  String get _label {
    switch (status) {
      case DeliveryStatus.active:
        return 'Disponible';
      case DeliveryStatus.offline:
        return 'Sin conexión';
      case DeliveryStatus.onDelivery:
        return 'En entrega';
      case DeliveryStatus.unavailable:
        return 'No disponible';
    }
  }

  @override
  Widget build(BuildContext context) => _Chip(label: _label, color: _color);
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

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
    final color = isDanger ? _C.error : _C.primary;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDanger ? _C.error.withOpacity(0.08) : _C.primarySoft,
              borderRadius: BorderRadius.circular(_R.badge),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: _S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDanger ? _C.error : _C.textSec,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: _C.textMuted),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: isDanger ? _C.error.withOpacity(0.5) : _C.textMuted,
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
            color: value ? _C.primarySoft : _C.divider.withOpacity(0.5),
            borderRadius: BorderRadius.circular(_R.badge),
          ),
          child: Icon(icon, size: 16, color: value ? _C.primary : _C.textMuted),
        ),
        const SizedBox(width: _S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _C.textSec,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: _C.textMuted),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: _C.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

// ── Report row ─────────────────────────────────────────────────────────────

class _ReportRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ReportRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(_R.badge),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.textSec,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: _C.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_outlined, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  'Generar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Report summary card ────────────────────────────────────────────────────

class _ReportSummaryCard extends StatelessWidget {
  final String title, value, change;
  final IconData icon;
  final Color color;
  const _ReportSummaryCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.successBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: _C.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: _C.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── Notif item ─────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.only(bottom: _S.sm),
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
          const SizedBox(width: _S.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
                    color: _C.textSec,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: _C.textMuted),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: _C.textMuted),
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
                color: _C.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Row separator ──────────────────────────────────────────────────────────

class _RowSep extends StatelessWidget {
  const _RowSep();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: _S.sm),
      height: 0.5,
      color: _C.divider,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DETAIL SHEETS
// ─────────────────────────────────────────────────────────────────────────────

class _UserDetailSheet extends StatelessWidget {
  final ActiveUser user;
  final VoidCallback onEdit, onBlock;
  const _UserDetailSheet({
    required this.user,
    required this.onEdit,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(_S.md, _S.sm, _S.md, _S.md),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_C.primary, Color(0xFF0A5A9B)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_R.sheet),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.name[0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        user.id,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: user.status),
              ],
            ),
          ),
          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(_S.md),
              child: Column(
                children: [
                  // Info
                  _DetailSection(
                    title: 'Información de contacto',
                    icon: Icons.person_outline,
                    rows: [
                      _DetailRow(
                        icon: Icons.email_outlined,
                        label: 'Correo',
                        value: user.email,
                      ),
                      _DetailRow(
                        icon: Icons.phone_outlined,
                        label: 'Teléfono',
                        value: user.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.sm),
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Pedidos',
                          value: '${user.ordersCount}',
                          icon: Icons.shopping_bag_outlined,
                          color: _C.primary,
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Total gastado',
                          value: 'L ${user.totalSpent.toStringAsFixed(0)}',
                          icon: Icons.payments_outlined,
                          color: _C.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.md),
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.accent,
                            side: const BorderSide(color: _C.accent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onBlock,
                          icon: Icon(
                            user.status == UserStatus.blocked
                                ? Icons.lock_open_outlined
                                : Icons.block_outlined,
                            size: 16,
                          ),
                          label: Text(
                            user.status == UserStatus.blocked
                                ? 'Desbloquear'
                                : 'Bloquear',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: user.status == UserStatus.blocked
                                ? _C.success
                                : _C.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessDetailSheet extends StatelessWidget {
  final Business business;
  final DateFormat dateFormat;
  final VoidCallback onEdit, onToggle, onContact;
  const _BusinessDetailSheet({
    required this.business,
    required this.dateFormat,
    required this.onEdit,
    required this.onToggle,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isSuspended = business.status == BusinessStatus.suspended;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          Container(
            padding: const EdgeInsets.fromLTRB(_S.md, _S.sm, _S.md, _S.md),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_C.primary, Color(0xFF0A5A9B)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_R.sheet),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.store_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        business.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _BusinessStatusBadge(status: business.status),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(_S.md),
              child: Column(
                children: [
                  _DetailSection(
                    title: 'Información',
                    icon: Icons.info_outline,
                    rows: [
                      _DetailRow(
                        icon: Icons.email_outlined,
                        label: 'Correo',
                        value: business.email,
                      ),
                      _DetailRow(
                        icon: Icons.phone_outlined,
                        label: 'Teléfono',
                        value: business.phone,
                      ),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Registro',
                        value: dateFormat.format(business.registrationDate),
                      ),
                      _DetailRow(
                        icon: Icons.star_outlined,
                        label: 'Rating',
                        value: '${business.rating} ★',
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Ventas totales',
                          value:
                              'L ${NumberFormat('#,###').format(business.totalSales)}',
                          icon: Icons.trending_up_outlined,
                          color: _C.success,
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Total pedidos',
                          value: '${business.totalOrders}',
                          icon: Icons.shopping_bag_outlined,
                          color: _C.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onContact,
                          icon: const Icon(Icons.email_outlined, size: 16),
                          label: const Text('Contactar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.primary,
                            side: const BorderSide(color: _C.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.accent,
                            side: const BorderSide(color: _C.accent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.sm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onToggle,
                      icon: Icon(
                        isSuspended
                            ? Icons.check_circle_outlined
                            : Icons.block_outlined,
                        size: 16,
                      ),
                      label: Text(
                        isSuspended ? 'Activar negocio' : 'Suspender negocio',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSuspended ? _C.success : _C.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_R.button),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryDetailSheet extends StatelessWidget {
  final DeliveryPerson delivery;
  final VoidCallback onEdit, onBlock;
  const _DeliveryDetailSheet({
    required this.delivery,
    required this.onEdit,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          Container(
            padding: const EdgeInsets.fromLTRB(_S.md, _S.sm, _S.md, _S.md),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_C.purple, Color(0xFF5147C7)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_R.sheet),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      delivery.name[0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFF1C40F),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${delivery.rating}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _DeliveryStatusBadge(status: delivery.status),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(_S.md),
              child: Column(
                children: [
                  _DetailSection(
                    title: 'Información',
                    icon: Icons.info_outline,
                    rows: [
                      _DetailRow(
                        icon: Icons.email_outlined,
                        label: 'Correo',
                        value: delivery.email,
                      ),
                      _DetailRow(
                        icon: Icons.phone_outlined,
                        label: 'Teléfono',
                        value: delivery.phone,
                      ),
                      _DetailRow(
                        icon: Icons.two_wheeler_outlined,
                        label: 'Vehículo',
                        value: delivery.vehicle,
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Entregas',
                          value: '${delivery.totalDeliveries}',
                          icon: Icons.local_shipping_outlined,
                          color: _C.purple,
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: _MiniInfoCard(
                          label: 'Ganancias',
                          value:
                              'L ${delivery.totalEarnings.toStringAsFixed(0)}',
                          icon: Icons.payments_outlined,
                          color: _C.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _S.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.accent,
                            side: const BorderSide(color: _C.accent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: _S.sm),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onBlock,
                          icon: const Icon(Icons.block_outlined, size: 16),
                          label: const Text('Desactivar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _C.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_R.button),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail section ─────────────────────────────────────────────────────────

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_DetailRow> rows;
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.circular(_R.card),
        border: Border.all(color: _C.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(_S.md, 12, _S.md, 0),
            child: Row(
              children: [
                Icon(icon, size: 14, color: _C.textMuted),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _C.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...rows.asMap().entries.map(
            (e) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _S.md,
                    vertical: 8,
                  ),
                  child: e.value,
                ),
                if (e.key < rows.length - 1)
                  const Divider(height: 1, color: _C.divider, indent: 44),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _C.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: _C.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.textSec,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _MiniInfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(_R.card),
        border: Border.all(color: color.withOpacity(0.15), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: _C.textMuted),
          ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: _C.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ── Report options sheet ───────────────────────────────────────────────────

class _ReportOptionsSheet extends StatelessWidget {
  final String reportType;
  final Function(String) onGenerate;
  const _ReportOptionsSheet({
    required this.reportType,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final periods = [
      'Esta semana',
      'Este mes',
      'Último trimestre',
      'Este año',
      'Personalizado',
    ];
    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.sheet)),
      ),
      padding: EdgeInsets.fromLTRB(
        _S.md,
        8,
        _S.md,
        _S.md + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _C.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _C.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bar_chart_outlined,
                  color: _C.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reporte de $reportType',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _C.primary,
                    ),
                  ),
                  const Text(
                    'Selecciona el período',
                    style: TextStyle(fontSize: 12, color: _C.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: _C.divider),
          const SizedBox(height: 8),
          ...periods.map(
            (period) => Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(_R.input),
                onTap: () => onGenerate(period),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: _C.textMuted,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        period,
                        style: const TextStyle(fontSize: 14, color: _C.textSec),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: _C.textMuted,
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// DIALOGS
// ─────────────────────────────────────────────────────────────────────────────

class _DialogField {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? initialValue;
  const _DialogField({
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.initialValue,
  });
}

class _DialogDropdown {
  final String label;
  final List<String> items;
  const _DialogDropdown({required this.label, required this.items});
}

class _AdminDialog extends StatelessWidget {
  final String title, subtitle, actionLabel;
  final IconData icon;
  final VoidCallback onAction;
  final List<_DialogField> fields;
  final _DialogDropdown? dropdown;

  const _AdminDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    this.fields = const [],
    this.dropdown,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_R.card),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _C.primarySoft,
                    borderRadius: BorderRadius.circular(_R.badge),
                  ),
                  child: Icon(icon, size: 18, color: _C.primary),
                ),
                const SizedBox(width: _S.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _C.primary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _C.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: _S.md),
            const Divider(color: _C.divider, height: 1),
            const SizedBox(height: _S.md),
            ...fields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: _S.sm),
                child: TextField(
                  controller: TextEditingController(text: f.initialValue),
                  keyboardType: f.keyboardType,
                  style: const TextStyle(fontSize: 14, color: _C.textSec),
                  decoration: InputDecoration(
                    labelText: f.label,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      color: _C.textMuted,
                    ),
                    prefixIcon: Icon(f.icon, size: 17, color: _C.primary),
                    filled: true,
                    fillColor: _C.bg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_R.input),
                      borderSide: const BorderSide(
                        color: _C.divider,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_R.input),
                      borderSide: const BorderSide(
                        color: _C.divider,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_R.input),
                      borderSide: const BorderSide(
                        color: _C.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (dropdown != null)
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: dropdown!.label,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    color: _C.textMuted,
                  ),
                  filled: true,
                  fillColor: _C.bg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_R.input),
                    borderSide: const BorderSide(color: _C.divider, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_R.input),
                    borderSide: const BorderSide(color: _C.divider, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_R.input),
                    borderSide: const BorderSide(color: _C.primary, width: 1.5),
                  ),
                ),
                items: dropdown!.items
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (_) {},
              ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _C.textMuted,
                  side: const BorderSide(color: _C.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title, body, confirmLabel;
  final Color confirmColor;
  final IconData icon;
  final VoidCallback onConfirm;
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
    this.icon = Icons.warning_amber_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_R.card),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.all(12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: confirmColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: confirmColor, size: 26),
          ),
          const SizedBox(height: _S.md),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _C.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _S.sm),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: _C.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _C.textMuted,
                  side: const BorderSide(color: _C.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: _S.sm),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  confirmLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
