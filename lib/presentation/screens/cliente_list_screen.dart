import 'package:flow_stock/data/models/cliente.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/providers/cliente_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/cliente_form_screen.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ClienteProvider>(context, listen: false);
      provider.cargarClientes();
    });
  }

  void _confirmarEliminarCliente(int idCliente) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Cliente'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este cliente?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final provider =
                    Provider.of<ClienteProvider>(context, listen: false);
                await provider.eliminarCliente(idCliente);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente eliminado con éxito.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _activarCliente(int idCliente) async {
    final provider = Provider.of<ClienteProvider>(context, listen: false);
    await provider.activarCliente(idCliente);
    await provider.cargarClientes();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cliente restaurado con éxito.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _editarCliente(Cliente cliente) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteFormScreen(cliente: cliente),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<ClienteProvider>(context, listen: false);
      await provider.cargarClientes();
    }
  }

  Future<void> _showClienteScreen() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClienteFormScreen()));
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<ClienteProvider>(context, listen: false);
      await provider.cargarClientes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(context);
    final clientes = clienteProvider.clientes;
    final isLoading = clienteProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleCliente),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await clienteProvider.cargarClientes();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final cliente = clientes[index];
                      return Card(
                        color: cliente.status == 'inactivo'
                            ? Colors.grey[300]
                            : null,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(cliente.nombre,
                              style: FlowstockTextStyles.listTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cliente.correo,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                cliente.direccion!,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                cliente.telefono!,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                cliente.status,
                                style: FlowstockTextStyles.listSubTitle,
                              )
                            ],
                          ),
                          onTap: () => _editarCliente(cliente),
                          trailing: cliente.status == 'activo'
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.blue),
                                  onPressed: () => _confirmarEliminarCliente(
                                      cliente.idCliente!),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.restore,
                                      color: Colors.orange),
                                  onPressed: () =>
                                      _activarCliente(cliente.idCliente!),
                                ),
                        ),
                      );
                    }, childCount: clientes.length),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showClienteScreen,
        label: const Text(FlowstockConstants.titleNewCliente),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
