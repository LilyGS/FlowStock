import 'package:flow_stock/presentation/screens/venta_detalle_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/presentation/screens/venta_form_screen.dart';

import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/sucursal.dart';
import 'package:flow_stock/data/models/cliente.dart';

import 'package:flow_stock/providers/venta_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/providers/cliente_provider.dart';

class VentaListScreen extends StatefulWidget {
  const VentaListScreen({super.key});

  @override
  State<VentaListScreen> createState() => _VentaListScreenState();
}

class _VentaListScreenState extends State<VentaListScreen> {
  int? _sucursalSeleccionada;
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    final context = this.context;
    await Provider.of<VentaProvider>(context, listen: false).cargarVentas();
    await Provider.of<SucursalProvider>(context, listen: false)
        .cargarSucursales();
    await Provider.of<ClienteProvider>(context, listen: false).cargarClientes();
  }

  Future<void> _showVentaScreen() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => VentaFormScreen()));
    if (!mounted) return;
    if (result == true) {
      final provider = Provider.of<VentaProvider>(context, listen: false);
      await provider.cargarVentas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ventaProvider = Provider.of<VentaProvider>(context);
    final sucursalProvider = Provider.of<SucursalProvider>(context);
    final clienteProvider = Provider.of<ClienteProvider>(context);

    final sucursales = sucursalProvider.sucursales;
    final clientes = clienteProvider.clientes;

    List<Venta> ventasFiltradas = ventaProvider.ventas;

    if (_sucursalSeleccionada != null) {
      ventasFiltradas = ventasFiltradas
          .where((v) => v.idSucursal == _sucursalSeleccionada)
          .toList();
    }

    if (_fechaSeleccionada != null) {
      ventasFiltradas = ventasFiltradas
          .where((v) =>
              DateFormat('yyyy-MM-dd').format(v.fechaVenta) ==
              DateFormat('yyyy-MM-dd').format(_fechaSeleccionada!))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleVenta),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int?>(
                    value: _sucursalSeleccionada,
                    decoration: const InputDecoration(
                        labelText: 'Filtrar por sucursal',
                        border: OutlineInputBorder()),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todas las sucursales'),
                      ),
                      ...sucursales.map(
                        (s) => DropdownMenuItem(
                          value: s.idSucursal,
                          child: Text(s.nombre),
                        ),
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sucursalSeleccionada = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    child: Row(
                      children: [
                        const Text("Fecha: "),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(_fechaSeleccionada == null
                              ? 'Todas'
                              : DateFormat('yyyy-MM-dd')
                                  .format(_fechaSeleccionada!)),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _fechaSeleccionada = picked;
                              });
                            }
                          },
                        ),
                        if (_fechaSeleccionada != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _fechaSeleccionada = null;
                              });
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ventaProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ventasFiltradas.isEmpty
                      ? const Center(child: Text('No hay ventas registradas.'))
                      : ListView.builder(
                          itemCount: ventasFiltradas.length,
                          itemBuilder: (context, index) {
                            final venta = ventasFiltradas[index];
                            final sucursal = sucursales.firstWhere(
                              (s) => s.idSucursal == venta.idSucursal,
                              orElse: () => Sucursal(
                                nombre: 'Desconocida',
                                ubicacion: '',
                                status: 'inactivo',
                              ),
                            );
                            final cliente = clientes.firstWhere(
                              (c) => c.idCliente == venta.idCliente,
                              orElse: () => Cliente(
                                idCliente: 0,
                                nombre: 'Sin cliente',
                                correo: 'Sin correo',
                                status: 'inactivo',
                              ),
                            );

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                    'Id: ${venta.idVenta} - Total Venta: \$${venta.total.toStringAsFixed(2)}',
                                    style: FlowstockTextStyles.listTitle),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sucursal: ${sucursal.nombre}',
                                        style:
                                            FlowstockTextStyles.listSubTitle),
                                    Text('Cliente: ${cliente.nombre}',
                                        style:
                                            FlowstockTextStyles.listSubTitle),
                                    Text('Método Pago: ${venta.metodoPago}',
                                        style:
                                            FlowstockTextStyles.listSubTitle),
                                    Text(
                                        'Fecha venta: ${DateFormat('yyyy-MM-dd').format(venta.fechaVenta)}',
                                        style:
                                            FlowstockTextStyles.listSubTitle),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VentaDetalleScreen(venta: venta),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showVentaScreen,
        label: const Text(FlowstockConstants.titleNewVenta),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
