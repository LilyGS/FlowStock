class VentaDetalle {
  // Modelo que representa un Detalle de la Venta
  final int? idDetalle;
  final int idVenta;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  // Constructor de la clase
  VentaDetalle(
      {required this.idDetalle,
      required this.idVenta,
      required this.idProducto,
      required this.cantidad,
      required this.precioUnitario,
      required this.subtotal});

  // Convierte el objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_detalle': idDetalle,
      'id_venta': idVenta,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'subtotal': subtotal
    };
  }

  // Crea una instancia de VentaDetalle a partir de un mapa
  factory VentaDetalle.fromMap(Map<String, dynamic> map) {
    return VentaDetalle(
      idDetalle: map['id_detalle'],
      idVenta: map['id_venta'],
      idProducto: map['id_producto'],
      cantidad: map['cantidad'],
      precioUnitario: map['precio_unitario'],
      subtotal: map['subtotal'],
    );
  }

  // Crea una copia de VentaDetalle actual con la posibilidad de cambiar algunos campos
  VentaDetalle copyWith({int? idVenta}) {
    return VentaDetalle(
      idDetalle: idDetalle,
      idVenta: idVenta ?? this.idVenta,
      idProducto: idProducto,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
    );
  }

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'VentaDetalle{idDetalle: $idDetalle, idVenta: $idVenta, idProducto: $idProducto, cantidad: $cantidad, precioUnitario: $precioUnitario, subtotal: $subtotal}';
  }
}
