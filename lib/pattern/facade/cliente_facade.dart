import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/cliente.dart';

// Patrón Facade para gestionar operaciones relacionadas con el Cliente

class ClienteFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Inserta un nuevo Cliente
  Future<void> insertarCliente(Cliente cliente) async {
    await _databaseHelper.insert('cliente', cliente.toMap());
  }

  // Actualiza un Cliente
  Future<void> actualizarCliente(Cliente cliente) async {
    await _databaseHelper.update(
        'cliente', cliente.toMap(), 'id_cliente = ?', [cliente.idCliente]);
  }

  // Borrado lógico del Cliente
  Future<void> eliminarCliente(int idCliente) async {
    await _databaseHelper.updateStatus(
        'cliente', 'id_cliente', idCliente, 'inactivo');
  }

  // Re Activar Cliente
  Future<void> activarCliente(int idCliente) async {
    await _databaseHelper.updateStatus(
        'cliente', 'id_cliente', idCliente, 'activo');
  }

  // Obtiene la lista de todos los clientes registrados
  Future<List<Cliente>> obtenerClientes() async {
    final data = await _databaseHelper.queryAllRows('cliente');
    return data.map((e) => Cliente.fromMap(e)).toList();
  }
}
