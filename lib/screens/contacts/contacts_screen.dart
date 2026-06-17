import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/large_action_button.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

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
      appBar: AppBar(title: const Text('עזרה ואנשי קשר')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.oliveGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'עזרה',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'כאן יהיו אנשי קשר לעזרה',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMedium,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            LargeActionButton(
              label: 'צריכה עזרה',
              icon: Icons.favorite_outline,
              backgroundColor: AppColors.oliveDark,
              onPressed: () => _showHelpDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
