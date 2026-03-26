import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/fondo.dart';
import '../providers/app_providers.dart';

/// Widget reutilizable que muestra la información de un fondo
class FondoCard extends ConsumerWidget {
  final Fondo fondo;
  final VoidCallback onSuscribir;
  final VoidCallback onCancelar;

  const FondoCard({
    super.key,
    required this.fondo,
    required this.onSuscribir,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioProvider);
    final estaSuscrito = usuario.estaSuscrito(fondo.id);
    final montoSuscrito = usuario.montoSuscrito(fondo.id);
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con categoría y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Categoría
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoriaColor(fondo.categoria).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    fondo.categoria,
                    style: TextStyle(
                      color: _getCategoriaColor(fondo.categoria),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Estado de suscripción
                if (estaSuscrito)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Suscrito',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Nombre del fondo
            Text(
              fondo.nombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Información del fondo
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.monetization_on_outlined,
                    label: 'Monto mínimo',
                    value: formatCurrency.format(fondo.montoMinimo),
                  ),
                ),
                if (estaSuscrito)
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Tu inversión',
                      value: formatCurrency.format(montoSuscrito),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSuscribir,
                    icon: const Icon(Icons.add),
                    label: Text(estaSuscrito ? 'Agregar más' : 'Suscribirse'),
                  ),
                ),
                if (estaSuscrito) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onCancelar,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoriaColor(String categoria) {
    switch (categoria) {
      case 'FPV':
        return Colors.blue;
      case 'FIC':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

/// Widget para mostrar un item de información
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
