import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/large_action_button.dart';

class ReminderRecord {
  final String id;
  final String title;
  final String? time;
  final String repeat;
  bool isDone;

  ReminderRecord({
    required this.id,
    required this.title,
    this.time,
    required this.repeat,
    this.isDone = false,
  });
}

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<ReminderRecord> _reminders = [];

  Future<void> _openAddReminderSheet() async {
    final result = await showModalBottomSheet<ReminderRecord>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddReminderSheet(),
    );

    if (result != null && mounted) {
      setState(() => _reminders.insert(0, result));
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'התזכורת נוספה',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'אפשר לראות אותה ברשימה.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('הבנתי', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'למחוק תזכורת?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'אי אפשר לשחזר אחרי המחיקה.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('ביטול', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _reminders.removeWhere((r) => r.id == id));
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracotta,
                  foregroundColor: Colors.white,
                ),
                child: const Text('מחיקה', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildReminderTile(ReminderRecord reminder) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: reminder.isDone
                    ? const Color(0x206B7C3F)
                    : const Color(0x20E8853A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                reminder.isDone
                    ? Icons.check_circle
                    : Icons.notifications_outlined,
                color: reminder.isDone ? AppColors.oliveGreen : AppColors.sunrise,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: reminder.isDone
                          ? AppColors.textMedium
                          : AppColors.textDark,
                      decoration: reminder.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (reminder.time != null) ...[
                        const Icon(Icons.access_time,
                            size: 15, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text(
                          reminder.time!,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.textMedium),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.repeat,
                          size: 15, color: AppColors.textMedium),
                      const SizedBox(width: 4),
                      Text(
                        reminder.repeat,
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.textMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'בוצע',
                  icon: Icon(
                    reminder.isDone
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: reminder.isDone
                        ? AppColors.oliveGreen
                        : Colors.grey.shade400,
                    size: 28,
                  ),
                  onPressed: () =>
                      setState(() => reminder.isDone = !reminder.isDone),
                ),
                IconButton(
                  tooltip: 'מחיקה',
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.terracotta, size: 26),
                  onPressed: () => _confirmDelete(reminder.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('תזכורות')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: LargeActionButton(
              label: 'הוספת תזכורת',
              icon: Icons.add_alert_outlined,
              backgroundColor: AppColors.sunrise,
              onPressed: _openAddReminderSheet,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _reminders.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'אין עדיין תזכורות',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.textMedium),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'לחצי על "הוספת תזכורת" כדי להתחיל',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textMedium),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _reminders.length,
                    itemBuilder: (_, i) => _buildReminderTile(_reminders[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet();

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  String _repeat = 'חד פעמי';

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('נא להזין כותרת לתזכורת',
              style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.terracotta,
        ),
      );
      return;
    }

    final record = ReminderRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      time: _timeController.text.trim().isEmpty
          ? null
          : _timeController.text.trim(),
      repeat: _repeat,
    );

    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'תזכורת חדשה',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // כותרת
              _buildField(
                label: 'כותרת תזכורת',
                isRequired: true,
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 18),
                  decoration: _inputDecoration(hint: 'מה צריך לזכור?'),
                ),
              ),
              const SizedBox(height: 16),

              // שעה
              _buildField(
                label: 'שעה (רשות)',
                child: TextField(
                  controller: _timeController,
                  style: const TextStyle(fontSize: 18),
                  keyboardType: TextInputType.datetime,
                  decoration: _inputDecoration(hint: 'למשל: 09:00'),
                ),
              ),
              const SizedBox(height: 16),

              // חזרה
              _buildField(
                label: 'חזרה',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: DropdownButton<String>(
                    value: _repeat,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    style: const TextStyle(
                        fontSize: 18, color: AppColors.textDark),
                    items: ['חד פעמי', 'יומי', 'שבועי', 'חודשי']
                        .map((v) => DropdownMenuItem(
                              value: v,
                              child: Text(v,
                                  style: const TextStyle(fontSize: 18)),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _repeat = v!),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: const Text('שמירה'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text(
                  'ביטול',
                  style: TextStyle(fontSize: 18, color: AppColors.textMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    bool isRequired = false,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600)),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(
                      color: AppColors.terracotta, fontSize: 17)),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 16, color: AppColors.textMedium),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.oliveGreen, width: 2),
      ),
    );
  }
}
