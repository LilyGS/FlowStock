class PaymentMethod {
  final int? id;
  final String name;
  final bool isActive;

  PaymentMethod({this.id, required this.name, this.isActive = true});

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
        id: map['id'], name: map['name'], isActive: map['is_active'] == 1);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'is_active': isActive ? 1 : 0};
  }

  PaymentMethod copyWith({int? id, String? name, bool? isActive}) {
    return PaymentMethod(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive);
  }

  @override
  String toString() {
    return 'PaymentMethod{id: $id, name: $name, isActive: $isActive}';
  }
}
