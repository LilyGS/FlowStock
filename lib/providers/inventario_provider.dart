import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/inventario.dart';
import 'package:flow_stock/pattern/facade/inventario_facade.dart';

class InventarioProvider with ChangeNotifier {
  // Instancia del InventarioFacade para interactuar con la base de datos
  final InventarioFacade _facade = InventarioFacade();

  List<Inventario> _inventario = [];
  List<Inventario> get inventario => _inventario;

  bool isLoading = false;

  // Carga todos los inventarios.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
  Future<void> cargarInventario() async {
    isLoading = true;
    notifyListeners();

    try {
      _inventario = await _facade.obtenerInventario();
    } catch (e) {
      // error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Carga el inventario de la sucursal seleccionada
  Future<void> cargarInventarioPorSucursal({int? idSucursal}) async {
    isLoading = true;
    notifyListeners();

    _inventario =
        await InventarioFacade().obtenerInventarioPorSucursal(idSucursal);

    isLoading = false;
    notifyListeners();
  }

  // Agrega un nuevo inventario y recarga la lista de inventarios
  Future<void> agregarInventario(Inventario inventario) async {
    await _facade.insertarInventario(inventario);
    await cargarInventario();
    await cargarInventarioPorSucursal(idSucursal: inventario.idSucursal);
  }

  // Actualiza un inventario y recarga la lista de inventarios
  Future<void> actualizarInventario(Inventario inventario) async {
    await _facade.actualizarInventario(inventario);
    await cargarInventario();
    await cargarInventarioPorSucursal(idSucursal: inventario.idSucursal);
  }
}
