import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/venta_facade.dart';
import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';

class VentaProvider with ChangeNotifier {
  final VentaFacade _facade = VentaFacade();

  bool isLoading = false;
  List<Venta> _ventas = [];
  List<Venta> get ventas => _ventas;

  Future<void> cargarVentas() async {
    isLoading = true;
    notifyListeners();

    try {
      _ventas = await _facade.obtenerVentas();
    } catch (e) {
      //  error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarVenta(Venta venta, List<VentaDetalle> detalles) async {
    final int idVenta = await _facade.insertarVenta(venta);
    for (var detalle in detalles) {
      await _facade.insertarDetalleVenta(detalle.copyWith(idVenta: idVenta));
    }
    await cargarVentas();
  }
}
