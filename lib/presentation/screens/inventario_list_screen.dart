import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/providers/inventario_provider.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/data/models/inventario.dart';
import 'package:flow_stock/data/models/producto.dart';
import 'package:flow_stock/data/models/sucursal.dart';
import 'package:flow_stock/presentation/screens/inventario_form_screen.dart';

class InventarioListScreen extends StatefulWidget {
  const InventarioListScreen({super.key});

  @override
  State<InventarioListScreen> createState() => _InventarioListScreenState();
}

class _InventarioListScreenState extends State<InventarioListScreen> {
  int? _sucursalSeleccionada;// null = Todas

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    final context = this.context;
    await Provider.of<InventarioProvider>(context, listen: false)
        .cargarInventarioPorSucursal(idSucursal: _sucursalSeleccionada);
    await Provider.of<ProductoProvider>(context, listen: false)
        .cargarProductos();
    await Provider.of<SucursalProvider>(context, listen: false)
        .cargarSucursales();
  }

  Future<void> _editarInventario(Inventario inventario) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventarioFormScreen(inventario: inventario),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<InventarioProvider>(context, listen: false);
      await provider.cargarInventarioPorSucursal(
          idSucursal: _sucursalSeleccionada);
    }
  }

  Future<void> _showInventarioScreen() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => InventarioFormScreen()));
        
    if (!mounted) return;    
    if (result == true) {
      final provider = Provider.of<InventarioProvider>(context, listen: false);
      await provider.cargarInventarioPorSucursal(
          idSucursal: _sucursalSeleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventarioProvider = Provider.of<InventarioProvider>(context);
    final productoProvider = Provider.of<ProductoProvider>(context);
    final sucursalProvider = Provider.of<SucursalProvider>(context);

    final sucursales = sucursalProvider.sucursales;

    List<Inventario> inventarioFiltrado = _sucursalSeleccionada == null
        ? inventarioProvider.inventario
        : inventarioProvider.inventario
            .where((inv) => inv.idSucursal == _sucursalSeleccionada)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleInventario),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<int?>(
              value: _sucursalSeleccionada,
              decoration: const InputDecoration(
                  labelText: 'Filtrar Sucursal', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(
                  value: -1,
                  child: Text('Todas las sucursales'),
                ),
                ...sucursales.map(
                  (s) => DropdownMenuItem(
                    value: s.idSucursal,
                    child: Text(s.nombre),
                  ),
                )
              ],
              onChanged: (value) async {
                setState(() {
                  _sucursalSeleccionada = value == -1 ? null : value;
                });
                await Provider.of<InventarioProvider>(context, listen: false)
                    .cargarInventarioPorSucursal(
                        idSucursal: _sucursalSeleccionada);
              },
            ),
          ),
          Expanded(
            child: inventarioProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: inventarioFiltrado.length,
                    itemBuilder: (context, index) {
                      final item = inventarioFiltrado[index];
                      final producto = productoProvider.productos.firstWhere(
                        (p) => p.idProducto == item.idProducto,
                        orElse: () => Producto(
                            nombre: 'Desconocido',
                            precioLista: 0,
                            status: 'inactivo'),
                      );
                      final sucursal = sucursales.firstWhere(
                        (s) => s.idSucursal == item.idSucursal,
                        orElse: () => Sucursal(
                            nombre: 'Desconocida',
                            ubicacion: 'Desconocida',
                            status: 'inactivo'),
                      );

                      final bool bajoStock =
                          item.cantidadDisponible < 5; // umbral de ejemplo

                      return Card(
                        margin: const EdgeInsets.all(8),
                        color: bajoStock ? Colors.red.shade50 : null,
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            producto.nombre,
                            style: FlowstockTextStyles.listTitle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sucursal: ${sucursal.nombre}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Cantidad Disponible: ${item.cantidadDisponible}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Precio Compra: \$ ${item.precioCompra.toStringAsFixed(2)}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Precio Venta: \$ ${item.precioVenta.toStringAsFixed(2)}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                              Text(
                                'Fecha Ingreso: ${item.fechaIngreso}',
                                style: FlowstockTextStyles.listSubTitle,
                              ),
                            ],
                          ),
                          onTap: () => _editarInventario(item),
                          trailing: bajoStock
                              ? const Icon(Icons.warning, color: Colors.red)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showInventarioScreen,
        label: const Text(FlowstockConstants.titleNewInventario),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
