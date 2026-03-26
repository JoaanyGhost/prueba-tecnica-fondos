/// Tipo de transacción
enum TipoTransaccion {
  suscripcion,
  cancelacion,
}

/// Método de notificación seleccionado
enum MetodoNotificacion {
  email,
  sms,
}

/// Modelo para representar una transacción (suscripción o cancelación)
class Transaccion {
  final String id;
  final int fondoId;
  final String nombreFondo;
  final TipoTransaccion tipo;
  final double monto;
  final DateTime fecha;
  final MetodoNotificacion? metodoNotificacion;

  Transaccion({
    required this.id,
    required this.fondoId,
    required this.nombreFondo,
    required this.tipo,
    required this.monto,
    required this.fecha,
    this.metodoNotificacion,
  });

  /// Crea una instancia de Transacción desde un Map
  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      id: json['id'] as String,
      fondoId: json['fondoId'] as int,
      nombreFondo: json['nombreFondo'] as String,
      tipo: TipoTransaccion.values.firstWhere(
        (e) => e.name == json['tipo'],
      ),
      monto: (json['monto'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
      metodoNotificacion: json['metodoNotificacion'] != null
          ? MetodoNotificacion.values.firstWhere(
              (e) => e.name == json['metodoNotificacion'],
            )
          : null,
    );
  }

  /// Convierte la Transacción a un Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fondoId': fondoId,
      'nombreFondo': nombreFondo,
      'tipo': tipo.name,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'metodoNotificacion': metodoNotificacion?.name,
    };
  }

  /// Retorna un string legible del tipo de transacción
  String get tipoTexto {
    return tipo == TipoTransaccion.suscripcion ? 'Suscripción' : 'Cancelación';
  }
}
