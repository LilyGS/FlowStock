import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';
import 'package:flow_stock/core/database/database_helper.dart';

// Patrón Facade para gestionar operaciones relacionadas con la Venta
class VentaFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Inserta una nueva Venta
  Future<int> insertarVenta(Venta venta) async {
    return await _databaseHelper.insert('venta', venta.toMap());
  }

  // Inserta el detalle de la Venta
  Future<void> insertarDetalleVenta(VentaDetalle detalle) async {
    await _databaseHelper.insert('venta_detalle', detalle.toMap());
  }

  
  // Obtiene la lista de todos las ventas registradas
  Future<List<Venta>> obtenerVentas() async {
    final data = await _databaseHelper.query('venta');
    return data.map((e) => Venta.fromMap(e)).toList();
  }

  // Obtiene la lista del detalle de la venta
  Future<List<VentaDetalle>> obtenerDetallesPorVenta(int idVenta) async {
    final data = await _databaseHelper
        .query('venta_detalle', where: 'id_venta = ?', whereArgs: [idVenta]);
    return data.map((e) => VentaDetalle.fromMap(e)).toList();
  }
}
