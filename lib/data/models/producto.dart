class Producto {
  // Modelo que representa un Producto
  final int? idProducto;
  final String nombre;
  final String? descripcion;
  final String? categoria;
  final String? unidadMedida;
  final double precioLista;
  final String status;

 // Constructor de la clase
  Producto({
    this.idProducto,
    required this.nombre,
    this.descripcion,
    this.categoria,
    this.unidadMedida,
    required this.precioLista,
    required this.status,
  });

  // Crea una instancia de Producto a partir de un mapa
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

  // Crea una instancia de VentaDetalle a partir de un mapa
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

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'Producto{idProducto: $idProducto, nombre: $nombre, descripcion: $descripcion, categoria: $categoria, unidadMedida: $unidadMedida, precioLista: $precioLista, status: $status}';
  }
}
