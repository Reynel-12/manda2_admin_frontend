import 'package:flutter/material.dart';
import 'package:manda2_admin_frontend/const/colors.dart';
import 'package:manda2_admin_frontend/view/widgets/widgets.dart';

enum DeliveryStatus { active, offline, onDelivery, unavailable }

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

class AdminDeliveryScreen extends StatefulWidget {
  final String searchQuery;
  const AdminDeliveryScreen({super.key, required this.searchQuery});

  @override
  State<AdminDeliveryScreen> createState() => _AdminDeliveryScreenState();
}

class _AdminDeliveryScreenState extends State<AdminDeliveryScreen> {
  final List<DeliveryPerson> _deliveryPersons = [
    DeliveryPerson(id: 'DLV001', name: 'Carlos Rodriguez', email: 'carlos@repartidor.com', phone: '+504 1234-5678', vehicle: 'Moto Honda CB190', status: DeliveryStatus.active, rating: 4.8, totalDeliveries: 156, totalEarnings: 4800),
    DeliveryPerson(id: 'DLV002', name: 'Luis Fernandez', email: 'luis@repartidor.com', phone: '+504 2345-6789', vehicle: 'Moto Yamaha YBR125', status: DeliveryStatus.offline, rating: 4.5, totalDeliveries: 89, totalEarnings: 2700),
    DeliveryPerson(id: 'DLV003', name: 'Pedro Sanchez', email: 'pedro@repartidor.com', phone: '+504 3456-7890', vehicle: 'Moto Suzuki GN125', status: DeliveryStatus.onDelivery, rating: 4.9, totalDeliveries: 210, totalEarnings: 6300),
    DeliveryPerson(id: 'DLV004', name: 'Miguel Angel', email: 'miguel@repartidor.com', phone: '+504 4567-8901', vehicle: 'Bicicleta', status: DeliveryStatus.unavailable, rating: 4.1, totalDeliveries: 45, totalEarnings: 1350),
  ];

  List<DeliveryPerson> get _filteredDelivery {
    if (widget.searchQuery.isEmpty) return _deliveryPersons;
    final q = widget.searchQuery.toLowerCase();
    return _deliveryPersons.where((d) => d.name.toLowerCase().contains(q) || d.phone.toLowerCase().contains(q)).toList();
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16), const SizedBox(width: 8), Text(msg)]),
        backgroundColor: C.success,
      ),
    );
  }

  void _showAddDeliveryDialog() {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Nuevo repartidor',
        subtitle: 'Recibira correo para activar su cuenta',
        icon: Icons.delivery_dining_outlined,
        actionLabel: 'Agregar repartidor',
        onAction: () { Navigator.pop(context); _showSuccess('Repartidor agregado exitosamente'); },
        fields: const [
          DialogField(label: 'Nombre completo', icon: Icons.badge_outlined),
          DialogField(label: 'Correo electronico', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          DialogField(label: 'Telefono', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
        ],
      ),
    );
  }

  void _showEditDelivery(DeliveryPerson delivery) {
    showDialog(
      context: context,
      builder: (_) => AdminDialog(
        title: 'Editar repartidor',
        subtitle: delivery.name,
        icon: Icons.delivery_dining_outlined,
        actionLabel: 'Guardar cambios',
        onAction: () { Navigator.pop(context); _showSuccess('Repartidor actualizado'); },
        fields: [
          DialogField(label: 'Nombre completo', icon: Icons.badge_outlined, initialValue: delivery.name),
          DialogField(label: 'Correo electronico', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, initialValue: delivery.email),
          DialogField(label: 'Telefono', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, initialValue: delivery.phone),
          DialogField(label: 'Vehiculo', icon: Icons.two_wheeler_outlined, initialValue: delivery.vehicle),
        ],
      ),
    );
  }

  void _confirmBlockDelivery(DeliveryPerson delivery) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Desactivar repartidor',
        body: 'Deseas desactivar a ${delivery.name}? No podra recibir pedidos.',
        confirmLabel: 'Desactivar',
        confirmColor: C.error,
        onConfirm: () { Navigator.pop(context); _showSuccess('${delivery.name} desactivado'); },
      ),
    );
  }

  void _showDeliveryDetails(DeliveryPerson delivery) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DeliveryDetailSheet(
        delivery: delivery,
        onEdit: () { Navigator.pop(context); _showEditDelivery(delivery); },
        onBlock: () { Navigator.pop(context); _confirmBlockDelivery(delivery); },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery = _filteredDelivery;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerRight, child: ActionButton(label: 'Agregar', icon: Icons.person_add_outlined, onTap: _showAddDeliveryDialog)),
        const SizedBox(height: 8),
        if (delivery.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No se encontraron repartidores', style: TextStyle(color: C.textMuted))))
        else
          ContentCard(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: delivery.length,
              separatorBuilder: (_, __) => const RowSep(),
              itemBuilder: (_, i) => _DeliveryListTile(
                delivery: delivery[i],
                onView: () => _showDeliveryDetails(delivery[i]),
                onEdit: () => _showEditDelivery(delivery[i]),
                onTrack: () => _showSuccess('Rastreando a ${delivery[i].name}'),
                onBlock: () => _confirmBlockDelivery(delivery[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _DeliveryListTile extends StatelessWidget {
  final DeliveryPerson delivery;
  final VoidCallback onView, onEdit, onTrack, onBlock;
  const _DeliveryListTile({required this.delivery, required this.onView, required this.onEdit, required this.onTrack, required this.onBlock});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 40, height: 40, decoration: const BoxDecoration(color: C.purpleBg, shape: BoxShape.circle), child: const Icon(Icons.delivery_dining_outlined, color: C.purple, size: 18)),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(delivery.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.textSec)),
        Text('${delivery.rating.toStringAsFixed(1)} · ${delivery.totalDeliveries} entregas', style: const TextStyle(fontSize: 11, color: C.textMuted)),
      ])),
      _DeliveryStatusBadge(status: delivery.status),
      PopupMenuButton<String>(
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'view', child: Text('Ver detalles')),
          const PopupMenuItem(value: 'edit', child: Text('Editar')),
          const PopupMenuItem(value: 'track', child: Text('Rastrear')),
          const PopupMenuItem(value: 'block', child: Text('Desactivar')),
        ],
        onSelected: (v) { if (v == 'view') onView(); if (v == 'edit') onEdit(); if (v == 'track') onTrack(); if (v == 'block') onBlock(); },
      ),
    ]);
  }
}

class _DeliveryStatusBadge extends StatelessWidget {
  final DeliveryStatus status;
  const _DeliveryStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (status) {
      case DeliveryStatus.active:
        label = 'Activo'; color = C.success; break;
      case DeliveryStatus.offline:
        label = 'Offline'; color = C.textMuted; break;
      case DeliveryStatus.onDelivery:
        label = 'En entrega'; color = C.accent; break;
      case DeliveryStatus.unavailable:
        label = 'No disponible'; color = C.error; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _DeliveryDetailSheet extends StatelessWidget {
  final DeliveryPerson delivery;
  final VoidCallback onEdit, onBlock;
  const _DeliveryDetailSheet({required this.delivery, required this.onEdit, required this.onBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(delivery.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(delivery.email, style: const TextStyle(color: C.textMuted)),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: OutlinedButton(onPressed: onEdit, child: const Text('Editar'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: onBlock, child: const Text('Desactivar')))]),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}
