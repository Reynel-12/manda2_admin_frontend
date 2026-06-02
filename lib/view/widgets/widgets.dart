import 'package:flutter/material.dart';
import 'package:manda2_admin_frontend/const/colors.dart';

class AdminDialog extends StatefulWidget {
  final String title, subtitle, actionLabel;
  final IconData icon;
  final VoidCallback onAction;
  final List<DialogField> fields;
  final DialogDropdown? dropdown;

  const AdminDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    this.fields = const [],
    this.dropdown,
  });

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  String? _selectedDropdown;
  DateTime? _pickedDate;
  DateTimeRange? _pickedRange;

  @override
  void initState() {
    super.initState();
    _selectedDropdown = widget.dropdown?.initialValue;
  }

  InputDecoration _fieldDecoration({
    required String label,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: C.textMuted,
      ),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: C.primary) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: C.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        borderSide: const BorderSide(color: C.primary, width: 1.4),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _calendarLabel() {
    if (_pickedRange != null) {
      return '${_formatDate(_pickedRange!.start)} - ${_formatDate(_pickedRange!.end)}';
    }
    if (_pickedDate != null) {
      return _formatDate(_pickedDate!);
    }
    return widget.dropdown?.calendarHint ?? 'Seleccionar por calendario';
  }

  Future<void> _pickCalendar() async {
    if (widget.dropdown == null || !widget.dropdown!.allowCalendarSelection) {
      return;
    }

    final now = DateTime.now();
    final firstDate = widget.dropdown!.firstDate ?? DateTime(now.year - 2);
    final lastDate = widget.dropdown!.lastDate ?? DateTime(now.year + 2);

    if (widget.dropdown!.calendarMode == DialogCalendarMode.range) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDateRange: _pickedRange,
        helpText: 'Selecciona un periodo',
        cancelText: 'Cancelar',
        confirmText: 'Aplicar',
      );
      if (picked != null) {
        setState(() => _pickedRange = picked);
        widget.dropdown!.onCalendarRangeSelected?.call(picked);
      }
      return;
    }

    final picked = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: _pickedDate ?? now,
      helpText: 'Selecciona una fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
    );

    if (picked != null) {
      setState(() => _pickedDate = picked);
      widget.dropdown!.onCalendarDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(R.card),
      ),
      backgroundColor: C.surface,
      contentPadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: C.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, size: 19, color: C.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: C.primary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: C.textMuted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: C.divider, height: 1),
            const SizedBox(height: 16),
            ...widget.fields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: TextEditingController(text: f.initialValue),
                  keyboardType: f.keyboardType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: C.textSec,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _fieldDecoration(label: f.label, icon: f.icon),
                ),
              ),
            ),
            if (widget.dropdown != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedDropdown,
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 14,
                      color: C.textSec,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: const Icon(
                      Icons.expand_more_rounded,
                      color: C.textMuted,
                    ),
                    decoration: _fieldDecoration(
                      label: widget.dropdown!.label,
                      icon: widget.dropdown!.icon,
                    ),
                    items: widget.dropdown!.items
                        .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedDropdown = value);
                      widget.dropdown!.onChanged?.call(value);
                    },
                  ),
                  if (widget.dropdown!.allowCalendarSelection) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickCalendar,
                      borderRadius: BorderRadius.circular(R.input),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: C.bg,
                          borderRadius: BorderRadius.circular(R.input),
                          border: Border.all(color: C.divider, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: C.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _calendarLabel(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      (_pickedDate != null ||
                                          _pickedRange != null)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color:
                                      (_pickedDate != null ||
                                          _pickedRange != null)
                                      ? C.textSec
                                      : C.textMuted,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: C.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
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
                  foregroundColor: C.textMuted,
                  side: const BorderSide(color: C.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: widget.onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  widget.actionLabel,
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

class DialogField {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? initialValue;
  const DialogField({
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.initialValue,
  });
}

enum DialogCalendarMode { single, range }

class DialogDropdown {
  final String label;
  final List<String> items;
  final IconData? icon;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final bool allowCalendarSelection;
  final DialogCalendarMode calendarMode;
  final String? calendarHint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onCalendarDateSelected;
  final ValueChanged<DateTimeRange>? onCalendarRangeSelected;

  const DialogDropdown({
    required this.label,
    required this.items,
    this.icon,
    this.initialValue,
    this.onChanged,
    this.allowCalendarSelection = false,
    this.calendarMode = DialogCalendarMode.range,
    this.calendarHint,
    this.firstDate,
    this.lastDate,
    this.onCalendarDateSelected,
    this.onCalendarRangeSelected,
  });
}

class ConfirmDialog extends StatelessWidget {
  final String title, body, confirmLabel;
  final Color confirmColor;
  final IconData icon;
  final VoidCallback onConfirm;
  const ConfirmDialog({
    super.key,
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
        borderRadius: BorderRadius.circular(R.card),
      ),
      backgroundColor: C.surface,
      contentPadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: confirmColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: confirmColor, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: C.primary,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: C.textMuted,
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
                  foregroundColor: C.textMuted,
                  side: const BorderSide(color: C.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(R.button),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
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

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: C.accent,
          borderRadius: BorderRadius.circular(R.button),
          boxShadow: [
            BoxShadow(
              color: C.accent.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: S.xs),
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

class ContentCard extends StatelessWidget {
  final Widget child;
  final CardHeader? header;
  const ContentCard({super.key, required this.child, this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.divider.withOpacity(0.9), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(S.md, S.md, S.md, 0),
              child: header!,
            ),
          Padding(padding: const EdgeInsets.all(S.md), child: child),
        ],
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const CardHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: C.textSec,
              height: 1.25,
            ),
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class RowSep extends StatelessWidget {
  const RowSep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 0.8,
      color: C.divider,
    );
  }
}

class Chip extends StatelessWidget {
  final String label;
  final Color color;
  const Chip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(7),
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

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: C.divider,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<DetailRow> rows;
  const DetailSection({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.bg,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.divider, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(S.md, 12, S.md, 0),
            child: Row(
              children: [
                Icon(icon, size: 14, color: C.textMuted),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: C.textMuted,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          ...rows.asMap().entries.map(
            (e) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: S.md,
                    vertical: 9,
                  ),
                  child: e.value,
                ),
                if (e.key < rows.length - 1)
                  const Divider(height: 1, color: C.divider, indent: 42),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: C.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: C.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: C.textSec,
            ),
          ),
        ),
      ],
    );
  }
}

class MiniInfoCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const MiniInfoCard({
    super.key,
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
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: color.withOpacity(0.16), width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 9),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: C.textMuted)),
        ],
      ),
    );
  }
}
