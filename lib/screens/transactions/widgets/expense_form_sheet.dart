import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/money_record.dart';
import '../../../widgets/app_text_field.dart';

class ExpenseFormSheet extends StatefulWidget {
  final String category;
  const ExpenseFormSheet({super.key, required this.category});

  @override
  State<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<ExpenseFormSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _monthController = TextEditingController();
  final _weightController = TextEditingController();
  final _destinationController = TextEditingController();
  final _medicineController = TextEditingController();
  final _doctorController = TextEditingController();
  final _forWhoController = TextEditingController();
  String? _healthAction;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _monthController.dispose();
    _weightController.dispose();
    _destinationController.dispose();
    _medicineController.dispose();
    _doctorController.dispose();
    _forWhoController.dispose();
    super.dispose();
  }

  bool _validate() {
    switch (widget.category) {
      case 'כביסה':
        return _weightController.text.trim().isNotEmpty;
      case 'נסיעות':
        return _destinationController.text.trim().isNotEmpty;
      case 'בריאות':
        return _healthAction != null;
      default:
        return _amountController.text.trim().isNotEmpty;
    }
  }

  String? _buildExtraText() {
    final parts = <String>[];
    if (_healthAction != null) parts.add(_healthAction!);
    if (_medicineController.text.trim().isNotEmpty) {
      parts.add('תרופה: ${_medicineController.text.trim()}');
    }
    if (_doctorController.text.trim().isNotEmpty) {
      parts.add('רופא: ${_doctorController.text.trim()}');
    }
    if (_forWhoController.text.trim().isNotEmpty) {
      parts.add(_forWhoController.text.trim());
    }
    if (_monthController.text.trim().isNotEmpty) {
      parts.add('חודש: ${_monthController.text.trim()}');
    }
    return parts.isEmpty ? null : parts.join(' | ');
  }

  void _onSave() {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('נא למלא את השדות החובה',
              style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.terracotta,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final record = MoneyRecord(
      id: now.millisecondsSinceEpoch.toString(),
      type: 'expense',
      category: widget.category,
      amount: double.tryParse(_amountController.text.trim()),
      weight: double.tryParse(_weightController.text.trim()),
      destination: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      extraText: _buildExtraText(),
      createdAt: now,
    );

    Navigator.pop(context, record);
  }

  Widget _buildFields() {
    switch (widget.category) {
      case 'כלבו':
        return _col([
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              isRequired: true,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'חשמל':
        return _col([
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              isRequired: true,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(
              label: 'חודש',
              controller: _monthController,
              hint: 'ינואר 2025'),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'כביסה':
        return _col([
          AppTextField(
              label: 'משקל (ק"ג)',
              controller: _weightController,
              isRequired: true,
              hint: '5',
              keyboardType: TextInputType.number),
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'נסיעות':
        return _col([
          AppTextField(
              label: 'יעד',
              controller: _destinationController,
              isRequired: true,
              hint: 'לאן נסעת?'),
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'קופת משק':
        return _col([
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              isRequired: true,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'בריאות':
        return _col([
          _healthPicker(),
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(
              label: 'שם תרופה', controller: _medicineController),
          AppTextField(label: 'רופא', controller: _doctorController),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      case 'פינוקים ומשפחה':
        return _col([
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              isRequired: true,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(
              label: 'עבור מי / עבור מה',
              controller: _forWhoController),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
      default:
        return _col([
          AppTextField(
              label: 'סכום',
              controller: _amountController,
              isRequired: true,
              hint: '0.00',
              keyboardType: TextInputType.number),
          AppTextField(label: 'הערה', controller: _noteController),
        ]);
    }
  }

  Widget _col(List<Widget> widgets) {
    return Column(
      children: widgets
          .map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 16), child: w))
          .toList(),
    );
  }

  Widget _healthPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Text('סוג פעולה',
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(' *',
              style:
                  TextStyle(color: AppColors.terracotta, fontSize: 18)),
        ]),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: ['הוצאה רפואית', 'תרופה', 'תור'].map((action) {
            final selected = _healthAction == action;
            return ChoiceChip(
              label: Text(action,
                  style: TextStyle(
                      fontSize: 17,
                      color: selected
                          ? Colors.white
                          : AppColors.textDark)),
              selected: selected,
              selectedColor: AppColors.oliveGreen,
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.oliveGreen),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              onSelected: (on) {
                if (on) setState(() => _healthAction = action);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88),
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
                'הוצאה — ${widget.category}',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                'התאריך יירשם אוטומטית להיום',
                style: TextStyle(fontSize: 15, color: AppColors.textMedium),
              ),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('בחירת תאריך תתווסף בהמשך')),
                ),
                child: const Text('לא היום?',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textMedium)),
              ),
              const SizedBox(height: 4),
              _buildFields(),
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
            ],
          ),
        ),
      ),
    );
  }
}
