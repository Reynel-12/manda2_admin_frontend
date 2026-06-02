import 'package:flutter/material.dart' hide Chip;
import 'package:intl/intl.dart';
import 'package:manda2_admin_frontend/const/colors.dart';
import 'package:manda2_admin_frontend/view/widgets/widgets.dart';

enum UserType { business, customer, delivery, admin }

enum UserStatus { active, idle, inactive, blocked }

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

class AdminUsersScreen extends StatefulWidget {
  final String searchQuery;

  const AdminUsersScreen({super.key, required this.searchQuery});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _periodPresets = const [
    'Hoy',
    'Esta semana',
    'Este mes',
    'Ultimos 30 dias',
  ];
  String _selectedPeriod = 'Este mes';
  DateTime? _customDate;
  DateTimeRange? _customRange;

  final List<ActiveUser> _activeUsers = [
    ActiveUser(
      id: 'USR001',
      name: 'Juan Perez',
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
      name: 'Maria Garcia',
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
      name: 'Carlos Rodriguez',
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
      name: 'Ana Martinez',
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
      name: 'Pedro Lopez',
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

  List<ActiveUser> get _filteredUsers {
    if (widget.searchQuery.isEmpty) return _activeUsers;
    final query = widget.searchQuery.toLowerCase();
    return _activeUsers
        .where(
          (u) =>
              u.name.toLowerCase().contains(query) ||
              u.email.toLowerCase().contains(query),
        )
        .toList();
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} dias';
  }

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
            const SizedBox(width: S.sm),
            Text(msg),
          ],
        ),
        backgroundColor: C.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(R.badge),
        ),
        margin: const EdgeInsets.all(S.md),
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Nuevo usuario',
        subtitle: 'Se enviara un correo con credenciales temporales',
        icon: Icons.person_add_outlined,
        actionLabel: 'Enviar invitacion',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Invitacion enviada');
        },
        fields: const [
          DialogField(
            label: 'Correo electronico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
        dropdown: DialogDropdown(
          label: 'Tipo de usuario',
          items: ['Negocio', 'Repartidor', 'Administrador'],
        ),
      ),
    );
  }

  void _showEditUser(ActiveUser user) {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Editar usuario',
        subtitle: user.name,
        icon: Icons.edit_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Usuario actualizado');
        },
        fields: [
          DialogField(
            label: 'Nombre completo',
            icon: Icons.person_outline,
            initialValue: user.name,
          ),
          DialogField(
            label: 'Correo electronico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: user.email,
          ),
          DialogField(
            label: 'Telefono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            initialValue: user.phone,
          ),
        ],
      ),
    );
  }

  void _confirmBlockUser(ActiveUser user) {
    final isBlocked = user.status == UserStatus.blocked;
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: isBlocked ? 'Desbloquear usuario' : 'Bloquear usuario',
        body: isBlocked
            ? 'Deseas desbloquear a ${user.name}? Podra acceder nuevamente a la plataforma.'
            : 'Deseas bloquear a ${user.name}? No podra acceder a la plataforma.',
        confirmLabel: isBlocked ? 'Desbloquear' : 'Bloquear',
        confirmColor: isBlocked ? C.success : C.error,
        onConfirm: () {
          Navigator.pop(context);
          _showSuccess(
            isBlocked ? '${user.name} desbloqueado' : '${user.name} bloqueado',
          );
        },
      ),
    );
  }

  void _showUserDetails(ActiveUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AdminUserDetailSheet(
        user: user,
        timeAgo: _getTimeAgo(user.lastActive),
        onEdit: () {
          Navigator.pop(context);
          _showEditUser(user);
        },
        onBlock: () {
          Navigator.pop(context);
          _confirmBlockUser(user);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildPeriodSelector(),
            ActionButton(
              label: 'Agregar',
              icon: Icons.person_add_outlined,
              onTap: _showAddUserDialog,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (users.isEmpty)
          const _AdminUsersEmptyState(
            message: 'No se encontraron usuarios',
            icon: Icons.people_outlined,
          )
        else
          ContentCard(
            header: CardHeader(
              title: 'Usuarios activos',
              action: Text(
                '${users.length} resultados',
                style: const TextStyle(
                  fontSize: 12,
                  color: C.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) => const RowSep(),
              itemBuilder: (_, i) => _AdminUserListTile(
                user: users[i],
                timeAgo: _getTimeAgo(users[i].lastActive),
                onView: () => _showUserDetails(users[i]),
                onEdit: () => _showEditUser(users[i]),
                onBlock: () => _confirmBlockUser(users[i]),
              ),
            ),
          ),
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
              icon: const Icon(Icons.expand_more_rounded, color: C.textMuted),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: C.textSec,
              ),
              borderRadius: BorderRadius.circular(12),
              items: _periodPresets
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
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
          onTap: _pickByCalendar,
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
                  _calendarLabel(),
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

  Future<void> _pickByCalendar() async {
    final mode = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
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
      ),
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

  String _calendarLabel() {
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
}

class _AdminUsersEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const _AdminUsersEmptyState({required this.message, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: C.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 40, color: C.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: C.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intenta con otro termino de busqueda',
              style: TextStyle(fontSize: 13, color: C.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminUserListTile extends StatelessWidget {
  final ActiveUser user;
  final String timeAgo;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onBlock;
  const _AdminUserListTile({
    required this.user,
    required this.timeAgo,
    required this.onView,
    required this.onEdit,
    required this.onBlock,
  });

  Color _typeColor() {
    switch (user.type) {
      case UserType.business:
        return C.primary;
      case UserType.customer:
        return C.success;
      case UserType.delivery:
        return C.purple;
      case UserType.admin:
        return C.accent;
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
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _typeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_typeIcon(), color: _typeColor(), size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: C.textSec,
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
                    ' • ',
                    style: TextStyle(fontSize: 11, color: C.textMuted),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(fontSize: 11, color: C.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        _AdminUserStatusBadge(status: user.status),
        const SizedBox(width: S.xs),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: C.textMuted,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(R.card),
          ),
          offset: const Offset(0, 8),
          itemBuilder: (_) => [
            _popItem(
              'view',
              Icons.visibility_outlined,
              'Ver detalles',
              C.primary,
            ),
            _popItem('edit', Icons.edit_outlined, 'Editar', C.accent),
            _popItem(
              'block',
              user.status == UserStatus.blocked
                  ? Icons.lock_open_outlined
                  : Icons.block_outlined,
              user.status == UserStatus.blocked ? 'Desbloquear' : 'Bloquear',
              C.error,
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
          const SizedBox(width: S.sm),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _AdminUserStatusBadge extends StatelessWidget {
  final UserStatus status;
  const _AdminUserStatusBadge({required this.status});
  Color get _color {
    switch (status) {
      case UserStatus.active:
        return C.success;
      case UserStatus.idle:
        return C.warning;
      case UserStatus.inactive:
        return C.textMuted;
      case UserStatus.blocked:
        return C.error;
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
  Widget build(BuildContext context) => Chip(label: _label, color: _color);
}

class _AdminUserDetailSheet extends StatelessWidget {
  final ActiveUser user;
  final String timeAgo;
  final VoidCallback onEdit;
  final VoidCallback onBlock;
  const _AdminUserDetailSheet({
    required this.user,
    required this.timeAgo,
    required this.onEdit,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.95,
      minChildSize: 0.45,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(R.sheet)),
        ),
        child: ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(S.md),
          children: [
            SheetHandle(),
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: C.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person_outline, color: C.primary),
                ),
                const SizedBox(width: S.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: C.primary,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: C.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _AdminUserStatusBadge(status: user.status),
              ],
            ),
            const SizedBox(height: S.md),
            DetailSection(
              title: 'Informacion general',
              rows: [
                DetailRow(
                  icon: Icons.badge_outlined,
                  label: 'ID',
                  value: user.id,
                ),
                DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Telefono',
                  value: user.phone,
                ),
                DetailRow(
                  icon: Icons.schedule_outlined,
                  label: 'Ultima actividad',
                  value: timeAgo,
                ),
              ],
              icon: Icons.info_outline,
            ),
            const SizedBox(height: S.md),
            Row(
              children: [
                Expanded(
                  child: MiniInfoCard(
                    label: 'Pedidos',
                    value: '${user.ordersCount}',
                    color: C.primary,
                    icon: Icons.shopping_cart_outlined,
                  ),
                ),
                const SizedBox(width: S.sm),
                Expanded(
                  child: MiniInfoCard(
                    label: 'Total',
                    value: 'L ${NumberFormat('#,###').format(user.totalSpent)}',
                    color: C.success,
                    icon: Icons.monetization_on_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: S.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(R.button),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: S.sm),
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
                          ? C.success
                          : C.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(R.button),
                      ),
                    ),
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
