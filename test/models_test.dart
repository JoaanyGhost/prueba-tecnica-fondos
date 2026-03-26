import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica_fondos/models/fondo.dart';
import 'package:prueba_tecnica_fondos/models/transaccion.dart';
import 'package:prueba_tecnica_fondos/models/usuario.dart';

void main() {
  group('Modelo Fondo', () {
    test('Crear fondo desde JSON', () {
      final json = {
        'id': 1,
        'nombre': 'Test Fondo',
        'montoMinimo': 50000.0,
        'categoria': 'FPV',
      };

      final fondo = Fondo.fromJson(json);

      expect(fondo.id, 1);
      expect(fondo.nombre, 'Test Fondo');
      expect(fondo.montoMinimo, 50000.0);
      expect(fondo.categoria, 'FPV');
    });

    test('Convertir fondo a JSON', () {
      final fondo = Fondo(
        id: 1,
        nombre: 'Test Fondo',
        montoMinimo: 50000.0,
        categoria: 'FPV',
      );

      final json = fondo.toJson();

      expect(json['id'], 1);
      expect(json['nombre'], 'Test Fondo');
      expect(json['montoMinimo'], 50000.0);
      expect(json['categoria'], 'FPV');
    });
  });

  group('Modelo Usuario', () {
    test('Usuario inicial con saldo correcto', () {
      final usuario = Usuario(
        nombre: 'Test User',
        saldo: 500000,
      );

      expect(usuario.nombre, 'Test User');
      expect(usuario.saldo, 500000);
      expect(usuario.suscripciones.isEmpty, true);
    });

    test('Verificar saldo suficiente', () {
      final usuario = Usuario(nombre: 'Test', saldo: 100000);

      expect(usuario.tieneSaldoSuficiente(50000), true);
      expect(usuario.tieneSaldoSuficiente(150000), false);
    });

    test('Verificar suscripción a fondo', () {
      final usuario = Usuario(
        nombre: 'Test',
        saldo: 500000,
        suscripciones: {1: 75000},
      );

      expect(usuario.estaSuscrito(1), true);
      expect(usuario.estaSuscrito(2), false);
      expect(usuario.montoSuscrito(1), 75000);
      expect(usuario.montoSuscrito(2), 0);
    });

    test('CopyWith actualiza correctamente', () {
      final usuario = Usuario(nombre: 'Test', saldo: 500000);

      final usuarioActualizado = usuario.copyWith(
        saldo: 400000,
        suscripciones: {1: 100000},
      );

      expect(usuarioActualizado.saldo, 400000);
      expect(usuarioActualizado.suscripciones[1], 100000);
      expect(usuarioActualizado.nombre, 'Test'); // No cambió
    });
  });

  group('Modelo Transacción', () {
    test('Crear transacción de suscripción', () {
      final transaccion = Transaccion(
        id: '123',
        fondoId: 1,
        nombreFondo: 'Test Fondo',
        tipo: TipoTransaccion.suscripcion,
        monto: 75000,
        fecha: DateTime(2024, 1, 1),
        metodoNotificacion: MetodoNotificacion.email,
      );

      expect(transaccion.id, '123');
      expect(transaccion.tipo, TipoTransaccion.suscripcion);
      expect(transaccion.tipoTexto, 'Suscripción');
      expect(transaccion.metodoNotificacion, MetodoNotificacion.email);
    });

    test('Crear transacción de cancelación', () {
      final transaccion = Transaccion(
        id: '124',
        fondoId: 1,
        nombreFondo: 'Test Fondo',
        tipo: TipoTransaccion.cancelacion,
        monto: 75000,
        fecha: DateTime(2024, 1, 1),
      );

      expect(transaccion.tipo, TipoTransaccion.cancelacion);
      expect(transaccion.tipoTexto, 'Cancelación');
      expect(transaccion.metodoNotificacion, null);
    });

    test('Convertir transacción a JSON y desde JSON', () {
      final transaccion = Transaccion(
        id: '123',
        fondoId: 1,
        nombreFondo: 'Test Fondo',
        tipo: TipoTransaccion.suscripcion,
        monto: 75000,
        fecha: DateTime(2024, 1, 1, 12, 0, 0),
        metodoNotificacion: MetodoNotificacion.sms,
      );

      final json = transaccion.toJson();
      final transaccionFromJson = Transaccion.fromJson(json);

      expect(transaccionFromJson.id, transaccion.id);
      expect(transaccionFromJson.fondoId, transaccion.fondoId);
      expect(transaccionFromJson.tipo, transaccion.tipo);
      expect(transaccionFromJson.monto, transaccion.monto);
      expect(
        transaccionFromJson.metodoNotificacion,
        transaccion.metodoNotificacion,
      );
    });
  });
}
