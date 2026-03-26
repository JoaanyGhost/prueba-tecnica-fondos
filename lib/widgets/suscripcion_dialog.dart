import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/fondo.dart';
import '../models/transaccion.dart';
import '../providers/app_providers.dart';

/// Diálogo para suscribirse a un fondo
class SuscripcionDialog extends ConsumerStatefulWidget {
  final Fondo fondo;
  final Function(double monto, MetodoNotificacion metodoNotificacion)
      onSuscribir;

  const SuscripcionDialog({
    super.key,
    required this.fondo,
    required this.onSuscribir,
  });

  @override
  ConsumerState<SuscripcionDialog> createState() => _SuscripcionDialogState();
}

class _SuscripcionDialogState extends ConsumerState<SuscripcionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  MetodoNotificacion _metodoNotificacion = MetodoNotificacion.email;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(usuarioProvider);
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Suscribirse al Fondo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Nombre del fondo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fondo.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Categoría: ${widget.fondo.categoria}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Información importante
                _InfoCard(
                  icon: Icons.info_outline,
                  color: Colors.blue,
                  children: [
                    _InfoRow(
                      label: 'Monto mínimo:',
                      value: formatCurrency.format(widget.fondo.montoMinimo),
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(
                      label: 'Tu saldo disponible:',
                      value: formatCurrency.format(usuario.saldo),
                      valueColor: usuario.saldo >= widget.fondo.montoMinimo
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Campo de monto
                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Monto a invertir',
                    hintText: 'Ingresa el monto',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    helperText:
                        'Mínimo: ${formatCurrency.format(widget.fondo.montoMinimo)}',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un monto';
                    }

                    final monto = double.tryParse(value);
                    if (monto == null) {
                      return 'Monto inválido';
                    }

                    if (monto < widget.fondo.montoMinimo) {
                      return 'El monto debe ser mayor o igual a ${formatCurrency.format(widget.fondo.montoMinimo)}';
                    }

                    if (monto > usuario.saldo) {
                      return 'No tienes saldo suficiente';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Selector de método de notificación
                const Text(
                  'Método de notificación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _NotificationOption(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        isSelected:
                            _metodoNotificacion == MetodoNotificacion.email,
                        onTap: () {
                          setState(() {
                            _metodoNotificacion = MetodoNotificacion.email;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NotificationOption(
                        icon: Icons.sms_outlined,
                        label: 'SMS',
                        isSelected:
                            _metodoNotificacion == MetodoNotificacion.sms,
                        onTap: () {
                          setState(() {
                            _metodoNotificacion = MetodoNotificacion.sms;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _confirmarSuscripcion,
                        child: const Text('Confirmar'),
                      ),
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

  void _confirmarSuscripcion() {
    if (_formKey.currentState!.validate()) {
      final monto = double.parse(_montoController.text);
      widget.onSuscribir(monto, _metodoNotificacion);
    }
  }
}

/// Widget para las opciones de notificación
class _NotificationOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NotificationOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar información destacada
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _InfoCard({
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar una fila de información
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
