import 'package:flow_stock/core/constant/flowstock_text_styles.dart';
import 'package:flutter/material.dart';

Future<String?> seleccionarMetodoPago(
    BuildContext context, double total) async {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona forma de pago',
                style: FlowstockTextStyles.title2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Total a pagar: ',
                  style: FlowstockTextStyles.titleOptions,
                  children: [
                    TextSpan(
                      text: '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _opcionPago(
                context,
                icon: Icons.attach_money,
                label: 'Efectivo',
                metodo: 'Efectivo',
              ),
              const Divider(),
              _opcionPago(
                context,
                icon: Icons.paypal,
                label: 'Pay Pal',
                metodo: 'Pay Pal',
              ),
              const Divider(),
              _opcionPago(
                context,
                icon: Icons.credit_card,
                label: 'Tarjeta Débito',
                metodo: 'Tarjeta Débito',
              ),
              const Divider(),
              _opcionPago(
                context,
                icon: Icons.credit_score,
                label: 'Tarjeta Crédito',
                metodo: 'Tarjeta Crédito',
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _opcionPago(BuildContext context,
    {required IconData icon, required String label, required String metodo}) {
  return ListTile(
    leading: Icon(icon, color: Colors.blueAccent),
    title: Text(label),
    onTap: () => Navigator.pop(context, metodo),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    hoverColor: Colors.blue.withValues(),
  );
}
