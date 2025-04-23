import 'package:flow_stock/providers/payment_providers/payment_provider.dart';

class CreditCardPayment implements PaymentProvider {
  @override
  Future<String> getPaymentStatus() async {
    // Simulación de estado
    return 'completed';
  }

  @override
  Future<bool> processPayment(double amount) async {
    // Simulación de procesamiento
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<bool> validatePayment() async {
    // Simulación de procesamiento
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
