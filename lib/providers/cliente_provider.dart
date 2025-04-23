import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/cliente_facade.dart';
import 'package:flow_stock/data/models/cliente.dart';

class ClienteProvider with ChangeNotifier {
  final ClienteFacade _facade = ClienteFacade();

  bool isLoading = false;
  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Future<void> cargarClientes() async {
    isLoading = true;
    notifyListeners();

    try {
      _clientes = await _facade.obtenerClientes();
    } catch (e) {
      //  error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarCliente(Cliente cliente) async {
    await _facade.insertarCliente(cliente);
    await cargarClientes();
  }

  Future<void> actualizarCliente(Cliente cliente) async {
    await _facade.actualizarCliente(cliente);
    await cargarClientes();
  }

  Future<void> eliminarCliente(int idCliente) async {
    await _facade.eliminarCliente(idCliente);
    await cargarClientes();
  }

  Future<void> activarCliente(int idCliente) async {
    await _facade.activarCliente(idCliente);
    await cargarClientes();
  }
}
