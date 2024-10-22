class Transaction {
  final String id;
  final String type;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      type: json['type'],
      amount: double.parse(json['amount']),
      date: DateTime.parse(json['created_at']),
    );
  }
}