class Transaction {
  final int? id;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime date;
  final String? description;

  Transaction(
      {this.id,
      required this.amount,
      required this.paymentMethod,
      required this.status,
      required this.date,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'date': date.toIso8601String(),
      'description': description
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        id: map['id'],
        amount: map['amount'],
        paymentMethod: map['payment_method'],
        status: map['status'],
        date: DateTime.parse(map['date']),
        description: map['description']);
  }

  Transaction copyWith(
      {int? id,
      double? amount,
      String? paymentMethod,
      String? status,
      DateTime? date,
      String? description}) {
    return Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        status: status ?? this.status,
        date: date ?? this.date,
        description: description ?? this.description);
  }

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, paymentMethod: $paymentMethod, status: $status, date: $date, description: $description}';
  }
}
