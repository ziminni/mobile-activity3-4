// EXPENSE: title, note, amount, category, date

class Expense {
  String? id;
  String title;
  String amount;
  String note;
  String category;
  String date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
  });

  Expense copyWith({
    String? id,
    String? title,
    String? amount,
    String? note,
    String? category,
    String? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'note': note,
      'category': category,
      'date': date,
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      title: data['title'] as String? ?? '',
      amount: data['amount']?.toString() ?? '0',
      note: data['note'] as String? ?? '',
      category: data['category'] as String? ?? '',
      date: data['date'] as String? ?? '',
    );
  }
}
