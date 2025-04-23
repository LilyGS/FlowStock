class Producto {
  final int? idProducto;
  final String nombre;
  final String? descripcion;
  final String? categoria;
  final String? unidadMedida;
  final double precioLista;
  final String status;

  Producto({
    this.idProducto,
    required this.nombre,
    this.descripcion,
    this.categoria,
    this.unidadMedida,
    required this.precioLista,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'unidad_medida': unidadMedida,
      'precio_lista': precioLista,
      'status': status,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      idProducto: map['id_producto'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      unidadMedida: map['unidad_medida'],
      precioLista: map['precio_lista'],
      status: map['status'],
    );
  }

  Producto copyWith(
      {int? idProducto,
      String? nombre,
      String? descripcion,
      String? categoria,
      String? unidadMedida,
      double? precioLista,
      String? status}) {
    return Producto(
        idProducto: idProducto ?? this.idProducto,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        categoria: categoria ?? this.categoria,
        unidadMedida: unidadMedida ?? this.unidadMedida,
        precioLista: precioLista ?? this.precioLista,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'Producto{idProducto: $idProducto, nombre: $nombre, descripcion: $descripcion, categoria: $categoria, unidadMedida: $unidadMedida, precioLista: $precioLista, status: $status}';
  }
}
