class Inventario {
  final int idSucursal;
  final int idProducto;
  final int cantidadDisponible;
  final double precioCompra;
  final double precioVenta;
  final DateTime fechaIngreso;

   
  Inventario({
    required this.idSucursal,
    required this.idProducto,
    required this.cantidadDisponible,
    required this.precioCompra,
    required this.precioVenta,
    required this.fechaIngreso,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_sucursal': idSucursal,
      'id_producto': idProducto,
      'cantidad_disponible': cantidadDisponible,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'fecha_ingreso': fechaIngreso.toIso8601String(),
    };
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      idSucursal: map['id_sucursal'],
      idProducto: map['id_producto'],
      cantidadDisponible: map['cantidad_disponible'],
      precioCompra: map['precio_compra'],
      precioVenta: map['precio_venta'],
      fechaIngreso: DateTime.parse(map['fecha_ingreso']),
    );
  }

  Inventario copyWith(
      {int? idSucursal,
      int? idProducto,
      int? cantidadDisponible,
      double? precioCompra,
      double? precioVenta,
      DateTime? fechaIngreso}) {
    return Inventario(
        idSucursal: idSucursal ?? this.idSucursal,
        idProducto: idProducto ?? this.idProducto,
        cantidadDisponible: cantidadDisponible ?? this.cantidadDisponible,
        precioCompra: precioCompra ?? this.precioCompra,
        precioVenta: precioVenta ?? this.precioVenta,
        fechaIngreso: fechaIngreso ?? this.fechaIngreso);
  }

  @override
  String toString() {
    return 'Inventario{idSucursal: $idSucursal, idProducto: $idProducto, cantidadDisponible: $cantidadDisponible, precioCompra: $precioCompra, precioVenta: $precioVenta, fechaIngreso: $fechaIngreso}';
  }
}
