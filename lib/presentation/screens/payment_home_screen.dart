import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow_stock/core/constant/flowstock_constants.dart';
import 'package:flow_stock/data/models/transaction.dart';
import 'package:flow_stock/pattern/facade/payment_facade.dart';
import 'package:flow_stock/presentation/screens/payment_screen.dart';

class PaymentHomeScreen extends StatefulWidget {
  final PaymentFacade paymentFacade;
  const PaymentHomeScreen({super.key, required this.paymentFacade});

  @override
  State<PaymentHomeScreen> createState() => _PaymentHomeScreenState();
}

class _PaymentHomeScreenState extends State<PaymentHomeScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: FlowstockConstants.currencySymbol,
    decimalDigits: 2,
  );

  bool _isLoading = true;

  List<Transaction> _transactions = [];
  Map<String, double> _summary = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions =
          await widget.paymentFacade.getTransactionsByStatus('completed');
      final summary = await widget.paymentFacade.getTransacctionsSummary();
      setState(() {
        _summary = summary;
        _transactions = transactions;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(FlowstockConstants.errorDatabase),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showPaymentScreen() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  paymentFacade: widget.paymentFacade,
                )));

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(FlowstockConstants.titleHome),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resumen de transacciones',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Total: ${_currencyFormat.format(_summary['total'] ?? 0)}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const Divider(
                        height: 32,
                      ),
                      // Totales por cada método de pago
                      ..._summary.entries
                          .where((e) => e.key != 'total')
                          .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FlowstockConstants.paymentMethods[e.key] ??
                                        e.key,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _currencyFormat.format(e.value),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )))
                    ],
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Text('Últimas transacciones',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      _getTransactionIcon(transaction.paymentMethod),
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(_currencyFormat.format(transaction.amount),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(FlowstockConstants
                                .paymentMethods[transaction.paymentMethod] ??
                            transaction.paymentMethod),
                        if (transaction.description != null)
                          Text(
                            transaction.description!,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                      ],
                    ),
                    trailing: Text(
                      DateFormat().format(transaction.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                );
              }, childCount: _transactions.length),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPaymentScreen,
        label: const Text("Nuevo pago"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  IconData _getTransactionIcon(String method) {
    switch (method) {
      case 'credit_card':
        return Icons.credit_card;
      case 'debit_card':
        return Icons.branding_watermark_rounded;
      case 'paypal':
        return Icons.paypal;
      case 'bank_transfer':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }
}
