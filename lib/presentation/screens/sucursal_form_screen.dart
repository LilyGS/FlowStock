import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/data/models/sucursal.dart';
import 'package:flow_stock/providers/sucursal_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';

class SucursalFormScreen extends StatefulWidget {
  final Sucursal? sucursal;
  const SucursalFormScreen({super.key, this.sucursal});

  @override
  State<SucursalFormScreen> createState() => _SucursalFormScreenState();
}

class _SucursalFormScreenState extends State<SucursalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _telefonoController = TextEditingController();

  Sucursal? sucursal;

  @override
  void initState() {
    super.initState();

    sucursal = widget.sucursal;

    if (sucursal != null) {
      _nombreController.text = sucursal!.nombre;
      _ubicacionController.text = sucursal!.ubicacion;
      _telefonoController.text = sucursal!.telefono ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _guardarSucursal() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text;
    final ubicacion = _ubicacionController.text;
    final telefono = _telefonoController.text;

    final nuevaSucursal = Sucursal(
      idSucursal: widget.sucursal?.idSucursal,
      nombre: nombre,
      ubicacion: ubicacion,
      telefono: telefono,
      status: widget.sucursal?.status ?? 'activo',
    );

    final provider = Provider.of<SucursalProvider>(context, listen: false);

    if (widget.sucursal == null) {
      await provider.agregarSucursal(nuevaSucursal);
    } else {
      await provider.actualizarSucursal(nuevaSucursal);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sucursal == null
            ? FlowstockConstants.titleNewSucursal
            : FlowstockConstants.titleEditSucursal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                    labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _ubicacionController,
                decoration: const InputDecoration(
                    labelText: 'Ubicación', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                    labelText: 'Teléfono (opcional)',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value != null && value.length > 20) {
                    return 'El teléfono no debe exceder 20 carácteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: _guardarSucursal,
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
