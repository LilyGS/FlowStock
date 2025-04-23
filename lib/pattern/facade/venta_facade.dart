import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';
import 'package:flow_stock/core/database/database_helper.dart';

class VentaFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertarVenta(Venta venta) async {
    return await _databaseHelper.insert('venta', venta.toMap());
  }

  Future<void> insertarDetalleVenta(VentaDetalle detalle) async {
    await _databaseHelper.insert('venta_detalle', detalle.toMap());
  }

  Future<List<Venta>> obtenerVentas() async {
    final data = await _databaseHelper.query('venta');
    return data.map((e) => Venta.fromMap(e)).toList();
  }

  Future<List<VentaDetalle>> obtenerDetallesPorVenta(int idVenta) async {
    final data = await _databaseHelper
        .query('venta_detalle', where: 'id_venta = ?', whereArgs: [idVenta]);
    return data.map((e) => VentaDetalle.fromMap(e)).toList();
  }
}
