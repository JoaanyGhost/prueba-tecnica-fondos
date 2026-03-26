import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fondo.dart';
import '../models/transaccion.dart';
import '../models/usuario.dart';
import '../services/fondos_service.dart';

// ============================================================================
// PROVIDERS DE SERVICIOS
// ============================================================================

/// Provider del servicio de fondos
final fondosServiceProvider = Provider<FondosService>((ref) {
  return FondosService();
});

// ============================================================================
// PROVIDERS DE ESTADO
// ============================================================================

/// Provider que maneja el estado del usuario
final usuarioProvider = StateNotifierProvider<UsuarioNotifier, Usuario>((ref) {
  return UsuarioNotifier();
});

/// Provider que obtiene la lista de fondos disponibles
final fondosProvider = FutureProvider<List<Fondo>>((ref) async {
  final service = ref.read(fondosServiceProvider);
  return await service.obtenerFondos();
});

/// Provider que maneja el historial de transacciones
final transaccionesProvider =
    StateNotifierProvider<TransaccionesNotifier, List<Transaccion>>((ref) {
  return TransaccionesNotifier();
});

/// Provider que indica si hay una operación en progreso
final loadingProvider = StateProvider<bool>((ref) => false);

// ============================================================================
// STATE NOTIFIERS
// ============================================================================

/// Notifier que maneja el estado del usuario
class UsuarioNotifier extends StateNotifier<Usuario> {
  UsuarioNotifier()
      : super(Usuario(
          nombre: 'Usuario BTG',
          saldo: 500000, // Saldo inicial según requisitos
        ));

  /// Suscribe al usuario a un fondo
  void suscribirse(int fondoId, double monto) {
    if (state.tieneSaldoSuficiente(monto)) {
      final nuevosSuscripciones = Map<int, double>.from(state.suscripciones);
      nuevosSuscripciones[fondoId] =
          (nuevosSuscripciones[fondoId] ?? 0) + monto;

      state = state.copyWith(
        saldo: state.saldo - monto,
        suscripciones: nuevosSuscripciones,
      );
    }
  }

  /// Cancela la suscripción del usuario a un fondo
  void cancelarSuscripcion(int fondoId) {
    if (state.estaSuscrito(fondoId)) {
      final monto = state.montoSuscrito(fondoId);
      final nuevosSuscripciones = Map<int, double>.from(state.suscripciones);
      nuevosSuscripciones.remove(fondoId);

      state = state.copyWith(
        saldo: state.saldo + monto,
        suscripciones: nuevosSuscripciones,
      );
    }
  }
}

/// Notifier que maneja el historial de transacciones
class TransaccionesNotifier extends StateNotifier<List<Transaccion>> {
  TransaccionesNotifier() : super([]);

  /// Agrega una nueva transacción al historial
  void agregarTransaccion(Transaccion transaccion) {
    state = [transaccion, ...state]; // Nuevas transacciones al inicio
  }

  /// Limpia el historial (útil para testing)
  void limpiarHistorial() {
    state = [];
  }
}
