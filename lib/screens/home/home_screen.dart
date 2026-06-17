import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/large_action_button.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

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
          'בהמשך הכפתור הזה ישלח הודעה לאיש קשר שתבחרי מראש.\nכרגע זו רק הדגמה.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('היום שלי')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // לוגו וכותרת
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              'סה-לביא',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.oliveGreen,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'שלום! מה תרצי לעשות היום?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMedium,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // כרטיס "הדבר הבא"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.oliveGreen, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 40,
                    color: AppColors.oliveGreen,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'אין כרגע תזכורות להיום',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.oliveGreen,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'כאן יופיע הדבר הבא שצריך לעשות',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // שורה 1: הוצאה + הכנסה
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

            // שורה 2: תזכורת + עזרה
            Row(
              children: [
                Expanded(
                  child: LargeActionButton(
                    label: 'הוספת תזכורת',
                    icon: Icons.notifications_outlined,
                    backgroundColor: AppColors.sunrise,
                    onPressed: () => onTabChange(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LargeActionButton(
                    label: 'עזרה / יצירת קשר',
                    icon: Icons.people_outline,
                    backgroundColor: AppColors.oliveLight,
                    onPressed: () => onTabChange(3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // כפתור "צריכה עזרה" — רוחב מלא
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
