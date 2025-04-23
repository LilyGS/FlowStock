import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/providers/inventario_provider.dart';
import 'package:flow_stock/data/models/inventario.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';

class InventarioFormScreen extends StatefulWidget {
  final Inventario? inventario;
  const InventarioFormScreen({super.key, this.inventario});

  @override
  State<InventarioFormScreen> createState() => _InventarioFormScreenState();
}

class _InventarioFormScreenState extends State<InventarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  int? idSucursal;
  int? idProducto;
  late DateTime fechaIngreso;

  final _cantidadController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _fechaController = TextEditingController();
  final DateFormat _formatoFecha = DateFormat('yyyy-MM-dd');

  Inventario? inventario;
  @override
  void initState() {
    super.initState();

    if (widget.inventario != null) {
      final inv = widget.inventario!;
      idSucursal = inv.idSucursal;
      idProducto = inv.idProducto;
      _cantidadController.text = inv.cantidadDisponible.toString();
      _precioCompraController.text = inv.precioCompra.toStringAsFixed(2);
      _precioVentaController.text = inv.precioVenta.toStringAsFixed(2);
      fechaIngreso = inv.fechaIngreso;
    } else {
      fechaIngreso = DateTime.now();
    }
    _fechaController.text = _formatoFecha.format(fechaIngreso);
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _guardarInventario() async {
    if (_formKey.currentState!.validate() &&
        idSucursal != null &&
        idProducto != null) {
      final nuevo = Inventario(
        idSucursal: idSucursal!,
        idProducto: idProducto!,
        cantidadDisponible: int.parse(_cantidadController.text),
        precioCompra: double.parse(_precioCompraController.text),
        precioVenta: double.parse(_precioVentaController.text),
        fechaIngreso: fechaIngreso,
      );

      final provider = Provider.of<InventarioProvider>(context, listen: false);

      if (widget.inventario == null) {
        await provider.agregarInventario(nuevo);
      } else {
        await provider.actualizarInventario(nuevo);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sucursales = Provider.of<SucursalProvider>(context).sucursales;
    final productos = Provider.of<ProductoProvider>(context).productos;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inventario == null
            ? FlowstockConstants.titleNewInventario
            : FlowstockConstants.titleEditInventario),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: idSucursal,
                items: sucursales.where((s) => s.status == 'activo').map((s) {
                  return DropdownMenuItem<int>(
                    value: s.idSucursal,
                    child: Text(s.nombre),
                  );
                }).toList(),
                onChanged: (value) => setState(() => idSucursal = value),
                dropdownColor: Colors.blue.shade50,
                decoration: const InputDecoration(
                  labelText: 'Sucursal',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                validator: (value) =>
                    value == null ? 'Seleccione una sucursal' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: idProducto,
                items: productos.where((p) => p.status == 'activo').map((p) {
                  return DropdownMenuItem<int>(
                    value: p.idProducto,
                    child: Text(p.nombre),
                  );
                }).toList(),
                onChanged: (value) => setState(() => idProducto = value),
                dropdownColor: Colors.blue.shade50,
                decoration: const InputDecoration(
                  labelText: 'Producto',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                validator: (value) =>
                    value == null ? 'Seleccione un producto' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(
                          labelText: 'Cantidad disponible',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la cantidad';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _precioCompraController,
                      decoration: const InputDecoration(
                          labelText: 'Precio de compra',
                          prefixText: FlowstockConstants.currencySymbol,
                          border: OutlineInputBorder()),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un precio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _precioVentaController,
                      decoration: const InputDecoration(
                          labelText: 'Precio de venta',
                          prefixText: FlowstockConstants.currencySymbol,
                          border: OutlineInputBorder()),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un precio';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de ingreso',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: fechaIngreso,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaIngreso = picked;
                      _fechaController.text = _formatoFecha.format(picked);
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: _guardarInventario,
                    icon: const Icon(Icons.save),
                    label: const Text(FlowstockConstants.titleSave,
                        style: FlowstockTextStyles.buttonAction),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
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
      ),
    );
  }
}
