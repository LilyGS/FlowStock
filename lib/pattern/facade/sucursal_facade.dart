import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/sucursal.dart';

class SucursalFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertarSucursal(Sucursal sucursal) async {
    await _databaseHelper.insert('sucursal', sucursal.toMap());
  }

  Future<void> actualizarSucursal(Sucursal sucursal) async {
    await _databaseHelper.update(
        'sucursal', sucursal.toMap(), 'id_sucursal = ?', [sucursal.idSucursal]);
  }

  // Borrado lógico
  Future<void> eliminarSucursal(int idSucursal) async {
    await _databaseHelper.updateStatus(
        'sucursal', 'id_sucursal', idSucursal, 'inactivo');
  }

  // Activar Sucursal
  Future<void> activarSucursal(int idSucursal) async {
    await _databaseHelper.updateStatus(
        'sucursal', 'id_sucursal', idSucursal, 'activo');
  }

  Future<List<Sucursal>> obtenerSucursales() async {
    final data = await _databaseHelper.queryAllRows('sucursal');
    return data.map((e) => Sucursal.fromMap(e)).toList();
  }
}
