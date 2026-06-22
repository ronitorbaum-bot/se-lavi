import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/reminder_record.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTabChange;
  final List<ReminderRecord> reminders;
  final Future<void> Function() onOpenExpenseForm;
  final Future<void> Function() onOpenIncomeForm;

  const HomeScreen({
    super.key,
    required this.onTabChange,
    required this.reminders,
    required this.onOpenExpenseForm,
    required this.onOpenIncomeForm,
  });

  // ─── סינון תזכורות להיום ─────────────────────────────

  static String _weekdayName(int dartWeekday) {
    const names = {
      1: 'שני', 2: 'שלישי', 3: 'רביעי',
      4: 'חמישי', 5: 'שישי', 6: 'שבת', 7: 'ראשון',
    };
    return names[dartWeekday] ?? '';
  }

  List<ReminderRecord> _todayReminders() {
    final now = DateTime.now();
    final todayName = _weekdayName(now.weekday);
    return reminders.where((r) {
      switch (r.repeat) {
        case 'חד פעמי':
          if (r.oneTimeDate == null) return false;
          final d = r.oneTimeDate!;
          return d.year == now.year && d.month == now.month && d.day == now.day;
        case 'יומי':
          return r.days.contains(todayName);
        case 'שבועי':
          return r.days.isNotEmpty && r.days.first == todayName;
        case 'חודשי':
          if (r.oneTimeDate != null) return r.oneTimeDate!.day == now.day;
          return false;
        default:
          return false;
      }
    }).toList();
  }

  // ─── דיאלוג עזרה ─────────────────────────────────────

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'אנחנו איתך',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'בהמשך הכפתור הזה ישלח הודעה לאיש קשר שתבחרי מראש.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, height: 1.6),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('הבנתי', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── כפתור קומפקטי ───────────────────────────────────

  Widget _compactButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(0, 60),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ─── אזור תזכורות ─────────────────────────────────────

  Widget _buildRemindersSection(BuildContext context) {
    final visible = _todayReminders().take(3).toList();
    final hasMore = _todayReminders().length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'תזכורות להיום',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        if (visible.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 28, color: AppColors.oliveGreen),
                const SizedBox(width: 12),
                Text(
                  'אין תזכורות להיום',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
              ],
            ),
          )
        else ...[
          ...visible.map((r) => _buildReminderChip(context, r)),
          if (hasMore)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'יש עוד תזכורות במסך תזכורות',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMedium,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildReminderChip(BuildContext context, ReminderRecord r) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: r.isDone ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: r.isDone ? Colors.grey.shade200 : AppColors.sunrise,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            r.isDone ? Icons.check_circle : Icons.notifications_outlined,
            color: r.isDone ? Colors.grey.shade400 : AppColors.sunrise,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: r.isDone ? Colors.grey.shade400 : AppColors.textDark,
                    decoration: r.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (r.time != null || r.repeat.isNotEmpty)
                  Text(
                    [if (r.time != null) r.time!, r.repeatLabel].join('  •  '),
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textMedium),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── build ────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('היום שלי')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 8),

              _buildRemindersSection(context),

              const SizedBox(height: 20),

              // שלושה כפתורים קומפקטיים בשורה
              Row(
                children: [
                  _compactButton(
                    label: 'רישום\nהוצאה',
                    icon: Icons.arrow_upward,
                    color: AppColors.terracotta,
                    onPressed: onOpenExpenseForm,
                  ),
                  const SizedBox(width: 8),
                  _compactButton(
                    label: 'רישום\nהכנסה',
                    icon: Icons.arrow_downward,
                    color: AppColors.oliveGreen,
                    onPressed: onOpenIncomeForm,
                  ),
                  const SizedBox(width: 8),
                  _compactButton(
                    label: 'הוספת\nתזכורת',
                    icon: Icons.notifications_outlined,
                    color: AppColors.sunrise,
                    onPressed: () => onTabChange(2),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // כפתור עזרה — גדול ובולט
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showHelpDialog(context),
                  icon: const Icon(Icons.favorite, size: 24),
                  label: const Text(
                    'צריכה עזרה',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.terracotta,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 72),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
