import 'package:flow_stock/core/database/database_helper.dart';
import 'package:flow_stock/data/models/payment_method.dart';
import 'package:flow_stock/data/models/transaction.dart';

class PaymentRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> createTransaction(Transaction transaction) async {
    return await _databaseHelper.insert('transactions', transaction.toMap());
  }

  Future<List<Transaction>> getAllTransactions() async {
    final List<Map<String, dynamic>> maps =
        await _databaseHelper.queryAllRows('transactions');

    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getAllTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final List<Map<String, dynamic>> maps =
        await _databaseHelper.getTransactionsByDate(startDate, endDate);

    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getTransactionsByStatus(String status) async {
    final List<Map<String, dynamic>> maps =
        await _databaseHelper.getTransactionsByStatus(status);

    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future getTransactionSummary() async {
    final transactions = await getAllTransactions();
    double totalAmount = 0;

    Map<String, double> methodTotals = {};

    /*
      {
        'debit_card': 0
      }
    */

    for (var transaction in transactions) {
      if (transaction.status == 'completed') {
        totalAmount += transaction.amount;
        methodTotals[transaction.paymentMethod] =
            (methodTotals[transaction.paymentMethod] ?? 0) + transaction.amount;
      }
    }
    return {'total': totalAmount, ...methodTotals};
  }

  Future<int> updateTransaction(Transaction transaction) async {
    return await _databaseHelper
        .update('transactions', transaction.toMap(), 'id = ?', [transaction.id]);
  }

  Future<int> deleteTransaction(int id) async {
    return await _databaseHelper.delete('transactions', 'id = ?', [id]);
  }

// Métodos de pago
  Future<List<PaymentMethod>> getAllPaymentsMethods() async {
    final List<Map<String, dynamic>> maps =
        await _databaseHelper.queryAllRows('payment_method');

    return List.generate(maps.length, (i) => PaymentMethod.fromMap(maps[i]));
  }

  Future<List<PaymentMethod>> getActivePaymentsMethods() async {
    final List<Map<String, dynamic>> maps =
        await _databaseHelper.getActivePaymentsMethods();

    return List.generate(maps.length, (i) => PaymentMethod.fromMap(maps[i]));
  }

  Future<void> togglePaymentMethod(int id, bool isActive) async {
    await _databaseHelper.togglePaymentMethod(id, isActive);
  }
}
