import 'package:flow_stock/data/models/cliente.dart';
import 'package:flow_stock/data/models/sucursal.dart';
import 'package:flow_stock/providers/cliente_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flutter/material.dart';

import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/providers/venta_detalle_provider.dart';
import 'package:flow_stock/presentation/widgets/detalle_venta_table.dart';
import 'package:provider/provider.dart';

class VentaDetalleScreen extends StatefulWidget {
  final Venta venta;

  const VentaDetalleScreen({super.key, required this.venta});

  @override
  State<VentaDetalleScreen> createState() => _VentaDetalleScreenState();
}

class _VentaDetalleScreenState extends State<VentaDetalleScreen> {
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDetalles();
  }

  Future<void> _cargarDetalles() async {
    await Provider.of<VentaDetalleProvider>(context, listen: false)
        .cargarDetallesPorVenta(widget.venta.idVenta!);
    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productoProvider = Provider.of<ProductoProvider>(context);
    final ventaDetalleProvider = Provider.of<VentaDetalleProvider>(context);
    final detalles = ventaDetalleProvider.detalles;
    final clienteProvider = Provider.of<ClienteProvider>(context);
    final sucursalProvider = Provider.of<SucursalProvider>(context);

    final cliente = clienteProvider.clientes.firstWhere(
        (c) => c.idCliente == widget.venta.idCliente,
        orElse: () => Cliente(
            nombre: 'Sin cliente', correo: 'Sin correo', status: 'Inactivo'));
    final sucursal = sucursalProvider.sucursales.firstWhere(
        (s) => s.idSucursal == widget.venta.idSucursal,
        orElse: () => Sucursal(
            nombre: 'Desconocida',
            ubicacion: 'Desconocida',
            status: 'Inactivo'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Venta #${widget.venta.idVenta}'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoVenta(sucursal, cliente),
                  const Divider(height: 24),
                  Expanded(
                    child: DetalleVentaTable(
                      detalles: detalles,
                      productos: productoProvider.productos,
                      onDelete: (index) {},
                      editable: false,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoVenta(Sucursal sucursal, Cliente cliente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sucursal: ${widget.venta.idSucursal} - ${sucursal.nombre}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Cliente: ${widget.venta.idCliente?.toString()} - ${cliente.nombre}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Fecha: ${widget.venta.fechaVenta}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Método de pago: ${widget.venta.metodoPago}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Total: \$${widget.venta.total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
