import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/fondo.dart';
import '../models/transaccion.dart';
import '../providers/app_providers.dart';
import '../widgets/fondo_card.dart';
import '../widgets/suscripcion_dialog.dart';

/// Pantalla que muestra la lista de fondos disponibles
class FondosScreen extends ConsumerWidget {
  const FondosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fondosAsync = ref.watch(fondosProvider);
    final usuario = ref.watch(usuarioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fondos Disponibles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con saldo
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Tu saldo disponible',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.currency(
                    locale: 'es_CO',
                    symbol: '\$',
                    decimalDigits: 0,
                  ).format(usuario.saldo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Lista de fondos
          Expanded(
            child: fondosAsync.when(
              data: (fondos) => _buildFondosList(context, ref, fondos),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar fondos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFondosList(
    BuildContext context,
    WidgetRef ref,
    List<Fondo> fondos,
  ) {
    if (fondos.isEmpty) {
      return const Center(
        child: Text('No hay fondos disponibles'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: fondos.length,
      itemBuilder: (context, index) {
        final fondo = fondos[index];
        return FondoCard(
          fondo: fondo,
          onSuscribir: () => _mostrarDialogoSuscripcion(context, ref, fondo),
          onCancelar: () => _cancelarSuscripcion(context, ref, fondo),
        );
      },
    );
  }

  void _mostrarDialogoSuscripcion(
    BuildContext context,
    WidgetRef ref,
    Fondo fondo,
  ) {
    showDialog(
      context: context,
      builder: (context) => SuscripcionDialog(
        fondo: fondo,
        onSuscribir: (monto, metodoNotificacion) {
          _procesarSuscripcion(context, ref, fondo, monto, metodoNotificacion);
        },
      ),
    );
  }

  void _procesarSuscripcion(
    BuildContext context,
    WidgetRef ref,
    Fondo fondo,
    double monto,
    MetodoNotificacion metodoNotificacion,
  ) {
    final usuario = ref.read(usuarioProvider);

    // Validar saldo suficiente
    if (!usuario.tieneSaldoSuficiente(monto)) {
      _mostrarError(
        context,
        'Saldo insuficiente',
        'No tienes saldo suficiente para esta suscripción.',
      );
      return;
    }

    // Validar monto mínimo
    if (monto < fondo.montoMinimo) {
      _mostrarError(
        context,
        'Monto inválido',
        'El monto mínimo para este fondo es ${NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(fondo.montoMinimo)}',
      );
      return;
    }

    // Realizar suscripción
    ref.read(usuarioProvider.notifier).suscribirse(fondo.id, monto);

    // Agregar transacción al historial
    final transaccion = Transaccion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fondoId: fondo.id,
      nombreFondo: fondo.nombre,
      tipo: TipoTransaccion.suscripcion,
      monto: monto,
      fecha: DateTime.now(),
      metodoNotificacion: metodoNotificacion,
    );
    ref.read(transaccionesProvider.notifier).agregarTransaccion(transaccion);

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Suscripción exitosa! Se enviará notificación por ${metodoNotificacion.name.toUpperCase()}',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  void _cancelarSuscripcion(
    BuildContext context,
    WidgetRef ref,
    Fondo fondo,
  ) {
    final usuario = ref.read(usuarioProvider);

    if (!usuario.estaSuscrito(fondo.id)) {
      _mostrarError(
        context,
        'No estás suscrito',
        'No tienes una suscripción activa a este fondo.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Suscripción'),
        content: Text(
          '¿Estás seguro de que deseas cancelar tu suscripción a ${fondo.nombre}?\n\nSe te devolverá ${NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(usuario.montoSuscrito(fondo.id))}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          FilledButton(
            onPressed: () {
              final monto = usuario.montoSuscrito(fondo.id);

              // Cancelar suscripción
              ref.read(usuarioProvider.notifier).cancelarSuscripcion(fondo.id);

              // Agregar transacción al historial
              final transaccion = Transaccion(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                fondoId: fondo.id,
                nombreFondo: fondo.nombre,
                tipo: TipoTransaccion.cancelacion,
                monto: monto,
                fecha: DateTime.now(),
              );
              ref
                  .read(transaccionesProvider.notifier)
                  .agregarTransaccion(transaccion);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Suscripción cancelada exitosamente'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _mostrarError(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(titulo),
          ],
        ),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
