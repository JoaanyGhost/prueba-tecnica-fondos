import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica_fondos/services/fondos_service.dart';

void main() {
  group('FondosService Tests', () {
    late FondosService service;

    setUp(() {
      service = FondosService();
    });

    test('Obtener lista de fondos devuelve 5 fondos', () async {
      final fondos = await service.obtenerFondos();

      expect(fondos.length, 5);
    });

    test('Fondos tienen los datos correctos', () async {
      final fondos = await service.obtenerFondos();

      // Verificar primer fondo
      expect(fondos[0].id, 1);
      expect(fondos[0].nombre, 'FPV_BTG_PACTUAL_RECAUDADORA');
      expect(fondos[0].montoMinimo, 75000);
      expect(fondos[0].categoria, 'FPV');

      // Verificar último fondo
      expect(fondos[4].id, 5);
      expect(fondos[4].nombre, 'FPV_BTG_PACTUAL_DINAMICA');
      expect(fondos[4].montoMinimo, 100000);
      expect(fondos[4].categoria, 'FPV');
    });

    test('Obtener fondo por ID existente', () async {
      final fondo = await service.obtenerFondoPorId(3);

      expect(fondo, isNotNull);
      expect(fondo!.nombre, 'DEUDAPRIVADA');
      expect(fondo.montoMinimo, 50000);
      expect(fondo.categoria, 'FIC');
    });

    test('Obtener fondo por ID inexistente devuelve null', () async {
      final fondo = await service.obtenerFondoPorId(999);

      expect(fondo, isNull);
    });

    test('Todos los fondos tienen IDs únicos', () async {
      final fondos = await service.obtenerFondos();
      final ids = fondos.map((f) => f.id).toSet();

      expect(ids.length, fondos.length);
    });

    test('Todos los fondos tienen categoría válida', () async {
      final fondos = await service.obtenerFondos();
      final categoriasValidas = {'FPV', 'FIC'};

      for (var fondo in fondos) {
        expect(categoriasValidas.contains(fondo.categoria), true);
      }
    });

    test('Todos los fondos tienen monto mínimo positivo', () async {
      final fondos = await service.obtenerFondos();

      for (var fondo in fondos) {
        expect(fondo.montoMinimo, greaterThan(0));
      }
    });
  });
}
