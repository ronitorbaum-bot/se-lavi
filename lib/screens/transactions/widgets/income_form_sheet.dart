import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/money_record.dart';
import '../../../widgets/app_text_field.dart';

class IncomeFormSheet extends StatefulWidget {
  const IncomeFormSheet({super.key});

  @override
  State<IncomeFormSheet> createState() => _IncomeFormSheetState();
}

class _IncomeFormSheetState extends State<IncomeFormSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _monthController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('נא להזין סכום', style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.terracotta,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final record = MoneyRecord(
      id: now.millisecondsSinceEpoch.toString(),
      type: 'income',
      category: 'תקציב',
      amount: double.tryParse(_amountController.text.trim()),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      extraText: _monthController.text.trim().isEmpty
          ? null
          : 'חודש: ${_monthController.text.trim()}',
      createdAt: now,
    );

    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
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
                'רישום הכנסה — תקציב',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'התאריך יירשם אוטומטית להיום',
                style: TextStyle(
                    fontSize: 15, color: AppColors.textMedium),
              ),
              const SizedBox(height: 20),
              AppTextField(
                  label: 'סכום',
                  controller: _amountController,
                  isRequired: true,
                  hint: '0.00',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              AppTextField(
                  label: 'חודש',
                  controller: _monthController,
                  hint: 'ינואר 2025'),
              const SizedBox(height: 16),
              AppTextField(
                  label: 'הערה', controller: _noteController),
              const SizedBox(height: 24),
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
}
