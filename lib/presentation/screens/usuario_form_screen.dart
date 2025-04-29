import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/data/models/usuario.dart';
import 'package:flow_stock/providers/usuario_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';

// Pantalla para registrar un nuevo Usuario
// Contiene un formulario con campos de nombre, correo, contraseña y rol

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormScreen({super.key, this.usuario});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _rolController = TextEditingController();

  Usuario? usuario;

  @override
  void initState() {
    super.initState();

    usuario = widget.usuario;

    if (usuario != null) {
      // Cuando es modificación asigna los valores al controlador
      _nombreController.text = usuario!.nombre;
      _correoController.text = usuario!.correo;
      _contrasenaController.text = usuario!.contrasena;
      _rolController.text = usuario!.rol;
    }
  }

  @override
  void dispose() {
    // Liberación de controladores de texto
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _rolController.dispose();
    super.dispose();
  }

  // Guaarda el usuario en la BD
  Future<void> _guardarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text;
    final correo = _correoController.text;
    final contrasena = _contrasenaController.text;
    final rol = _rolController.text;

    final nuevoUsuario = Usuario(
      idUsuario: widget.usuario?.idUsuario,
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      rol: rol,
      status: widget.usuario?.status ?? 'activo',
    );

    final provider = Provider.of<UsuarioProvider>(context, listen: false);

    if (widget.usuario == null) {
      await provider.agregarUsuario(nuevoUsuario); // En la inserción
    } else {
      await provider.actualizarUsuario(nuevoUsuario); // Cuando es modificación
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null
            ? FlowstockConstants.titleNewUsuario
            : FlowstockConstants.titleEditUsuario), // uso de constantes
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
                controller: _contrasenaController,
                decoration: const InputDecoration(
                    labelText: 'Contraseña', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _rolController,
                decoration: const InputDecoration(
                    labelText: 'Rol (admin, vendedor)',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _guardarUsuario,
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
