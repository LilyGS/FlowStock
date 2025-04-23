import 'package:flutter/material.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';

class PaymentCard extends StatelessWidget {
  final String method;
  final bool isSelect;
  final VoidCallback onTap;

  const PaymentCard(
      {super.key,
      required this.method,
      required this.isSelect,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelect ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            width: isSelect ? 2 : 1,
            color: isSelect ? Theme.of(context).primaryColor : Colors.grey),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(_getPaymentIcon(method),
                    size: 32,
                    color: isSelect
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Text(FlowstockConstants.paymentMethods[method] ?? method,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelect ? FontWeight.bold : FontWeight.normal,
                            color: isSelect
                                ? Theme.of(context).primaryColor
                                : Colors.black87))),
                if (isSelect) Icon(Icons.check_circle)
              ],
            )),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'credit_card':
        return Icons.credit_card;
      case 'debit_card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.paypal;
      case 'bank_transfer':
        return Icons.account_balance;
      default:
        return Icons.money;
    }
  }
}
