import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/venta_facade.dart';
import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';

class VentaProvider with ChangeNotifier {

  // Instancia de VentaFacade para interactuar con la base de datos
  final VentaFacade _facade = VentaFacade();

  bool isLoading = false;
  List<Venta> _ventas = [];
  List<Venta> get ventas => _ventas;

  // Carga todas las ventas.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
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

  // Agrega una nueva venta y recarga la lista de ventas
  Future<void> agregarVenta(Venta venta, List<VentaDetalle> detalles) async {
    final int idVenta = await _facade.insertarVenta(venta);
    for (var detalle in detalles) {
      await _facade.insertarDetalleVenta(detalle.copyWith(idVenta: idVenta));
    }
    await cargarVentas();
  }
}
