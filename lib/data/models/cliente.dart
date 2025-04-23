class Cliente {
  final int? idCliente;
  final String nombre;
  final String correo;
  final String? direccion;
  final String? telefono;
  final String status;

  Cliente(
      {this.idCliente,
      required this.nombre,
      required this.correo,
      this.direccion,
      this.telefono,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'nombre': nombre,
      'correo': correo,
      'direccion': direccion,
      'telefono': telefono,
      'status': status
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['id_cliente'],
      nombre: map['nombre'],
      correo: map['correo'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      status: map['status'],
    );
  }

  Cliente copyWith(
      {int? idCliente,
      String? nombre,
      String? correo,
      String? direccion,
      String? telefono,
      String? status}) {
    return Cliente(
        idCliente: idCliente ?? this.idCliente,
        nombre: nombre ?? this.nombre,
        correo: correo ?? this.correo,
        direccion: direccion ?? this.direccion,
        telefono: telefono ?? this.telefono,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'Cliente{idCliente: $idCliente, nombre: $nombre, correo: $correo, direccion: $direccion, telefono: $telefono,  status: $status}';
  }
}
