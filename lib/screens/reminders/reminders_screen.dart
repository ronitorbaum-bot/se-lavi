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

  // ─── דמו התראה ────────────────────────────────────────

  void _showDemoNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  size: 36,
                  color: AppColors.oliveGreen,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'תזכורת',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'לקחת תרופה',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              const Text(
                'אחרי ארוחת בוקר',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textMedium,
                    height: 1.4),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('סיימתי'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: const BorderSide(
                        color: AppColors.oliveGreen, width: 1.5),
                  ),
                  child: const Text(
                    'תזכירי לי אחר כך',
                    style: TextStyle(
                        fontSize: 17, color: AppColors.oliveGreen),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── הוספת תזכורת ────────────────────────────────────

  Future<void> _openAddSheet(BuildContext context) async {
    final result = await showModalBottomSheet<ReminderRecord>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddReminderSheet(),
    );

    if (result != null && context.mounted) {
      onAdd(result);
      _showSuccessSnack(context);
    }
  }

  void _showSuccessSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('התזכורת נוספה',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.oliveGreen,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('למחוק תזכורת?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        content: const Text('אי אפשר לשחזר אחרי המחיקה.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('ביטול',
                    style: TextStyle(fontSize: 18)),
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
                child: const Text('מחיקה',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── כרטיס תזכורת ────────────────────────────────────

  Widget _buildTile(BuildContext context, ReminderRecord r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
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
                      decoration: r.isDone
                          ? TextDecoration.lineThrough
                          : null,
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
                        child: Text(r.repeatLabel,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMedium)),
                      ),
                    ],
                  ),
                  if (r.note != null && r.note!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        r.note!,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMedium,
                            fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // ─── build ────────────────────────────────────────────

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
          const SizedBox(height: 10),

          // כפתור דמו התראה
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () => _showDemoNotification(context),
              icon: const Icon(Icons.notifications_active_outlined,
                  size: 18),
              label: const Text('הצג תזכורת לדוגמה',
                  style: TextStyle(fontSize: 15)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(
                    color: AppColors.oliveGreen, width: 1.5),
                foregroundColor: AppColors.oliveGreen,
              ),
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
  final _noteController = TextEditingController();

  String _repeat = 'חד פעמי';
  TimeOfDay? _selectedTime;

  // יומי: ריק כברירת מחדל — המשתמשת בוחרת
  final List<String> _dailyDays = [];

  // שבועי: יום יחיד
  String? _weeklyDay;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String get _timeDisplay {
    if (_selectedTime == null) return 'ללא שעה';
    final h = _selectedTime!.hour.toString().padLeft(2, '0');
    final m = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _onSave() {
    if (_titleController.text.trim().isEmpty) {
      _showError('צריך לכתוב מה להזכיר');
      return;
    }
    if (_repeat == 'יומי' && _dailyDays.isEmpty) {
      _showError('צריך לבחור לפחות יום אחד');
      return;
    }
    if (_repeat == 'שבועי' && _weeklyDay == null) {
      _showError('צריך לבחור יום לתזכורת השבועית');
      return;
    }

    final days = switch (_repeat) {
      'יומי' => List<String>.from(_dailyDays),
      'שבועי' => [_weeklyDay!],
      _ => <String>[],
    };

    Navigator.pop(
      context,
      ReminderRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        time: _selectedTime == null ? null : _timeDisplay,
        repeat: _repeat,
        days: days,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 17)),
      backgroundColor: AppColors.terracotta,
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ─── build ────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(28)),
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

              Center(
                child: Text(
                  'הוספת תזכורת',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 28),

              // מה להזכיר
              _label('מה להזכיר לך?', required: true),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 19),
                autofocus: true,
                decoration: _inputDecor(
                    hint: 'למשל: לקחת תרופה, לצלצל לרופא...'),
              ),
              const SizedBox(height: 22),

              // שעה
              _label('שעה', required: false),
              const SizedBox(height: 10),
              _buildTimePicker(),
              const SizedBox(height: 22),

              // חזרה
              _label('חזרה', required: false),
              const SizedBox(height: 12),
              _buildRepeatChips(),

              // ימים לפי סוג חזרה
              if (_repeat == 'יומי') ...[
                const SizedBox(height: 22),
                _label('ימים', required: true),
                const SizedBox(height: 10),
                _buildMultiDaySelector(),
              ],
              if (_repeat == 'שבועי') ...[
                const SizedBox(height: 22),
                _label('יום בשבוע', required: true),
                const SizedBox(height: 10),
                _buildSingleDaySelector(),
              ],

              // הערה
              const SizedBox(height: 22),
              _label('הערה', required: false),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                style: const TextStyle(fontSize: 18),
                maxLines: 2,
                decoration:
                    _inputDecor(hint: 'למשל: אחרי ארוחת בוקר'),
              ),

              const SizedBox(height: 32),

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
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ביטול',
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textMedium)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── בחירת שעה ───────────────────────────────────────

  Widget _buildTimePicker() {
    final picked = _selectedTime != null;
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: picked ? AppColors.oliveGreen : Colors.grey.shade300,
            width: picked ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color:
                  picked ? AppColors.oliveGreen : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              _timeDisplay,
              style: TextStyle(
                fontSize: 19,
                color: picked ? AppColors.textDark : AppColors.textMedium,
                fontWeight:
                    picked ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (picked)
              GestureDetector(
                onTap: () => setState(() => _selectedTime = null),
                child: const Icon(Icons.close,
                    size: 20, color: AppColors.textMedium),
              )
            else
              const Text('לחצי לבחירה',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textMedium)),
          ],
        ),
      ),
    );
  }

  // ─── בחירת חזרה ──────────────────────────────────────

  Widget _buildRepeatChips() {
    const options = ['חד פעמי', 'יומי', 'שבועי', 'חודשי'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final on = _repeat == opt;
        return GestureDetector(
          onTap: () => setState(() {
            _repeat = opt;
            _dailyDays.clear();
            _weeklyDay = null;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: on ? AppColors.oliveGreen : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    on ? AppColors.oliveGreen : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    on ? FontWeight.bold : FontWeight.normal,
                color: on ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── ימים רב-בחירה (יומי) ────────────────────────────

  Widget _buildMultiDaySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kAllDays.map((day) {
        final on = _dailyDays.contains(day);
        return GestureDetector(
          onTap: () => setState(() {
            if (on) {
              _dailyDays.remove(day);
            } else {
              _dailyDays.add(day);
            }
          }),
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

  // ─── יום יחיד (שבועי) ────────────────────────────────

  Widget _buildSingleDaySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kAllDays.map((day) {
        final on = _weeklyDay == day;
        return GestureDetector(
          onTap: () => setState(() => _weeklyDay = day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: on ? AppColors.oliveGreen : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    on ? AppColors.oliveGreen : Colors.grey.shade300,
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

  // ─── עזרים ────────────────────────────────────────────

  Widget _label(String text, {required bool required}) {
    return Row(
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700)),
        if (required)
          const Text(' *',
              style: TextStyle(
                  color: AppColors.terracotta,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
      ],
    );
  }

  InputDecoration _inputDecor({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
          fontSize: 16, color: AppColors.textMedium),
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
