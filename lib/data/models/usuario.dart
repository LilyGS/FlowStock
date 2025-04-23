class Usuario {
  final int? idUsuario;
  final String nombre;
  final String correo;
  final String contrasena;
  final String rol;
  final String status;

  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.rol,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol,
      'status': status,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nombre: map['nombre'],
      correo: map['correo'],
      contrasena: map['contrasena'],
      rol: map['rol'],
      status: map['status'],
    );
  }

  Usuario copyWith({
    int? idUsuario,
    String? nombre,
    String? correo,
    String? contrasena,
    String? rol,
    String? status,
  }) {
    return Usuario(
        idUsuario: idUsuario ?? this.idUsuario,
        nombre: nombre ?? this.nombre,
        correo: correo ?? this.correo,
        contrasena: contrasena ?? this.contrasena,
        rol: rol ?? this.rol,
        status: status ?? this.status);
  }

  @override
  String toString() {
    return 'Usuario{id: $idUsuario, nombre: $nombre, correo: $correo, contrasena: $contrasena, rol: $rol, status: $status,}';
  }
}
