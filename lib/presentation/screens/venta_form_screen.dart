import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flow_stock/data/models/inventario.dart';
import 'package:flow_stock/data/models/venta.dart';
import 'package:flow_stock/data/models/venta_detalle.dart';
import 'package:flow_stock/data/models/producto.dart';
import 'package:flow_stock/providers/cliente_provider.dart';
import 'package:flow_stock/providers/inventario_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/providers/venta_provider.dart';
import 'package:flow_stock/presentation/widgets/forma_pago_modal.dart';
import 'package:flow_stock/presentation/widgets/detalle_venta_table.dart';

class VentaFormScreen extends StatefulWidget {
  const VentaFormScreen({super.key});

  @override
  State<VentaFormScreen> createState() => _VentaFormScreenState();
}

class _VentaFormScreenState extends State<VentaFormScreen> {
  final _precioController = TextEditingController(text: '0.00');
  final _stockController = TextEditingController(text: '0');
  final _cantidadController = TextEditingController();

  int? _sucursalId;
  int? _clienteId;
  String? _metodoPago;
  Producto? _productoSel;
  int _cantidad = 1;
  double? _precioVenta;
  int? _stockDisponible;

  final List<VentaDetalle> _detalles = [];
  bool _isProcessing = false;

  double get _total => _detalles.fold(0, (sum, d) => sum + d.subtotal);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sucursales =
          Provider.of<SucursalProvider>(context, listen: false).sucursales;
      if (sucursales.isNotEmpty) {
        setState(() {
          _sucursalId = sucursales.first.idSucursal;
        });
        Provider.of<InventarioProvider>(context, listen: false)
            .cargarInventarioPorSucursal(idSucursal: _sucursalId);
      }
    });
  }

  @override
  void dispose() {
    _precioController.dispose();
    _stockController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _agregarDetalle() async {
    if (_productoSel == null) return;
    // obtener inventario para precio
    final invProv = Provider.of<InventarioProvider>(context, listen: false);
    final inv = invProv.inventario.firstWhere(
      (i) =>
          i.idSucursal == _sucursalId &&
          i.idProducto == _productoSel!.idProducto,
      orElse: () => Inventario(
          idSucursal: _sucursalId!,
          idProducto: _productoSel!.idProducto!,
          cantidadDisponible: 0,
          precioCompra: 0.0,
          precioVenta: 0.0,
          fechaIngreso: DateTime.now()),
    );

    if (inv.cantidadDisponible <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto sin stock en esta sucursal')),
      );
      return;
    }

    if (_cantidad > inv.cantidadDisponible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad excede stock')),
      );
      return;
    }

    setState(() {
      _detalles.add(VentaDetalle(
        idDetalle: null,
        idVenta: 0,
        idProducto: _productoSel!.idProducto!,
        cantidad: _cantidad,
        precioUnitario: inv.precioVenta,
        subtotal: inv.precioVenta * _cantidad,
      ));
    });
  }

  Future<void> _guardarVenta() async {
    if (_sucursalId == null || _detalles.isEmpty || _metodoPago == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor completa los campos requeridos (Sucursal, Método pago o Detalles de la venta)')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final venta = Venta(
        idVenta: null,
        fechaVenta: DateTime.now(),
        idSucursal: _sucursalId!,
        idCliente: _clienteId,
        metodoPago: _metodoPago!,
        total: _total,
        status: 'activo',
      );
      await Provider.of<VentaProvider>(context, listen: false)
          .agregarVenta(venta, _detalles);

      final invProv = Provider.of<InventarioProvider>(context, listen: false);
      for (var detalle in _detalles) {
        final inventario = invProv.inventario.firstWhere((inv) =>
            inv.idSucursal == _sucursalId &&
            inv.idProducto == detalle.idProducto);

        final inventarioActualizado = inventario.copyWith(
          cantidadDisponible: inventario.cantidadDisponible - detalle.cantidad,
        );

        await invProv.actualizarInventario(inventarioActualizado);
      }
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pago registrado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(FlowstockConstants.errorGeneral),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sucProv = Provider.of<SucursalProvider>(context);
    final cliProv = Provider.of<ClienteProvider>(context);
    final prodProv = Provider.of<ProductoProvider>(context);
    final invProv = Provider.of<InventarioProvider>(context);

    final disponibles = (_sucursalId == null)
        ? <Producto>[]
        : invProv.inventario
            .where(
                (i) => i.idSucursal == _sucursalId && i.cantidadDisponible > 0)
            .map((i) => prodProv.productos
                .firstWhere((p) => p.idProducto == i.idProducto))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text(FlowstockConstants.titleNewVenta)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                  labelText: 'Sucursal', border: OutlineInputBorder()),
              items: sucProv.sucursales
                  .map((s) => DropdownMenuItem(
                        value: s.idSucursal,
                        child: Text(s.nombre),
                      ))
                  .toList(),
              onChanged: _detalles.isEmpty
                  ? (value) async {
                      if (value == null) return;
                      await Provider.of<InventarioProvider>(context,
                              listen: false)
                          .cargarInventarioPorSucursal(idSucursal: value);
                      setState(() {
                        _sucursalId = value;
                        _productoSel = null;
                        _precioVenta = null;
                        _stockDisponible = null;
                        _cantidad = 1;
                      });
                    }
                  : null,
              value: _sucursalId,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                  labelText: 'Cliente (opcional)',
                  border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('Sin cliente')),
                ...cliProv.clientes.map((c) => DropdownMenuItem(
                      value: c.idCliente,
                      child: Text(c.nombre),
                    )),
              ],
              onChanged: (value) => setState(() => _clienteId = value),
              value: _clienteId,
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Producto>(
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                    ),
                    items: disponibles
                        .map((p) {
                          final inv = invProv.inventario.firstWhere((i) =>
                              i.idProducto == p.idProducto &&
                              i.idSucursal == _sucursalId);

                          return DropdownMenuItem(
                            value: p,
                            child: Text(
                                '${p.nombre} (Disp: ${inv.cantidadDisponible})'),
                          );
                        })
                        .whereType<DropdownMenuItem<Producto>>()
                        .toList(),
                    onChanged: (p) {
                      final inventario = invProv.inventario.firstWhere((i) =>
                          i.idProducto == p!.idProducto &&
                          i.idSucursal == _sucursalId);

                      setState(() {
                        _productoSel = p;
                        _cantidad = 1;
                        _precioVenta = inventario.precioVenta;
                        _stockDisponible = inventario.cantidadDisponible;

                        _precioController.text =
                            _precioVenta!.toStringAsFixed(2);
                        _stockController.text = _stockDisponible.toString();
                        _cantidadController.text = _cantidad.toString();
                      });
                    },
                    value: _productoSel,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Disponibles',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la cantidad';
                      }
                      return null;
                    },
                    initialValue: '1',
                    onChanged: (v) => _cantidad = int.tryParse(v) ?? 1,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _productoSel == null ? null : _agregarDetalle,
                  child: const Text('Agregar'),
                ),
              ],
            ),
            const Divider(height: 24),
            DetalleVentaTable(
              detalles: _detalles,
              productos: prodProv.productos,
              onDelete: (index) {
                setState(() {
                  _detalles.removeAt(index);
                });
              },
            ),
            const Divider(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: Text(_metodoPago ?? 'Seleccionar forma de pago',
                  style: FlowstockTextStyles.buttonAction),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final m = await seleccionarMetodoPago(context, _total);
                if (m != null) setState(() => _metodoPago = m);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _guardarVenta,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              //    color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.save),
                              SizedBox(width: 8),
                              Text(
                                FlowstockConstants.titleSave,
                                style: FlowstockTextStyles.buttonAction,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text(FlowstockConstants.titleCancel,
                      style: FlowstockTextStyles.buttonAction),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
