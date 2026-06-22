const List<String> kAllDays = [
  'ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת'
];

class ReminderRecord {
  final String id;
  final String title;
  final String? time;
  final String repeat;
  final List<String> days;
  final String? note;
  final DateTime? oneTimeDate;
  bool isDone;

  ReminderRecord({
    required this.id,
    required this.title,
    this.time,
    required this.repeat,
    List<String>? days,
    this.note,
    this.oneTimeDate,
    this.isDone = false,
  }) : days = days ?? [];

  String get repeatLabel {
    switch (repeat) {
      case 'יומי':
        if (days.isEmpty) return 'יומי';
        if (days.length == kAllDays.length) return 'כל יום';
        return days.join(', ');
      case 'שבועי':
        return days.isNotEmpty ? 'כל ${days.first}' : 'שבועי';
      case 'חד פעמי':
        if (oneTimeDate != null) {
          final d = oneTimeDate!;
          return '${d.day}/${d.month}/${d.year}';
        }
        return 'חד פעמי';
      default:
        return repeat;
    }
  }
}
