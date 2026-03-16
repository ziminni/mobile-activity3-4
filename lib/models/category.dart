// CATEGORY: categoryId, category, note, date

class Category {
  String? id;
  int categoryId;
  String category;
  String note;
  String date;
  bool isDefault;

  Category({
    this.id,
    required this.categoryId,
    required this.category,
    required this.note,
    required this.date,
    this.isDefault = false,
  });

  Category copyWith({
    String? id,
    int? categoryId,
    String? category,
    String? note,
    String? date,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'category': category,
      'note': note,
      'date': date,
      'isDefault': isDefault,
    };
  }

  factory Category.fromMap(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      categoryId: data['categoryId'] is int
          ? data['categoryId'] as int
          : int.tryParse('${data['categoryId']}') ?? 0,
      category: data['category'] as String? ?? '',
      note: data['note'] as String? ?? '',
      date: data['date'] as String? ?? '',
      isDefault: data['isDefault'] as bool? ?? false,
    );
  }
}
