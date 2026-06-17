import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/large_action_button.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('תזכורות')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          children: [
            const Icon(
              Icons.notifications_outlined,
              size: 64,
              color: AppColors.sunrise,
            ),
            const SizedBox(height: 16),
            Text(
              'תזכורות',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'כאן יופיעו התזכורות שלך',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMedium,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            LargeActionButton(
              label: 'הוספת תזכורת',
              icon: Icons.add_alert_outlined,
              backgroundColor: AppColors.sunrise,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
