class Sucursal {
  // Modelo que representa una Sucursal
  final int? idSucursal;
  final String nombre;
  final String ubicacion;
  final String? telefono;
  final String status;

  // Constructor de la clase
  Sucursal(
      {this.idSucursal,
      required this.nombre,
      required this.ubicacion,
      this.telefono,
      required this.status});

  // Convierte el objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_sucursal': idSucursal,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'telefono': telefono,
      'status': status
    };
  }

  // Crea una instancia de Sucursal a partir de un mapa
  factory Sucursal.fromMap(Map<String, dynamic> map) {
    return Sucursal(
      idSucursal: map['id_sucursal'],
      nombre: map['nombre'],
      ubicacion: map['ubicacion'],
      telefono: map['telefono'],
      status: map['status'],
    );
  }

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'Sucursal{idSucursal: $idSucursal, nombre: $nombre, ubicacion: $ubicacion, telefono: $telefono, status: $status}';
  }
}
