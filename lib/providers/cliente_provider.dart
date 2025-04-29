import 'package:flutter/material.dart';
import 'package:flow_stock/pattern/facade/cliente_facade.dart';
import 'package:flow_stock/data/models/cliente.dart';

class ClienteProvider with ChangeNotifier {
  // Instancia del ClienteFacade para interactuar con la base de datos
  final ClienteFacade _facade = ClienteFacade();

  bool isLoading = false;
  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  // Carga todos los clientes desde la base de datos.
  // Mientras se carga, actualiza isLoading y notifica a todos los listeners.
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

  // Agrega un nuevo cliente y recarga la lista de clientes
  Future<void> agregarCliente(Cliente cliente) async {
    await _facade.insertarCliente(cliente);
    await cargarClientes();
  }

  // Actualiza un cliente y recarga la lista de clientes
  Future<void> actualizarCliente(Cliente cliente) async {
    await _facade.actualizarCliente(cliente);
    await cargarClientes();
  }

  // Realiza un borrado lógico de un cliente y recarga la lista
  Future<void> eliminarCliente(int idCliente) async {
    await _facade.eliminarCliente(idCliente);
    await cargarClientes();
  }

  // Activa un cliente previamente inactivo y recarga la lista de clientes
  Future<void> activarCliente(int idCliente) async {
    await _facade.activarCliente(idCliente);
    await cargarClientes();
  }
}
