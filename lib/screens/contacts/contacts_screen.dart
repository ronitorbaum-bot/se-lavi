import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('אנשי קשר')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'אנשי קשר לעזרה',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'כאן יופיעו אנשי הקשר שלך — בהמשך אפשר להוסיף ולערוך.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
            ),
            const SizedBox(height: 20),

            // כרטיס דמו — רונית
            _buildContactCard(
              context,
              name: 'רונית',
              relation: 'בת',
              phone: '050-0000000',
              hasWhatsApp: true,
              isDemo: true,
            ),

            const SizedBox(height: 16),

            // כרטיס ריק — הוספה עתידית
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.5,
                    style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.add_circle_outline,
                      size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Text(
                    'הוספת איש קשר',
                    style: TextStyle(
                        fontSize: 17, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'בהמשך תוכלי להוסיף אנשי קשר נוספים',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String name,
    required String relation,
    required String phone,
    required bool hasWhatsApp,
    bool isDemo = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.oliveGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // כותרת + תג דמו
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3E4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person,
                    size: 30, color: AppColors.oliveGreen),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                    ),
                    Text(
                      relation,
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.textMedium),
                    ),
                  ],
                ),
              ),
              if (isDemo)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFFFD966), width: 1),
                  ),
                  child: const Text(
                    'לדוגמה',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF856404),
                        fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // פרטי קשר
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 20, color: AppColors.textMedium),
              const SizedBox(width: 10),
              Text(
                phone,
                style: const TextStyle(
                    fontSize: 18, color: AppColors.textDark),
              ),
            ],
          ),

          if (hasWhatsApp) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline,
                    size: 20, color: Color(0xFF25D366)),
                const SizedBox(width: 10),
                const Text(
                  'WhatsApp זמין',
                  style: TextStyle(
                      fontSize: 16, color: Color(0xFF25D366),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // כפתורי פעולה
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showComingSoon(context),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('התקשרי',
                      style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(
                        color: AppColors.oliveGreen, width: 1.5),
                    foregroundColor: AppColors.oliveGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showComingSoon(context),
                  icon: const Icon(Icons.chat_bubble, size: 18),
                  label: const Text('WhatsApp',
                      style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'בהמשך הכפתור ישלח הודעה או יתקשר אוטומטית',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.oliveGreen,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
