import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/producto_facade.dart';
import 'package:flow_stock/data/models/producto.dart';

class ProductoProvider with ChangeNotifier {

  // Instancia del ProductoFacade para interactuar con la base de datos
  final ProductoFacade _facade = ProductoFacade();

  bool isLoading = false;
  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  
  // Carga todos los productos.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
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

  // Agrega un nuevo producto y recarga la lista de productos
  Future<void> agregarProducto(Producto producto) async {
    await _facade.insertarProducto(producto);
    await cargarProductos();
  }

  // Actualiza un producto y recarga la lista de productos
  Future<void> actualizarProducto(Producto producto) async {
    await _facade.actualizarProducto(producto);
    await cargarProductos();
  }

  // Elimina un producto y recarga la lista de productos
  Future<void> eliminarProducto(int idProducto) async {
    await _facade.eliminarProducto(idProducto);
    await cargarProductos();
  }

  // Activa un producto previamente inactivo y recarga la lista de productos
  Future<void> activarProducto(int idProducto) async {
    await _facade.activarProducto(idProducto);
    await cargarProductos();
  }
}
