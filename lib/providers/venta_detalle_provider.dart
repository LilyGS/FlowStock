import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';
import 'package:flow_stock/pattern/facade/venta_facade.dart';

class VentaDetalleProvider with ChangeNotifier {
  // Instancia de VentaFacade para interactuar con la base de datos
  final VentaFacade _facade = VentaFacade();

  List<VentaDetalle> _detalles = [];
  List<VentaDetalle> get detalles => _detalles;

  // Carga el detalle de la venta.
  // Mientras se carga, notifica a todos los listeners.
  Future<void> cargarDetallesPorVenta(int idVenta) async {
    final datos = await _facade.obtenerDetallesPorVenta(idVenta);
    _detalles = datos;
    notifyListeners();
  }

  Future<List<VentaDetalle>> obtenerDetallesPorVenta(int idVenta) {
    return _facade.obtenerDetallesPorVenta(idVenta);
  }

  // Agrega el detalle de la venta y recarga el detalle de la venta
  void agregarDetalle(VentaDetalle detalle) {
    _detalles.add(detalle);
    notifyListeners();
  }

  // Elimina el detalle de la venta
  void eliminarDetalle(int index) {
    _detalles.removeAt(index);
    notifyListeners();
  }

  double get total => _detalles.fold(0, (sum, d) => sum + d.subtotal);

  void limpiar() {
    _detalles.clear();
    notifyListeners();
  }
}
