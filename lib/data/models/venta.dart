class Venta {
  final int? idVenta;
  final DateTime fechaVenta;
  final int idSucursal;
  final int? idCliente; // NULL si la venta es sin cliente
  final String metodoPago;
  final double total;
  final String status;

  Venta({
    this.idVenta,
    required this.fechaVenta,
    required this.idSucursal,
    this.idCliente,
    required this.metodoPago,
    required this.total,
    required this.status
  });

  Map<String, dynamic> toMap() {
    return {
      'id_venta': idVenta,
      'fecha_venta': fechaVenta.toIso8601String(),
      'id_sucursal': idSucursal,
      'id_cliente': idCliente,
      'metodo_pago': metodoPago,
      'total': total,
      'status': status,
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      idVenta: map['id_venta'],
      fechaVenta: DateTime.parse(map['fecha_venta']),  
      idSucursal: map['id_sucursal'],
      idCliente: map['id_cliente'],
      metodoPago: map['metodo_pago'],
      total: map['total'],
      status: map['status'],
    );
  }

  Venta copyWith(
      {int? idVenta,
      DateTime? fechaVenta,
      int? idSucursal,
      int? idCliente,
      String? metodoPago,
      double? total,
      String? status
      }) {
    return Venta(
        idVenta: idVenta ?? this.idVenta,
        fechaVenta: fechaVenta ?? this.fechaVenta,
        idSucursal: idSucursal ?? this.idSucursal,
        idCliente: idCliente ?? this.idCliente,
        metodoPago: metodoPago ?? this.metodoPago,
        total: total ?? this.total,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'Venta{idVenta: $idVenta, fechaVenta: $fechaVenta, idSucursal: $idSucursal, idCliente: $idCliente, metodoPago: $metodoPago, total: $total, status: $status}';
  }
}
