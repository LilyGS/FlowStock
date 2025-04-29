import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flow_stock/data/models/producto.dart';
import 'package:flow_stock/providers/producto_provider.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/core/constant/flowstock_text_styles.dart';

// Pantalla para registrar un nuevo Producto
// Contiene un formulario con campos de nombre,
// descripción, categoría, unidad y precio de lista

class ProductoFormScreen extends StatefulWidget {
  final Producto? producto;
  const ProductoFormScreen({super.key, this.producto});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _unidadmedidaController = TextEditingController();
  final _preciolistaController = TextEditingController();

  Producto? producto;

  @override
  void initState() {
    super.initState();

    producto = widget.producto;

    if (producto != null) {
      // Cuando es modificación asigna los valores al controlador
      _nombreController.text = producto!.nombre;
      _descripcionController.text = producto!.descripcion ?? '';
      _categoriaController.text = producto!.categoria ?? '';
      _unidadmedidaController.text = producto!.unidadMedida ?? '';
      _preciolistaController.text = producto!.precioLista.toString();
    }
  }

  @override
  void dispose() {
    // Liberación de controladores de texto
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _unidadmedidaController.dispose();
    _preciolistaController.dispose();
    super.dispose();
  }

  // Guarda el producto en la BD
  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text;
    final descripcion = _descripcionController.text;
    final categoria = _categoriaController.text;
    final unidadMedida = _unidadmedidaController.text;
    final precioLista =
        double.parse(_preciolistaController.text.replaceAll(',', '.'));

    final nuevoProducto = Producto(
      idProducto: widget.producto?.idProducto,
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria,
      unidadMedida: unidadMedida,
      precioLista: precioLista,
      status: widget.producto?.status ?? 'activo',
    );

    final provider = Provider.of<ProductoProvider>(context, listen: false);

    if (widget.producto == null) {
      await provider.agregarProducto(nuevoProducto); // Inserción
    } else {
      await provider.actualizarProducto(nuevoProducto); // Modificación
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto == null
            ? FlowstockConstants.titleNewProducto
            : FlowstockConstants.titleEditProducto), // Uso de constantes
      ),
      body: Padding(
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
                controller: _descripcionController,
                decoration: const InputDecoration(
                    labelText: 'Descripción', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                    labelText: 'Categoría', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _unidadmedidaController,
                      decoration: const InputDecoration(
                          labelText: 'Unidad de Medida (KGM, MTR, etc)',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value != null && value.length > 3) {
                          return 'La unidad de medida no debe exceder 3 carácteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _preciolistaController,
                      decoration: const InputDecoration(
                          labelText: 'Precio de Lista',
                          border: OutlineInputBorder()),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          (double.tryParse(value ?? '') == null)
                              ? 'Ingrese un valor numérico'
                              : null,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _guardarProducto,
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
