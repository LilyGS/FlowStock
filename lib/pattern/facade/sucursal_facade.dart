import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/sucursal.dart';

// Patrón Facade para gestionar operaciones relacionadas con la Sucursal
class SucursalFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertarSucursal(Sucursal sucursal) async {
    await _databaseHelper.insert('sucursal', sucursal.toMap());
  }

  // Actualiza una Sucursal
  Future<void> actualizarSucursal(Sucursal sucursal) async {
    await _databaseHelper.update(
        'sucursal', sucursal.toMap(), 'id_sucursal = ?', [sucursal.idSucursal]);
  }

  // Borrado lógico de la Sucursal
  Future<void> eliminarSucursal(int idSucursal) async {
    await _databaseHelper.updateStatus(
        'sucursal', 'id_sucursal', idSucursal, 'inactivo');
  }

  // Re-activar Sucursal
  Future<void> activarSucursal(int idSucursal) async {
    await _databaseHelper.updateStatus(
        'sucursal', 'id_sucursal', idSucursal, 'activo');
  }

  // Obtiene la lista de todos las Sucursales registrados
  Future<List<Sucursal>> obtenerSucursales() async {
    final data = await _databaseHelper.queryAllRows('sucursal');
    return data.map((e) => Sucursal.fromMap(e)).toList();
  }
}
