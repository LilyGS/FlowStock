import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/inventario.dart';

class InventarioFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertarInventario(Inventario inventario) async {
    await _databaseHelper.insert('inventario', inventario.toMap());
  }

  Future<void> actualizarInventario(Inventario inventario) async {
    await _databaseHelper.update(
        'inventario',
        inventario.toMap(),
        'id_sucursal = ? AND id_producto = ?',
        [inventario.idSucursal, inventario.idProducto]);
  }

  Future<List<Inventario>> obtenerInventario() async {
    final data = await _databaseHelper
        .query('inventario', where: 'status = ?', whereArgs: ['activo']);
    return data.map((e) => Inventario.fromMap(e)).toList();
  }

  Future<List<Inventario>> obtenerInventarioPorSucursal(int? idSucursal) async {
    // Si no se seleccionó una sucursal, traer todo el inventario
    if (idSucursal == null) {
      final data = await _databaseHelper.query('inventario');
      return data.map((e) => Inventario.fromMap(e)).toList();
    }

    // Si hay sucursal seleccionada, traer solo los registros de esa sucursal
    final data = await _databaseHelper.query(
      'inventario',
      where: 'id_sucursal = ?',
      whereArgs: [idSucursal],
    );

    return data.map((e) => Inventario.fromMap(e)).toList();
  }

  Future<List<Inventario>> consultarInventario(
      {int? idSucursal}) async {
    final db = await _databaseHelper.database;

    final data = await db.rawQuery('''
      SELECT 
        p.nombre AS producto, 
        p.unidad_medida,
        5 as stock_minimo,
        s.nombre AS sucursal, 
        i.cantidad_disponible
      FROM inventario i
      JOIN producto p ON i.id_producto = p.id_producto
      JOIN sucursal s ON i.id_sucursal = s.id_sucursal
      ${idSucursal != null ? 'WHERE i.id_sucursal = ?' : ''}
      ORDER BY s.nombre, p.nombre
    ''', idSucursal != null ? [idSucursal] : []);

    return data.map((e) => Inventario.fromMap(e)).toList();
  }
}
