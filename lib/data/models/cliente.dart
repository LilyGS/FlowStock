class Cliente {
  // Modelo que representa un Cliente
  final int? idCliente;
  final String nombre;
  final String correo;
  final String? direccion;
  final String? telefono;
  final String status;

  // Constructor de la clase
  Cliente(
      {this.idCliente,
      required this.nombre,
      required this.correo,
      this.direccion,
      this.telefono,
      required this.status});

  // Convierte el objeto a un mapa
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

  // Crea una instancia de Cliente a partir de un mapa
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

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'Cliente{idCliente: $idCliente, nombre: $nombre, correo: $correo, direccion: $direccion, telefono: $telefono,  status: $status}';
  }
}
