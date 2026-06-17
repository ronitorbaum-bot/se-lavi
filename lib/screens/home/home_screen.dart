import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/reminder_record.dart';
import '../../widgets/large_action_button.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTabChange;
  final List<ReminderRecord> reminders;

  const HomeScreen({
    super.key,
    required this.onTabChange,
    required this.reminders,
  });

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

  Widget _buildRemindersSection(BuildContext context) {
    final visible = reminders.take(3).toList();
    final hasMore = reminders.length > 3;

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
        if (reminders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 32, color: AppColors.oliveGreen),
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
                    color: r.isDone
                        ? Colors.grey.shade400
                        : AppColors.textDark,
                    decoration:
                        r.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (r.time != null || r.repeat.isNotEmpty)
                  Text(
                    [if (r.time != null) r.time!, r.repeatLabel]
                        .join('  •  '),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('היום שלי')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // לוגו
            Image.asset(
              'assets/images/logo.png',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              'סה-לביא',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.oliveGreen,
                  ),
            ),

            const SizedBox(height: 24),

            // אזור תזכורות להיום
            _buildRemindersSection(context),

            const SizedBox(height: 28),

            // שורה: הוצאה + הכנסה
            Row(
              children: [
                Expanded(
                  child: LargeActionButton(
                    label: 'רישום הוצאה',
                    icon: Icons.arrow_upward,
                    backgroundColor: AppColors.terracotta,
                    onPressed: () => onTabChange(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LargeActionButton(
                    label: 'רישום הכנסה',
                    icon: Icons.arrow_downward,
                    backgroundColor: AppColors.oliveGreen,
                    onPressed: () => onTabChange(1),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // הוספת תזכורת
            LargeActionButton(
              label: 'הוספת תזכורת',
              icon: Icons.notifications_outlined,
              backgroundColor: AppColors.sunrise,
              onPressed: () => onTabChange(2),
            ),

            const SizedBox(height: 14),

            // צריכה עזרה
            LargeActionButton(
              label: 'צריכה עזרה',
              icon: Icons.favorite_outline,
              backgroundColor: AppColors.oliveDark,
              onPressed: () => _showHelpDialog(context),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
