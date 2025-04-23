class Sucursal {
  final int? idSucursal;
  final String nombre;
  final String ubicacion;
  final String? telefono;
  final String status;

  Sucursal(
      {this.idSucursal,
      required this.nombre,
      required this.ubicacion,
      this.telefono,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id_sucursal': idSucursal,
      'nombre': nombre,
      'ubicacion': ubicacion,
      'telefono': telefono,
      'status': status
    };
  }

  factory Sucursal.fromMap(Map<String, dynamic> map) {
    return Sucursal(
      idSucursal: map['id_sucursal'],
      nombre: map['nombre'],
      ubicacion: map['ubicacion'],
      telefono: map['telefono'],
      status: map['status'],
    );
  }

  Sucursal copyWith(
      {int? idSucursal,
      String? nombre,
      String? ubicacion,
      String? telefono,
      String? status}) {
    return Sucursal(
        idSucursal: idSucursal ?? this.idSucursal,
        nombre: nombre ?? this.nombre,
        ubicacion: ubicacion ?? this.ubicacion,
        telefono: telefono ?? this.telefono,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'Sucursal{idSucursal: $idSucursal, nombre: $nombre, ubicacion: $ubicacion, telefono: $telefono, status: $status}';
  }
}
