class MoneyRecord {
  final String id;
  final String type; // 'income' or 'expense'
  final String category;
  final double? amount;
  final double? weight;
  final String? destination;
  final String? note;
  final String? extraText;
  final DateTime createdAt;

  MoneyRecord({
    required this.id,
    required this.type,
    required this.category,
    this.amount,
    this.weight,
    this.destination,
    this.note,
    this.extraText,
    required this.createdAt,
  });

  String get typeLabel => type == 'income' ? 'הכנסה' : 'הוצאה';

  String get summaryText {
    if (category == 'כביסה' && weight != null && amount != null) {
      return '${weight!.toStringAsFixed(1)} ק"ג | ₪${amount!.toStringAsFixed(2)}';
    }
    if (amount != null) return '₪${amount!.toStringAsFixed(2)}';
    if (weight != null) return '${weight!.toStringAsFixed(1)} ק"ג';
    if (destination != null) return destination!;
    return '';
  }
}
