import '../models/fondo.dart';

/// Servicio que simula una API REST para obtener fondos
/// En una aplicación real, esto haría peticiones HTTP
class FondosService {
  /// Simula un delay de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Obtiene la lista de fondos disponibles
  Future<List<Fondo>> obtenerFondos() async {
    await _simulateNetworkDelay();

    return _fondosMock;
  }

  /// Obtiene un fondo por su ID
  Future<Fondo?> obtenerFondoPorId(int id) async {
    await _simulateNetworkDelay();

    try {
      return _fondosMock.firstWhere((fondo) => fondo.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Datos mock de los fondos disponibles según los requisitos
final _fondosMock = [
  Fondo(
    id: 1,
    nombre: 'FPV_BTG_PACTUAL_RECAUDADORA',
    montoMinimo: 75000,
    categoria: 'FPV',
  ),
  Fondo(
    id: 2,
    nombre: 'FPV_BTG_PACTUAL_ECOPETROL',
    montoMinimo: 125000,
    categoria: 'FPV',
  ),
  Fondo(
    id: 3,
    nombre: 'DEUDAPRIVADA',
    montoMinimo: 50000,
    categoria: 'FIC',
  ),
  Fondo(
    id: 4,
    nombre: 'FDO-ACCIONES',
    montoMinimo: 250000,
    categoria: 'FIC',
  ),
  Fondo(
    id: 5,
    nombre: 'FPV_BTG_PACTUAL_DINAMICA',
    montoMinimo: 100000,
    categoria: 'FPV',
  ),
];
