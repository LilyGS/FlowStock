import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/producto.dart';

// Patrón Facade para gestionar operaciones relacionadas con el Producto

class ProductoFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Inserta un nuevo Producto
  Future<void> insertarProducto(Producto producto) async {
    await _databaseHelper.insert('producto', producto.toMap());
  }

  // Actualiza un Producto
  Future<void> actualizarProducto(Producto producto) async {
    await _databaseHelper.update(
        'producto', producto.toMap(), 'id_producto = ?', [producto.idProducto]);
  }

  // Borrado lógico del Producto
  Future<void> eliminarProducto(int idProducto) async {
    await _databaseHelper.updateStatus(
        'producto', 'id_producto', idProducto, 'inactivo');
  }

  // Re-activar Producto
  Future<void> activarProducto(int idProducto) async {
    await _databaseHelper.updateStatus(
        'producto', 'id_producto', idProducto, 'activo');
  }

  // Obtiene la lista de todos los productos activos
  Future<List<Producto>> obtenerProductos() async {
    final data = await _databaseHelper
        .query('producto', where: 'status = ?', whereArgs: ['activo']);
    return data.map((e) => Producto.fromMap(e)).toList();
  }
}
