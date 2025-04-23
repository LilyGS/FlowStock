import 'package:flow_stock/providers/payment_providers/payment_provider.dart';

class BankTransferPayment implements PaymentProvider {
  @override
  Future<String> getPaymentStatus() async {
    // Simulación de estado
    return 'processing';
  }

  @override
  Future<bool> processPayment(double amount) async {
    // Simulación de procesamiento
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  @override
  Future<bool> validatePayment() async {
    // Simulación de procesamiento
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
