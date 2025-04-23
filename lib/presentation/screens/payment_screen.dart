import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/pattern/facade/payment_facade.dart';
import 'package:flow_stock/presentation/widgets/payment_card.dart';

class PaymentScreen extends StatefulWidget {
  final PaymentFacade paymentFacade;
  const PaymentScreen({super.key, required this.paymentFacade});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // - Acceder al estado del formulario para activar validaciones
  // - Guardar o modificar los datos del formulario
  // - Reiniciar el formulario
  final _formKey = GlobalKey<FormState>();

  // Estado para el método de pago seleccionado
  String? _selectedMethod;

  // Estado de procesamiento (Loading)
  bool _isProcessing = false;

  // Controladores del formulario
  // Mantienen el estado y permiten manipularlo
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    // Se liberan los controladores cuando se destruye la pantalla
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate() || _selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor completa los campos requeridos'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', '.'));

      final success = await widget.paymentFacade.processPayment(
          method: _selectedMethod!,
          amount: amount,
          description: _descriptionController.text);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pago procedado correctamente'),
          backgroundColor: Colors.green,
        ));
        // El segundo parámetro que va a retornar (Home Screen)
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(FlowstockConstants.errorGeneral),
          backgroundColor: Colors.red,
        ));
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleNewPayment),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                        labelText: 'Monto (${FlowstockConstants.currencyCode})',
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
                        return 'Por favor, ingresa un monto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Descripción (Opcional)',
                        border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text('Selecciona un método de pago',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 24,
                  ),
                  ...FlowstockConstants.paymentMethods.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PaymentCard(
                          method: entry.key,
                          isSelect: _selectedMethod == entry.key,
                          onTap: () {
                            setState(() {
                              _selectedMethod = entry.key;
                            });
                          }))),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: _isProcessing ? null : _processPayment,
                      child: _isProcessing
                          ? const CircularProgressIndicator()
                          : const Text('Procesar pago',
                              style: TextStyle(fontSize: 10)))
                ],
              ))),
    );
  }
}
