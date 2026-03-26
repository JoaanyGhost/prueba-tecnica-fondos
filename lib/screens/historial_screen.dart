import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaccion.dart';
import '../providers/app_providers.dart';

/// Pantalla que muestra el historial de transacciones
class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transacciones = ref.watch(transaccionesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de Transacciones',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: transacciones.isEmpty
          ? _buildEmptyState()
          : _buildTransaccionesList(transacciones),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay transacciones',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus suscripciones y cancelaciones\naparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaccionesList(List<Transaccion> transacciones) {
    // Agrupar transacciones por fecha
    final Map<String, List<Transaccion>> transaccionesPorFecha = {};
    final dateFormat = DateFormat('dd/MM/yyyy');

    for (var transaccion in transacciones) {
      final fechaStr = dateFormat.format(transaccion.fecha);
      if (!transaccionesPorFecha.containsKey(fechaStr)) {
        transaccionesPorFecha[fechaStr] = [];
      }
      transaccionesPorFecha[fechaStr]!.add(transaccion);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transaccionesPorFecha.length,
      itemBuilder: (context, index) {
        final fecha = transaccionesPorFecha.keys.elementAt(index);
        final transaccionesFecha = transaccionesPorFecha[fecha]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _getFechaTexto(fecha),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            ...transaccionesFecha.map((t) => _TransaccionCard(transaccion: t)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  String _getFechaTexto(String fecha) {
    final hoy = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final ayer = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 1)));

    if (fecha == hoy) return 'Hoy';
    if (fecha == ayer) return 'Ayer';
    return fecha;
  }
}

/// Widget que representa una tarjeta de transacción
class _TransaccionCard extends StatelessWidget {
  final Transaccion transaccion;

  const _TransaccionCard({required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final esSuscripcion = transaccion.tipo == TipoTransaccion.suscripcion;
    final color = esSuscripcion ? Colors.green : Colors.orange;
    final icon = esSuscripcion ? Icons.add_circle : Icons.remove_circle;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaccion.tipoTexto,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaccion.nombreFondo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(transaccion.fecha),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ' - ${timeFormat.format(transaccion.fecha)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (transaccion.metodoNotificacion != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          transaccion.metodoNotificacion ==
                                  MetodoNotificacion.email
                              ? Icons.email_outlined
                              : Icons.sms_outlined,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          transaccion.metodoNotificacion!.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Monto
            Text(
              '${esSuscripcion ? '-' : '+'} ${NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(transaccion.monto)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
