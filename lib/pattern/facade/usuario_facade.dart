import 'package:flow_stock/data/models/usuario.dart';
import 'package:flow_stock/core/database/database_helper.dart';


// Patrón Facade para gestionar operaciones relacionadas con el Usuario
class UsuarioFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Inserta una Sucursal
  Future<void> insertarUsuario(Usuario usuario) async {
    await _databaseHelper.insert('usuario', usuario.toMap());
  }

  // Actualiza un Usuario
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _databaseHelper.update(
        'usuario', usuario.toMap(), 'id_usuario = ?', [usuario.idUsuario]);
  }

  // Borrado lógico
  Future<void> eliminarUsuario(int idUsuario) async {
    await _databaseHelper.updateStatus(
        'usuario', 'id_usuario', idUsuario, 'inactivo');
  }

  // Re-activar usuario
  Future<void> activarUsuario(int idUsuario) async {
    await _databaseHelper.updateStatus(
        'usuario', 'id_usuario', idUsuario, 'activo');
  }

  // Obtiene el usuario de acuerdo al correo y contraseña proporcionada
  Future<Usuario?> loginUsuario(String correo, String contrasena) async {
    final result = await _databaseHelper.query(
      'usuario',
      where: 'correo = ? AND contrasena = ? AND status = ?',
      whereArgs: [correo, contrasena, 'activo'],
    );
    return result.isNotEmpty ? Usuario.fromMap(result.first) : null;
  }

  // Obtiene la lista de los clieusuarios por status
  Future<List<Map<String, dynamic>>> getUsuariosByStatus(String status) async {
    return await _databaseHelper.query('usuario',
        where: 'status = ?', whereArgs: [status], orderBy: 'date DESC');
  }

  // Obtiene la lista de todos los usuarios registrados
  Future<List<Usuario>> obtenerUsuarios() async {
    final data = await _databaseHelper.queryAllRows('usuario');
    return data.map((e) => Usuario.fromMap(e)).toList();
  }
}
