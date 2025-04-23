import 'package:flow_stock/data/models/transaction.dart';
import 'package:flow_stock/data/repositories/payment_repository.dart';
import 'package:flow_stock/providers/payment_providers/credit_card_payment.dart';
import 'package:flow_stock/providers/payment_providers/payment_provider.dart';
import 'package:flow_stock/providers/payment_providers/paypal_provider.dart';
import 'package:flow_stock/providers/payment_providers/bank_transfer_payment.dart';

class PaymentFacade {
  final PaymentRepository _repository;
  final Map<String, PaymentProvider> _providers = {
    'credit_card': CreditCardPayment(),
    'paypal': PaypalPayment(),
    'bank_transfer': BankTransferPayment(),
  };

  PaymentFacade(this._repository);

  Future<bool> processPayment(
      {required String method,
      required double amount,
      String? description}) async {
    try {
      final provider = _providers[method];
      if (provider == null) {
        throw Exception('Método de pago no soportado: $method');
      }

      final isValid = await provider.validatePayment();
      if (!isValid) {
        throw Exception('Validación de pago fallida');
      }

      final success = await provider.processPayment(amount);
      if (!success) {
        throw Exception('Procesamiento de pago fallido');
      }

      final status = await provider.getPaymentStatus();
      final transaction = Transaction(
          amount: amount,
          paymentMethod: method,
          status: status,
          date: DateTime.now(),
          description: description);

      await _repository.createTransaction(transaction);

      return true;
    } catch (ex) {
      // En producción debemos tener los erroresawait _repository.createTransaction(transaction);
      print('Error en el proceso de pago: $ex');
      final transaction = Transaction(
          amount: amount,
          paymentMethod: method,
          status: 'failed',
          date: DateTime.now(),
          description: description);

      await _repository.createTransaction(transaction);
      return false;
    }
  }

// Obtener la lista de métodos de pago que están activos en el sistema
  Future<List<String>> getAvailablePaymentMethods() async {
    final methods = await _repository.getActivePaymentsMethods();
    return methods.map((m) => m.name).toList();
  }

  // Obtener todas las transacciones que tenemos
  Future<Map<String, double>> getTransacctionsSummary() async {
    return await _repository.getTransactionSummary();
  }

  Future<List<Transaction>> getTransactionsByStatus(String status) async {
    return await _repository.getTransactionsByStatus(status);
  }

  Future<List<Transaction>> getTransactionByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _repository.getAllTransactionsByDateRange(startDate, endDate);
  }
}
