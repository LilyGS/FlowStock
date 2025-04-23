class VentaDetalle {
  final int? idDetalle;
  final int idVenta;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  VentaDetalle(
      {required this.idDetalle,
      required this.idVenta,
      required this.idProducto,
      required this.cantidad,
      required this.precioUnitario,
      required this.subtotal});

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

  @override
  String toString() {
    return 'VentaDetalle{idDetalle: $idDetalle, idVenta: $idVenta, idProducto: $idProducto, cantidad: $cantidad, precioUnitario: $precioUnitario, subtotal: $subtotal}';
  }
}
