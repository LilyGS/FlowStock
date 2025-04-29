class Usuario {
  // Modelo que representa un Usuario
  
  final int? idUsuario;
  final String nombre;
  final String correo;
  final String contrasena;
  final String rol;
  final String status;

  // Constructor de la clase
  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.rol,
    required this.status,
  });

  // Convierte el objeto a un mapa
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

  // Crea una instancia de Usuario a partir de un mapa
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

  // Retorna una representación en texto del objeto
  @override
  String toString() {
    return 'Usuario{id: $idUsuario, nombre: $nombre, correo: $correo, contrasena: $contrasena, rol: $rol, status: $status,}';
  }
}
