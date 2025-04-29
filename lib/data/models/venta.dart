class Venta {
  // Modelo que representa una Venta
  final int? idVenta;
  final DateTime fechaVenta;
  final int idSucursal;
  final int? idCliente; // NULL si la venta es sin cliente
  final String metodoPago;
  final double total;
  final String status;
  
  // Constructor de la clase
  Venta(
      {this.idVenta,
      required this.fechaVenta,
      required this.idSucursal,
      this.idCliente,
      required this.metodoPago,
      required this.total,
      required this.status});

  // Convierte el objeto a un mapa
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

  // Crea una instancia de Venta a partir de un mapa
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

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'Venta{idVenta: $idVenta, fechaVenta: $fechaVenta, idSucursal: $idSucursal, idCliente: $idCliente, metodoPago: $metodoPago, total: $total, status: $status}';
  }
}
