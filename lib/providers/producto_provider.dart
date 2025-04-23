import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/producto_facade.dart';
import 'package:flow_stock/data/models/producto.dart';

class ProductoProvider with ChangeNotifier {
  final ProductoFacade _facade = ProductoFacade();

  bool isLoading = false;
  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  Future<void> cargarProductos() async {
    isLoading = true;
    notifyListeners();

    try {
      _productos = await _facade.obtenerProductos();
    } catch (e) {
      //  error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarProducto(Producto producto) async {
    await _facade.insertarProducto(producto);
    await cargarProductos();
  }

  Future<void> actualizarProducto(Producto producto) async {
    await _facade.actualizarProducto(producto);
    await cargarProductos();
  }

  Future<void> eliminarProducto(int idProducto) async {
    await _facade.eliminarProducto(idProducto);
    await cargarProductos();
  }

  Future<void> activarProducto(int idProducto) async {
    await _facade.activarProducto(idProducto);
    await cargarProductos();
  }
}
