const List<String> kAllDays = [
  'ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת'
];

class ReminderRecord {
  final String id;
  final String title;
  final String? time;   // פורמט "HH:mm"
  final String repeat;  // חד פעמי | יומי | שבועי | חודשי
  final List<String> days; // יומי: רשימה; שבועי: אלמנט יחיד
  final String? note;
  bool isDone;

  ReminderRecord({
    required this.id,
    required this.title,
    this.time,
    required this.repeat,
    List<String>? days,
    this.note,
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
      default:
        return repeat;
    }
  }
}
