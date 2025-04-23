import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flow_stock/data/models/producto.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/producto_form_screen.dart';

class ProductoListScreen extends StatefulWidget {
  const ProductoListScreen({super.key});

  @override
  State<ProductoListScreen> createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<ProductoListScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: FlowstockConstants.currencySymbol,
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductoProvider>(context, listen: false);
      provider.cargarProductos();
    });
  }

  void _confirmarEliminarProducto(int idProducto) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este producto?'),
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
                    Provider.of<ProductoProvider>(context, listen: false);
                await provider.eliminarProducto(idProducto);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto eliminado con éxito.'),
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

  Future<void> _editarProducto(Producto producto) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductoFormScreen(producto: producto),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<ProductoProvider>(context, listen: false);
      await provider.cargarProductos();
    }
  }

  Future<void> _showProductoScreen() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductoFormScreen()));
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<ProductoProvider>(context, listen: false);
      await provider.cargarProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productoProvider = Provider.of<ProductoProvider>(context);
    final productos = productoProvider.productos;
    final isLoading = productoProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleProducto),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await productoProvider.cargarProductos();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final producto = productos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(producto.nombre,
                              style: FlowstockTextStyles.listTitle),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.descripcion!,
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Categoría: ${producto.categoria!}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Unidad Medida: ${producto.unidadMedida!}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Precio Lista: ${_currencyFormat.format(producto.precioLista)}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                            ],
                          ),
                          onTap: () => _editarProducto(producto),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blue),
                            onPressed: () => _confirmarEliminarProducto(
                                producto.idProducto!),
                          ),
                        ),
                      );
                    }, childCount: productos.length),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showProductoScreen,
        label: const Text(FlowstockConstants.titleNewProducto),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
