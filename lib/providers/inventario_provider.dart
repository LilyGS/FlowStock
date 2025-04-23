import 'package:flutter/material.dart';
import 'package:flow_stock/data/models/inventario.dart';
import 'package:flow_stock/pattern/facade/inventario_facade.dart';

class InventarioProvider with ChangeNotifier {
  final InventarioFacade _facade = InventarioFacade();

  List<Inventario> _inventario = [];
  List<Inventario> get inventario => _inventario;

  bool isLoading = false;


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

  Future<void> cargarInventarioPorSucursal({int? idSucursal}) async {
    isLoading = true;
    notifyListeners();

    _inventario =
        await InventarioFacade().obtenerInventarioPorSucursal(idSucursal);

    isLoading = false;
    notifyListeners();
  }

  Future<void> agregarInventario(Inventario inventario) async {
    await _facade.insertarInventario(inventario);
    await cargarInventario();
    await cargarInventarioPorSucursal(idSucursal: inventario.idSucursal);
  }

  Future<void> actualizarInventario(Inventario inventario) async {
    await _facade.actualizarInventario(inventario);
    await cargarInventario();
    await cargarInventarioPorSucursal(idSucursal: inventario.idSucursal);
  }

  Inventario? buscarInventario(int idSucursal, int idProducto) {
    return _inventario.firstWhere(
      (inv) => inv.idSucursal == idSucursal && inv.idProducto == idProducto,
      /* orElse: () => null,*/
    );
  }
}
