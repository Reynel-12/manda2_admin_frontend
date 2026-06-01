import 'package:flutter/material.dart' hide Chip;
import 'package:intl/intl.dart';
import 'package:manda2_admin_frontend/const/colors.dart';
import 'package:manda2_admin_frontend/view/widgets/widgets.dart';

enum BusinessStatus { active, pending, suspended, inactive }

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

class AdminBusinessesScreen extends StatefulWidget {
  final String searchQuery;

  const AdminBusinessesScreen({super.key, required this.searchQuery});

  @override
  State<AdminBusinessesScreen> createState() => _AdminBusinessesScreenState();
}

class _AdminBusinessesScreenState extends State<AdminBusinessesScreen> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final List<Business> _businesses = [
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
      name: 'Cafeteria Central',
      email: 'info@cafeteria.com',
      phone: '+504 2222-3333',
      category: 'Cafeteria',
      status: BusinessStatus.pending,
      registrationDate: DateTime.now().subtract(const Duration(days: 15)),
      totalSales: 45000,
      totalOrders: 320,
      rating: 4.2,
    ),
    Business(
      id: 'BUS003',
      name: 'Pizzeria Italiana',
      email: 'italiana@pizza.com',
      phone: '+504 3333-4444',
      category: 'Pizzeria',
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

  List<Business> get _filteredBusinesses {
    if (widget.searchQuery.isEmpty) return _businesses;
    final q = widget.searchQuery.toLowerCase();
    return _businesses
        .where(
          (b) =>
              b.name.toLowerCase().contains(q) ||
              b.email.toLowerCase().contains(q),
        )
        .toList();
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

  void _showAddBusinessDialog() {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Nuevo negocio',
        subtitle: 'El negocio recibira un correo de bienvenida',
        icon: Icons.add_business_outlined,
        actionLabel: 'Agregar negocio',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Negocio agregado exitosamente');
        },
        fields: const [
          DialogField(label: 'Nombre del negocio', icon: Icons.store_outlined),
          DialogField(
            label: 'Correo electronico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          DialogField(
            label: 'Telefono de contacto',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  void _showEditBusiness(Business business) {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Editar negocio',
        subtitle: business.name,
        icon: Icons.store_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () {
          Navigator.pop(context);
          _showSuccess('Negocio actualizado');
        },
        fields: [
          DialogField(
            label: 'Nombre del negocio',
            icon: Icons.store_outlined,
            initialValue: business.name,
          ),
          DialogField(
            label: 'Correo electronico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: business.email,
          ),
          DialogField(
            label: 'Telefono',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            initialValue: business.phone,
          ),
        ],
      ),
    );
  }

  void _toggleBusinessStatus(Business business) {
    final isSuspended = business.status == BusinessStatus.suspended;
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: isSuspended ? 'Activar negocio' : 'Suspender negocio',
        body: isSuspended
            ? 'Deseas reactivar "${business.name}"?'
            : 'Deseas suspender "${business.name}"? No podra recibir pedidos.',
        confirmLabel: isSuspended ? 'Activar' : 'Suspender',
        confirmColor: isSuspended ? C.success : C.error,
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

  void _showBusinessDetails(Business business) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AdminBusinessDetailSheet(
        business: business,
        dateFormat: _dateFormat,
        onEdit: () {
          Navigator.pop(context);
          _showEditBusiness(business);
        },
        onToggle: () {
          Navigator.pop(context);
          _toggleBusinessStatus(business);
        },
        onContact: () {
          Navigator.pop(context);
          _showSuccess('Correo enviado a ${business.name}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businesses = _filteredBusinesses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ActionButton(
            label: 'Agregar',
            icon: Icons.add_business_outlined,
            onTap: _showAddBusinessDialog,
          ),
        ),
        const SizedBox(height: S.sm),
        if (businesses.isEmpty)
          const _AdminBusinessesEmptyState(
            message: 'No se encontraron negocios',
            icon: Icons.store_outlined,
          )
        else
          ContentCard(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: businesses.length,
              separatorBuilder: (_, __) => const RowSep(),
              itemBuilder: (_, i) => _AdminBusinessListTile(
                business: businesses[i],
                onView: () => _showBusinessDetails(businesses[i]),
                onEdit: () => _showEditBusiness(businesses[i]),
                onToggleStatus: () => _toggleBusinessStatus(businesses[i]),
                onContact: () =>
                    _showSuccess('Correo enviado a ${businesses[i].name}'),
              ),
            ),
          ),
      ],
    );
  }
}

class _AdminBusinessesEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const _AdminBusinessesEmptyState({required this.message, required this.icon});
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

class _AdminBusinessListTile extends StatelessWidget {
  final Business business;
  final VoidCallback onView, onEdit, onToggleStatus, onContact;
  const _AdminBusinessListTile({
    required this.business,
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
            color: C.primarySoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.store_outlined, color: C.primary, size: 18),
        ),
        const SizedBox(width: S.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: C.textSec,
                ),
              ),
              Row(
                children: [
                  Text(
                    business.category,
                    style: const TextStyle(fontSize: 11, color: C.textMuted),
                  ),
                  const Text(
                    ' � ',
                    style: TextStyle(fontSize: 11, color: C.textMuted),
                  ),
                  Text(
                    'L ${NumberFormat('#,###').format(business.totalSales)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: C.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _AdminBusinessStatusBadge(status: business.status),
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
            _popItem('contact', Icons.email_outlined, 'Contactar', C.success),
            _popItem(
              'toggle',
              business.status == BusinessStatus.suspended
                  ? Icons.check_circle_outlined
                  : Icons.block_outlined,
              business.status == BusinessStatus.suspended
                  ? 'Activar'
                  : 'Suspender',
              business.status == BusinessStatus.suspended ? C.success : C.error,
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
          const SizedBox(width: S.sm),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _AdminBusinessStatusBadge extends StatelessWidget {
  final BusinessStatus status;
  const _AdminBusinessStatusBadge({required this.status});
  Color get _color {
    switch (status) {
      case BusinessStatus.active:
        return C.success;
      case BusinessStatus.pending:
        return C.warning;
      case BusinessStatus.suspended:
        return C.error;
      case BusinessStatus.inactive:
        return C.textMuted;
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
  Widget build(BuildContext context) => Chip(label: _label, color: _color);
}

class _AdminBusinessDetailSheet extends StatelessWidget {
  final Business business;
  final DateFormat dateFormat;
  final VoidCallback onEdit, onToggle, onContact;
  const _AdminBusinessDetailSheet({
    required this.business,
    required this.dateFormat,
    required this.onEdit,
    required this.onToggle,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isSuspended = business.status == BusinessStatus.suspended;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
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
            const SheetHandle(),
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: C.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.store_outlined, color: C.primary),
                ),
                const SizedBox(width: S.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: C.primary,
                        ),
                      ),
                      Text(
                        business.email,
                        style: const TextStyle(
                          color: C.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _AdminBusinessStatusBadge(status: business.status),
              ],
            ),
            const SizedBox(height: S.md),
            DetailSection(
              title: 'Informacion general',
              icon: Icons.info_outline,
              rows: [
                DetailRow(
                  icon: Icons.badge_outlined,
                  label: 'ID',
                  value: business.id,
                ),
                DetailRow(
                  icon: Icons.category_outlined,
                  label: 'Categoria',
                  value: business.category,
                ),
                DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Telefono',
                  value: business.phone,
                ),
                DetailRow(
                  icon: Icons.event_outlined,
                  label: 'Registro',
                  value: dateFormat.format(business.registrationDate),
                ),
              ],
            ),
            const SizedBox(height: S.md),
            Row(
              children: [
                Expanded(
                  child: MiniInfoCard(
                    label: 'Pedidos',
                    value: '${business.totalOrders}',
                    color: C.primary,
                    icon: Icons.shopping_cart_outlined,
                  ),
                ),
                const SizedBox(width: S.sm),
                Expanded(
                  child: MiniInfoCard(
                    label: 'Ventas',
                    value:
                        'L ${NumberFormat('#,###').format(business.totalSales)}',
                    color: C.success,
                    icon: Icons.attach_money_outlined,
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
                  ),
                ),
                const SizedBox(width: S.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onContact,
                    icon: const Icon(Icons.email_outlined, size: 16),
                    label: const Text('Contactar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: S.sm),
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
                  backgroundColor: isSuspended ? C.success : C.error,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
