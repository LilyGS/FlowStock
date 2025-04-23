import 'package:flow_stock/data/models/sucursal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/sucursal_form_screen.dart';

class SucursalListScreen extends StatefulWidget {
  const SucursalListScreen({super.key});

  @override
  State<SucursalListScreen> createState() => _SucursalListScreenState();
}

class _SucursalListScreenState extends State<SucursalListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SucursalProvider>(context, listen: false);
      provider.cargarSucursales();
    });
  }

  void _confirmarEliminarSucursal(int idSucursal) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Sucursal'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta sucursal?'),
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
                    Provider.of<SucursalProvider>(context, listen: false);
                await provider.eliminarSucursal(idSucursal);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sucursal eliminada con éxito.'),
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

  void _activarSucursal(int idSucursal) async {
    final provider = Provider.of<SucursalProvider>(context, listen: false);
    await provider.activarSucursal(idSucursal);
    await provider.cargarSucursales();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sucursal restaurada con éxito.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _editarSucursal(Sucursal sucursal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SucursalFormScreen(sucursal: sucursal),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<SucursalProvider>(context, listen: false);
      await provider.cargarSucursales();
    }
  }

  Future<void> _showSucursalScreen() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SucursalFormScreen()));
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<SucursalProvider>(context, listen: false);
      await provider.cargarSucursales();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sucursalProvider = Provider.of<SucursalProvider>(context);
    final sucursales = sucursalProvider.sucursales;
    final isLoading = sucursalProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleSucursal),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await sucursalProvider.cargarSucursales();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sucursal = sucursales[index];
                      return Card(
                        color: sucursal.status == 'inactivo'
                            ? Colors.grey[300]
                            : null,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(sucursal.nombre,
                              style: FlowstockTextStyles.listTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sucursal.ubicacion,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                sucursal.telefono!,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                sucursal.status,
                                style: FlowstockTextStyles.listSubTitle,
                              )
                            ],
                          ),
                          onTap: () => _editarSucursal(sucursal),
                          trailing: sucursal.status == 'activo'
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.blue),
                                  onPressed: () => _confirmarEliminarSucursal(
                                      sucursal.idSucursal!),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.restore,
                                      color: Colors.orange),
                                  onPressed: () =>
                                      _activarSucursal(sucursal.idSucursal!),
                                ),
                        ),
                      );
                    }, childCount: sucursales.length),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSucursalScreen,
        label: const Text(FlowstockConstants.titleNewSucursal),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
