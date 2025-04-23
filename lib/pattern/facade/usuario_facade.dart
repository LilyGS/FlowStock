import 'package:flow_stock/data/models/usuario.dart';
import 'package:flow_stock/core/database/database_helper.dart';

class UsuarioFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertarUsuario(Usuario usuario) async {
    await _databaseHelper.insert('usuario', usuario.toMap());
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _databaseHelper.update(
        'usuario', usuario.toMap(), 'id_usuario = ?', [usuario.idUsuario]);
  }

  // Borrado lógico
  Future<void> eliminarUsuario(int idUsuario) async {
    await _databaseHelper.updateStatus(
        'usuario', 'id_usuario', idUsuario, 'inactivo');
  }

  // Activar usuario
  Future<void> activarUsuario(int idUsuario) async {
    await _databaseHelper.updateStatus(
        'usuario', 'id_usuario', idUsuario, 'activo');
  }

  Future<Usuario?> loginUsuario(String correo, String contrasena) async {
    final result = await _databaseHelper.query(
      'usuario',
      where: 'correo = ? AND contrasena = ? AND status = ?',
      whereArgs: [correo, contrasena, 'activo'],
    );
    return result.isNotEmpty ? Usuario.fromMap(result.first) : null;
  }

  Future<List<Map<String, dynamic>>> getUsuariosByStatus(String status) async {
    return await _databaseHelper.query('usuario',
        where: 'status = ?', whereArgs: [status], orderBy: 'date DESC');
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    final data = await _databaseHelper.queryAllRows('usuario');
    return data.map((e) => Usuario.fromMap(e)).toList();
  }
}
