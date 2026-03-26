/// Modelo para representar un fondo de inversión
class Fondo {
  final int id;
  final String nombre;
  final double montoMinimo;
  final String categoria;

  Fondo({
    required this.id,
    required this.nombre,
    required this.montoMinimo,
    required this.categoria,
  });

  /// Crea una instancia de Fondo desde un Map (útil para JSON)
  factory Fondo.fromJson(Map<String, dynamic> json) {
    return Fondo(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      montoMinimo: (json['montoMinimo'] as num).toDouble(),
      categoria: json['categoria'] as String,
    );
  }

  /// Convierte el Fondo a un Map (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'montoMinimo': montoMinimo,
      'categoria': categoria,
    };
  }
}
