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
                  _buildInfoVenta(),
                  const Divider(height: 24),
                  Expanded(
                    child: DetalleVentaTable(
                      detalles: detalles,
                      productos: productoProvider.productos,
                      // No mostramos botón de eliminar en el detalle
                      onDelete: (index) {},
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoVenta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sucursal: ${widget.venta.idSucursal}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'Cliente: ${widget.venta.idCliente?.toString() ?? 'Sin cliente'}',
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
