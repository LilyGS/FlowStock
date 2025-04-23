import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/sucursal_facade.dart';
import 'package:flow_stock/data/models/sucursal.dart';

class SucursalProvider with ChangeNotifier {
  final SucursalFacade _facade = SucursalFacade();

  bool isLoading = false;
  List<Sucursal> _sucursales = [];
  List<Sucursal> get sucursales => _sucursales;

  Future<void> cargarSucursales() async {
    isLoading = true;
    notifyListeners();

    try {
      _sucursales = await _facade.obtenerSucursales();
    } catch (e) {
      //  error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarSucursal(Sucursal sucursal) async {
    await _facade.insertarSucursal(sucursal);
    await cargarSucursales();
  }

  Future<void> actualizarSucursal(Sucursal sucursal) async {
    await _facade.actualizarSucursal(sucursal);
    await cargarSucursales();
  }

  Future<void> eliminarSucursal(int idSucursal) async {
    await _facade.eliminarSucursal(idSucursal);
    await cargarSucursales();
  }

  Future<void> activarSucursal(int idSucursal) async {
    await _facade.activarSucursal(idSucursal);
    await cargarSucursales();
  }
}
