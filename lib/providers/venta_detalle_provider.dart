
import 'package:flow_stock/pattern/facade/venta_facade.dart';

import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';


class VentaDetalleProvider with ChangeNotifier {

  final VentaFacade _facade = VentaFacade();


  List<VentaDetalle> _detalles = [];
  List<VentaDetalle> get detalles => _detalles;


 Future<void> cargarDetallesPorVenta(int idVenta) async {
    final datos = await _facade.obtenerDetallesPorVenta(idVenta);
    _detalles = datos;
    notifyListeners();
  }
  
 Future<List<VentaDetalle>> obtenerDetallesPorVenta(int idVenta) {
    return _facade.obtenerDetallesPorVenta(idVenta);
  }

  void agregarDetalle(VentaDetalle detalle) {
    _detalles.add(detalle);
    notifyListeners();
  }

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
