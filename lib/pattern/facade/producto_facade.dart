import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/producto.dart';

class ProductoFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertarProducto(Producto producto) async {
    await _databaseHelper.insert('producto', producto.toMap());
  }

  Future<void> actualizarProducto(Producto producto) async {
    await _databaseHelper.update(
        'producto', producto.toMap(), 'id_producto = ?', [producto.idProducto]);
  }

  // Borrado lógico
  Future<void> eliminarProducto(int idProducto) async {
    await _databaseHelper.updateStatus(
        'producto', 'id_producto', idProducto, 'inactivo');
  }

  // Activar Producto
  Future<void> activarProducto(int idProducto) async {
    await _databaseHelper.updateStatus(
        'producto', 'id_producto', idProducto, 'activo');
  }

  Future<List<Producto>> obtenerProductos() async {
    final data = await _databaseHelper
        .query('producto', where: 'status = ?', whereArgs: ['activo']);
    return data.map((e) => Producto.fromMap(e)).toList();
  }
}
