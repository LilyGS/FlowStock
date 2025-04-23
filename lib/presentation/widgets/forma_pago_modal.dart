import 'package:flutter/material.dart';



Future<String?> seleccionarMetodoPago(BuildContext context, double total) async {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Selecciona forma de pago'),
        children: [
          Text('Total a pagar: \$${total.toStringAsFixed(2)}'),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Efectivo'),
            child: const Text('Efectivo'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Tarjeta Débito'),
            child: const Text('Tarjeta Débito'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Tarjeta Crédito'),
            child: const Text('Tarjeta Crédito'),
          ),
        ],
      );
    },
  );
}
