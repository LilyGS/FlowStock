import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/sucursal_facade.dart';
import 'package:flow_stock/data/models/sucursal.dart';

class SucursalProvider with ChangeNotifier {
  
  // Instancia de SucursalFacade para interactuar con la base de datos
  final SucursalFacade _facade = SucursalFacade();

  bool isLoading = false;
  List<Sucursal> _sucursales = [];
  List<Sucursal> get sucursales => _sucursales;


  // Carga todas las sucursales.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
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


  // Agrega una nueva sucursal y recarga la lista de sucursales
  Future<void> agregarSucursal(Sucursal sucursal) async {
    await _facade.insertarSucursal(sucursal);
    await cargarSucursales();
  }

  // Actualiza una sucursal y recarga la lista de sucursales
  Future<void> actualizarSucursal(Sucursal sucursal) async {
    await _facade.actualizarSucursal(sucursal);
    await cargarSucursales();
  }

  // Realiza un borrado lógico de una sucursal y recarga la lista de sucursales
  Future<void> eliminarSucursal(int idSucursal) async {
    await _facade.eliminarSucursal(idSucursal);
    await cargarSucursales();
  }

  // Activa una sucursal previamente inactiva y recarga la lista de sucursales
  Future<void> activarSucursal(int idSucursal) async {
    await _facade.activarSucursal(idSucursal);
    await cargarSucursales();
  }
}
