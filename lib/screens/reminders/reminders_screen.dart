import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/reminder_record.dart';
import '../../widgets/large_action_button.dart';

class RemindersScreen extends StatelessWidget {
  final List<ReminderRecord> reminders;
  final void Function(ReminderRecord) onAdd;
  final void Function(String id) onDelete;
  final void Function(String id) onToggleDone;

  const RemindersScreen({
    super.key,
    required this.reminders,
    required this.onAdd,
    required this.onDelete,
    required this.onToggleDone,
  });

  Future<void> _openAddSheet(BuildContext context) async {
    final result = await showModalBottomSheet<ReminderRecord>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddReminderSheet(),
    );

    if (result != null && context.mounted) {
      onAdd(result);
      _showSuccessDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
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

  void _confirmDelete(BuildContext context, String id) {
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
                child:
                    const Text('ביטול', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  onDelete(id);
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracotta,
                  foregroundColor: Colors.white,
                ),
                child:
                    const Text('מחיקה', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, ReminderRecord r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: r.isDone
                    ? const Color(0x206B7C3F)
                    : const Color(0x20E8853A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                r.isDone
                    ? Icons.check_circle
                    : Icons.notifications_outlined,
                color: r.isDone
                    ? AppColors.oliveGreen
                    : AppColors.sunrise,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: r.isDone
                          ? AppColors.textMedium
                          : AppColors.textDark,
                      decoration:
                          r.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (r.time != null) ...[
                        const Icon(Icons.access_time,
                            size: 14, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text(r.time!,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMedium)),
                        const SizedBox(width: 10),
                      ],
                      const Icon(Icons.repeat,
                          size: 14, color: AppColors.textMedium),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          r.repeatLabel,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textMedium),
                        ),
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
                    r.isDone
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: r.isDone
                        ? AppColors.oliveGreen
                        : Colors.grey.shade400,
                    size: 28,
                  ),
                  onPressed: () => onToggleDone(r.id),
                ),
                IconButton(
                  tooltip: 'מחיקה',
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.terracotta, size: 26),
                  onPressed: () => _confirmDelete(context, r.id),
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
              onPressed: () => _openAddSheet(context),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: reminders.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.grey.shade300),
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
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: reminders.length,
                    itemBuilder: (ctx, i) =>
                        _buildTile(ctx, reminders[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── BottomSheet הוספת תזכורת ─────────────────────────

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet();

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  String _repeat = 'חד פעמי';
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(kAllDays);
  }

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
          content: Text(
            'צריך לכתוב מה להזכיר',
            style: TextStyle(fontSize: 17),
          ),
          backgroundColor: AppColors.terracotta,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      ReminderRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        time: _timeController.text.trim().isEmpty
            ? null
            : _timeController.text.trim(),
        repeat: _repeat,
        days: _repeat == 'יומי' ? List.from(_selectedDays) : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ידית
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // כותרת
              Center(
                child: Text(
                  'הוספת תזכורת',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // מה להזכיר
              _sectionLabel('מה להזכיר לך?', required: true),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 19),
                autofocus: true,
                decoration: _inputDecor(hint: 'למשל: לקחת תרופה, לצלצל לרופא...'),
              ),
              const SizedBox(height: 22),

              // שעה
              _sectionLabel('שעה', required: false),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                style: const TextStyle(fontSize: 19),
                keyboardType: TextInputType.datetime,
                decoration: _inputDecor(hint: '09:00'),
              ),
              const SizedBox(height: 22),

              // חזרה
              _sectionLabel('חזרה', required: false),
              const SizedBox(height: 12),
              _buildRepeatSelector(),

              // ימים — מוצג רק כשיומי
              if (_repeat == 'יומי') ...[
                const SizedBox(height: 22),
                _sectionLabel('ימים', required: false),
                const SizedBox(height: 10),
                _buildDaysSelector(),
              ],

              const SizedBox(height: 32),

              // שמירה
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    textStyle: const TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('שמירה'),
                ),
              ),
              const SizedBox(height: 12),

              // ביטול
              SizedBox(
                width: double.infinity,
                height: 54,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'ביטול',
                    style: TextStyle(
                        fontSize: 18, color: AppColors.textMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatSelector() {
    const options = ['חד פעמי', 'יומי', 'שבועי', 'חודשי'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final selected = _repeat == opt;
        return GestureDetector(
          onTap: () => setState(() => _repeat = opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? AppColors.oliveGreen : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? AppColors.oliveGreen
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kAllDays.map((day) {
        final on = _selectedDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (on) {
                _selectedDays.remove(day);
              } else {
                _selectedDays.add(day);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: on ? AppColors.sunrise : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: on ? AppColors.sunrise : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    on ? FontWeight.bold : FontWeight.normal,
                color: on ? Colors.white : AppColors.textMedium,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionLabel(String text, {required bool required}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
                color: AppColors.terracotta,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  InputDecoration _inputDecor({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(fontSize: 16, color: AppColors.textMedium),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppColors.oliveGreen, width: 2),
      ),
    );
  }
}
