import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manda2_admin_frontend/const/colors.dart';
import 'package:manda2_admin_frontend/view/widgets/widgets.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final _periodPresets = const [
    'Hoy',
    'Esta semana',
    'Este mes',
    'Ultimos 30 dias',
  ];
  String _selectedPeriod = 'Este mes';
  DateTime? _customDate;
  DateTimeRange? _customRange;

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
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: C.success,
      ),
    );
  }

  void _showReportOptions(String reportType) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPeriodSelector(),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _ReportSummaryCard(
                title: 'Ingresos totales',
                value: 'L 1.2M',
                change: '+18%',
                icon: Icons.trending_up_outlined,
                color: C.success,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ReportSummaryCard(
                title: 'Pedidos este mes',
                value: '4,891',
                change: '+11%',
                icon: Icons.shopping_bag_outlined,
                color: C.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: _ReportSummaryCard(
                title: 'Comisiones cobradas',
                value: 'L 120K',
                change: '+9%',
                icon: Icons.percent_outlined,
                color: C.accent,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ReportSummaryCard(
                title: 'Nuevos usuarios',
                value: '234',
                change: '+22%',
                icon: Icons.person_add_outlined,
                color: C.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ContentCard(
          header: const CardHeader(title: 'Generar reportes'),
          child: Column(
            children: [
              _ReportRow(
                icon: Icons.trending_up_outlined,
                label: 'Reporte de ventas',
                subtitle: 'Ventas por periodo, negocio y categoria',
                color: C.success,
                onTap: () => _showReportOptions('Ventas'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.people_outlined,
                label: 'Reporte de usuarios',
                subtitle: 'Registro, actividad y segmentacion',
                color: C.primary,
                onTap: () => _showReportOptions('Usuarios'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.store_outlined,
                label: 'Reporte de negocios',
                subtitle: 'Desempeno, ratings y cumplimiento',
                color: C.accent,
                onTap: () => _showReportOptions('Negocios'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.delivery_dining_outlined,
                label: 'Reporte de repartidores',
                subtitle: 'Entregas, tiempo y calificaciones',
                color: C.purple,
                onTap: () => _showReportOptions('Repartidores'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.account_balance_outlined,
                label: 'Reporte financiero',
                subtitle: 'Flujo de caja, comisiones y liquidaciones',
                color: const Color(0xFF00A86B),
                onTap: () => _showReportOptions('Financiero'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.bar_chart_outlined,
                label: 'Reporte de pedidos',
                subtitle: 'Pedidos por estado, hora y zona',
                color: C.warning,
                onTap: () => _showReportOptions('Pedidos'),
              ),
              const RowSep(),
              _ReportRow(
                icon: Icons.star_outlined,
                label: 'Reporte de calificaciones',
                subtitle: 'Satisfaccion de clientes por negocio',
                color: const Color(0xFFF1C40F),
                onTap: () => _showReportOptions('Calificaciones'),
              ),
            ],
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

class _ReportRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 11),
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
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: C.textMuted,
                      height: 1.35,
                    ),
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

class _ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
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
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.divider.withOpacity(0.7), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: color),
              ),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: C.textSec,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 11, color: C.textMuted)),
        ],
      ),
    );
  }
}

class _ReportOptionsSheet extends StatelessWidget {
  final String reportType;
  final ValueChanged<String> onGenerate;
  const _ReportOptionsSheet({
    required this.reportType,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final periods = ['Hoy', 'Esta semana', 'Este mes', 'Personalizado'];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          const SizedBox(height: 8),
          Text(
            'Generar reporte de $reportType',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: C.textSec,
            ),
          ),
          const SizedBox(height: 12),
          ...periods.map(
            (p) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.assessment_outlined, color: C.primary),
              title: Text(p),
              onTap: () => onGenerate(p),
            ),
          ),
        ],
      ),
    );
  }
}
