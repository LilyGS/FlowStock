abstract class PaymentProvider {
  Future<bool> processPayment(double amount);
  Future<bool> validatePayment();
  Future<String> getPaymentStatus();
}