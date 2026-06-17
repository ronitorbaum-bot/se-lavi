const List<String> kAllDays = [
  'ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת'
];

class ReminderRecord {
  final String id;
  final String title;
  final String? time;
  final String repeat;
  final List<String> days; // רלוונטי רק כאשר repeat == 'יומי'
  bool isDone;

  ReminderRecord({
    required this.id,
    required this.title,
    this.time,
    required this.repeat,
    List<String>? days,
    this.isDone = false,
  }) : days = days ?? [];

  String get repeatLabel {
    if (repeat != 'יומי') return repeat;
    if (days.length == kAllDays.length) return 'כל יום';
    return days.join(', ');
  }
}
