/// Modelo para representar al usuario y sus suscripciones
class Usuario {
  final String nombre;
  double saldo;
  final Map<int, double> suscripciones; // fondoId -> monto suscrito

  Usuario({
    required this.nombre,
    required this.saldo,
    Map<int, double>? suscripciones,
  }) : suscripciones = suscripciones ?? {};

  /// Verifica si el usuario tiene saldo suficiente
  bool tieneSaldoSuficiente(double monto) {
    return saldo >= monto;
  }

  /// Verifica si el usuario está suscrito a un fondo
  bool estaSuscrito(int fondoId) {
    return suscripciones.containsKey(fondoId);
  }

  /// Obtiene el monto suscrito a un fondo específico
  double montoSuscrito(int fondoId) {
    return suscripciones[fondoId] ?? 0.0;
  }

  /// Copia el usuario con nuevos valores
  Usuario copyWith({
    String? nombre,
    double? saldo,
    Map<int, double>? suscripciones,
  }) {
    return Usuario(
      nombre: nombre ?? this.nombre,
      saldo: saldo ?? this.saldo,
      suscripciones: suscripciones ?? Map.from(this.suscripciones),
    );
  }
}
