import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/data/models/cliente.dart';
import 'package:flow_stock/providers/cliente_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';

// Pantalla para registrar un nuevo Cliente
// Contiene un formulario con campos de nombre, correo, dirección y teléfono

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;
  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();

  Cliente? cliente;

  @override
  void initState() {
    super.initState();

    cliente = widget.cliente;

    if (cliente != null) {
      // Cuando es modificación asigna los valores al controlador
      _nombreController.text = cliente!.nombre;
      _correoController.text = cliente!.correo;
      _direccionController.text = cliente!.direccion ?? '';
      _telefonoController.text = cliente!.telefono ?? '';
    }
  }

  @override
  void dispose() {
    // Liberación de los controladores de texto
    _nombreController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // Guarda el cliente en la BD
  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text;
    final correo = _correoController.text;
    final direccion = _direccionController.text;
    final telefono = _telefonoController.text;

    final nuevoCliente = Cliente(
      idCliente: widget.cliente?.idCliente,
      nombre: nombre,
      correo: correo,
      direccion: direccion,
      telefono: telefono,
      status: widget.cliente?.status ?? 'activo',
    );

    final provider = Provider.of<ClienteProvider>(context, listen: false);

    if (widget.cliente == null) {
      await provider.agregarCliente(nuevoCliente); // Inserción
    } else {
      await provider.actualizarCliente(nuevoCliente); // Modificación
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null
            ? FlowstockConstants.titleNewCliente
            : FlowstockConstants.titleEditCliente),
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
                controller: _correoController,
                decoration: const InputDecoration(
                    labelText: 'Correo', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                    labelText: 'Dirección (opcional)',
                    border: OutlineInputBorder()),
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
                      onPressed: _guardarCliente,
                      icon: const Icon(Icons.save),
                      label: const Text(FlowstockConstants.titleSave,
                          style: FlowstockTextStyles.buttonAction),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
