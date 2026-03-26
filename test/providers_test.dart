import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_fondos/models/transaccion.dart';
import 'package:prueba_tecnica_fondos/providers/app_providers.dart';

void main() {
  group('UsuarioNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Estado inicial del usuario', () {
      final usuario = container.read(usuarioProvider);

      expect(usuario.nombre, 'Usuario BTG');
      expect(usuario.saldo, 500000);
      expect(usuario.suscripciones.isEmpty, true);
    });

    test('Suscribirse a un fondo reduce el saldo', () {
      final notifier = container.read(usuarioProvider.notifier);

      notifier.suscribirse(1, 75000);

      final usuario = container.read(usuarioProvider);
      expect(usuario.saldo, 425000); // 500000 - 75000
      expect(usuario.estaSuscrito(1), true);
      expect(usuario.montoSuscrito(1), 75000);
    });

    test('No se puede suscribir sin saldo suficiente', () {
      final notifier = container.read(usuarioProvider.notifier);

      // Intentar suscribirse con más del saldo disponible
      notifier.suscribirse(1, 600000);

      final usuario = container.read(usuarioProvider);
      expect(usuario.saldo, 500000); // No cambió
      expect(usuario.estaSuscrito(1), false);
    });

    test('Cancelar suscripción devuelve el saldo', () {
      final notifier = container.read(usuarioProvider.notifier);

      // Primero suscribirse
      notifier.suscribirse(1, 75000);
      var usuario = container.read(usuarioProvider);
      expect(usuario.saldo, 425000);

      // Luego cancelar
      notifier.cancelarSuscripcion(1);
      usuario = container.read(usuarioProvider);
      expect(usuario.saldo, 500000); // Saldo restaurado
      expect(usuario.estaSuscrito(1), false);
    });

    test('Múltiples suscripciones al mismo fondo se acumulan', () {
      final notifier = container.read(usuarioProvider.notifier);

      notifier.suscribirse(1, 50000);
      notifier.suscribirse(1, 25000);

      final usuario = container.read(usuarioProvider);
      expect(usuario.montoSuscrito(1), 75000);
      expect(usuario.saldo, 425000); // 500000 - 75000
    });
  });

  group('TransaccionesNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Historial inicial está vacío', () {
      final transacciones = container.read(transaccionesProvider);
      expect(transacciones.isEmpty, true);
    });

    test('Agregar transacción al historial', () {
      final notifier = container.read(transaccionesProvider.notifier);

      final transaccion = Transaccion(
        id: '1',
        fondoId: 1,
        nombreFondo: 'Test Fondo',
        tipo: TipoTransaccion.suscripcion,
        monto: 75000,
        fecha: DateTime.now(),
      );

      notifier.agregarTransaccion(transaccion);

      final transacciones = container.read(transaccionesProvider);
      expect(transacciones.length, 1);
      expect(transacciones.first.id, '1');
    });

    test('Nuevas transacciones aparecen primero', () {
      final notifier = container.read(transaccionesProvider.notifier);

      final transaccion1 = Transaccion(
        id: '1',
        fondoId: 1,
        nombreFondo: 'Fondo 1',
        tipo: TipoTransaccion.suscripcion,
        monto: 75000,
        fecha: DateTime.now(),
      );

      final transaccion2 = Transaccion(
        id: '2',
        fondoId: 2,
        nombreFondo: 'Fondo 2',
        tipo: TipoTransaccion.cancelacion,
        monto: 50000,
        fecha: DateTime.now(),
      );

      notifier.agregarTransaccion(transaccion1);
      notifier.agregarTransaccion(transaccion2);

      final transacciones = container.read(transaccionesProvider);
      expect(transacciones.length, 2);
      expect(transacciones.first.id, '2'); // La más reciente
      expect(transacciones.last.id, '1');
    });

    test('Limpiar historial', () {
      final notifier = container.read(transaccionesProvider.notifier);

      final transaccion = Transaccion(
        id: '1',
        fondoId: 1,
        nombreFondo: 'Test Fondo',
        tipo: TipoTransaccion.suscripcion,
        monto: 75000,
        fecha: DateTime.now(),
      );

      notifier.agregarTransaccion(transaccion);
      expect(container.read(transaccionesProvider).length, 1);

      notifier.limpiarHistorial();
      expect(container.read(transaccionesProvider).isEmpty, true);
    });
  });
}
