import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/cliente.dart';

class ClienteFacade {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Obtener la lista de métodos de pago que están activos en el sistema
  Future<void> insertarCliente(Cliente cliente) async {
    await _databaseHelper.insert('cliente', cliente.toMap());
  }

  Future<void> actualizarCliente(Cliente cliente) async {
    await _databaseHelper.update(
        'cliente', cliente.toMap(), 'id_cliente = ?', [cliente.idCliente]);
  }

  // Borrado lógico
  Future<void> eliminarCliente(int idCliente) async {
    await _databaseHelper.updateStatus(
        'cliente', 'id_cliente', idCliente, 'inactivo');
  }

  // Activar Cliente
  Future<void> activarCliente(int idCliente) async {
    await _databaseHelper.updateStatus(
        'cliente', 'id_cliente', idCliente, 'activo');
  }

  Future<List<Cliente>> obtenerClientes() async {
    final data = await _databaseHelper.queryAllRows('cliente');
    return data.map((e) => Cliente.fromMap(e)).toList();
  }
}
