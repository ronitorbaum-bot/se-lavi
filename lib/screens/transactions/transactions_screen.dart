import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/money_record.dart';
import '../../widgets/large_action_button.dart';

// רשימת כל הקטגוריות הקבועות
const List<String> _allCategories = [
  'כלבו',
  'חשמל',
  'כביסה',
  'נסיעות',
  'קופת משק',
  'בריאות',
  'פינוקים ומשפחה',
  'אחר',
  'תקציב',
];

// מחלקת עזר לסיכום לפי קטגוריה
class _CategorySummary {
  final String category;
  int count = 0;
  double totalAmount = 0;
  double totalWeight = 0;
  _CategorySummary(this.category);
}

class TransactionsScreen extends StatefulWidget {
  final List<MoneyRecord> records;
  final VoidCallback onOpenExpense;
  final VoidCallback onOpenIncome;
  final void Function(String id) onDelete;

  const TransactionsScreen({
    super.key,
    required this.records,
    required this.onOpenExpense,
    required this.onOpenIncome,
    required this.onDelete,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String _sortBy = 'newest';
  String _filterCategory = 'הכול';
  bool _showOnlyWithRecords = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── חישובים ───────────────────────────────────────────

  double get _totalIncome => widget.records
      .where((r) => r.type == 'income' && r.amount != null)
      .fold(0.0, (sum, r) => sum + r.amount!);

  double get _totalExpense => widget.records
      .where((r) => r.type == 'expense' && r.amount != null)
      .fold(0.0, (sum, r) => sum + r.amount!);

  List<MoneyRecord> get _filteredSortedRecords {
    var list = _filterCategory == 'הכול'
        ? List<MoneyRecord>.from(widget.records)
        : widget.records.where((r) => r.category == _filterCategory).toList();

    switch (_sortBy) {
      case 'newest':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'amount_desc':
        list.sort((a, b) => (b.amount ?? -1).compareTo(a.amount ?? -1));
        break;
      case 'amount_asc':
        list.sort((a, b) {
          if (a.amount == null && b.amount == null) return 0;
          if (a.amount == null) return 1;
          if (b.amount == null) return -1;
          return a.amount!.compareTo(b.amount!);
        });
        break;
      case 'category':
        list.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
    return list;
  }

  List<_CategorySummary> get _categorySummaries {
    final map = {for (final cat in _allCategories) cat: _CategorySummary(cat)};

    for (final r in widget.records) {
      final s = map[r.category];
      if (s == null) continue;
      s.count++;
      if (r.amount != null) s.totalAmount += r.amount!;
      if (r.weight != null) s.totalWeight += r.weight!;
    }

    final all = map.values.toList();
    return _showOnlyWithRecords ? all.where((s) => s.count > 0).toList() : all;
  }

  // ─── דיאלוגים ─────────────────────────────────────────

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('למחוק רישום?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: const Text('אפשר למחוק, אבל אי אפשר לשחזר.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
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
                  widget.onDelete(id);
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

  // ─── עזרים ────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day/$month  $hour:$min';
  }

  // ─── Widgets ──────────────────────────────────────────

  Widget _buildRecordTile(MoneyRecord record) {
    final isIncome = record.type == 'income';
    final tileColor =
        isIncome ? const Color(0x206B7C3F) : const Color(0x20C1654A);
    final iconColor =
        isIncome ? AppColors.oliveGreen : AppColors.terracotta;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(record.category,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(record.typeLabel,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white)),
                      ),
                    ],
                  ),
                  if (record.summaryText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(record.summaryText,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: iconColor)),
                    ),
                  if (record.extraText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(record.extraText!,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textMedium)),
                    ),
                  if (record.note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(record.note!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textMedium),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_formatDate(record.createdAt),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.terracotta, size: 26),
              onPressed: () => _confirmDelete(record.id),
            ),
          ],
        ),
      ),
    );
  }

  // שורת מיון + סינון
  Widget _buildSortFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              label: 'מיון',
              value: _sortBy,
              items: const {
                'newest': 'חדש קודם',
                'oldest': 'ישן קודם',
                'amount_desc': 'גבוה קודם',
                'amount_asc': 'נמוך קודם',
                'category': 'קטגוריה',
              },
              onChanged: (val) => setState(() => _sortBy = val!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdown(
              label: 'קטגוריה',
              value: _filterCategory,
              items: {
                'הכול': 'הכול',
                for (final c in _allCategories) c: c,
              },
              onChanged: (val) =>
                  setState(() => _filterCategory = val!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textMedium)),
        const SizedBox(height: 4),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.oliveGreen),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            style: const TextStyle(
                fontSize: 15, color: AppColors.textDark),
            items: items.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value,
                          style: const TextStyle(fontSize: 15)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ─── טאב רישום ────────────────────────────────────────

  Widget _buildDemoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD966), width: 1.5),
      ),
      child: Row(
        children: const [
          Icon(Icons.star_outline, color: Color(0xFF856404), size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'גרסת הדגמה — הנתונים כאן הם לדוגמה בלבד',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF856404),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationTab() {
    final filtered = _filteredSortedRecords;

    return Column(
      children: [
        _buildDemoBanner(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              LargeActionButton(
                label: 'רישום הוצאה',
                icon: Icons.arrow_upward,
                backgroundColor: AppColors.terracotta,
                onPressed: widget.onOpenExpense,
              ),
              const SizedBox(height: 12),
              LargeActionButton(
                label: 'רישום הכנסה',
                icon: Icons.arrow_downward,
                backgroundColor: AppColors.oliveGreen,
                onPressed: widget.onOpenIncome,
              ),
            ],
          ),
        ),
        _buildSortFilterRow(),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          _filterCategory == 'הכול'
                              ? 'כאן אפשר לראות מה שנרשם'
                              : 'אין רישומים בקטגוריה "$_filterCategory"',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: AppColors.textMedium),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      _buildRecordTile(filtered[i]),
                ),
        ),
      ],
    );
  }

  // ─── טאב סיכומים ──────────────────────────────────────

  Widget _buildSummaryTab() {
    final balance = _totalIncome - _totalExpense;
    final summaries = _categorySummaries;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // סיכום כולל
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _summaryRow('סה"כ הכנסות', _totalIncome,
                      AppColors.oliveGreen),
                  const Divider(height: 28),
                  _summaryRow('סה"כ הוצאות', _totalExpense,
                      AppColors.terracotta),
                  const Divider(height: 28),
                  _summaryRow(
                    'יתרה משוערת',
                    balance,
                    balance >= 0
                        ? AppColors.oliveGreen
                        : AppColors.terracotta,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // כותרת קטגוריות + טוגל
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('סיכום פשוט לפי נושאים',
                  style: Theme.of(context).textTheme.titleLarge),
              TextButton.icon(
                onPressed: () => setState(() =>
                    _showOnlyWithRecords = !_showOnlyWithRecords),
                icon: Icon(
                  _showOnlyWithRecords
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 20,
                  color: AppColors.oliveGreen,
                ),
                label: Text(
                  'עם רישומים בלבד',
                  style: TextStyle(
                    fontSize: 14,
                    color: _showOnlyWithRecords
                        ? AppColors.oliveGreen
                        : AppColors.textMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...summaries.map(_buildCategorySummaryCard),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 18, color: AppColors.textMedium)),
        Text(
          '₪${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color),
        ),
      ],
    );
  }

  void _openCategoryDetail(String category) {
    final records = widget.records
        .where((r) => r.category == category)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryDetailSheet(
        category: category,
        records: records,
        formatDate: _formatDate,
      ),
    );
  }

  Widget _buildCategorySummaryCard(_CategorySummary s) {
    final hasRecords = s.count > 0;
    return GestureDetector(
      onTap: () => _openCategoryDetail(s.category),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasRecords
                ? AppColors.oliveGreen
                : Colors.grey.shade200,
            width: hasRecords ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.category,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: hasRecords
                          ? AppColors.textDark
                          : Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    s.count == 0 ? 'אין רישומים — לחצי לפירוט' : '${s.count} רישומים — לחצי לפירוט',
                    style: TextStyle(
                      fontSize: 14,
                      color: hasRecords
                          ? AppColors.textMedium
                          : Colors.grey.shade400,
                    ),
                  ),
                  if (s.category == 'כביסה' && s.totalWeight > 0)
                    Text(
                      'סה"כ משקל: ${s.totalWeight.toStringAsFixed(1)} ק"ג',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textMedium),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '₪${s.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: hasRecords
                        ? AppColors.terracotta
                        : Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_left,
                    color: hasRecords
                        ? AppColors.oliveGreen
                        : Colors.grey.shade300),
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
      appBar: AppBar(
        title: const Text('הכנסות והוצאות'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'רישום'),
            Tab(text: 'סיכומים'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          indicatorColor: AppColors.sunrise,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegistrationTab(),
          _buildSummaryTab(),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet פירוט קטגוריה ─────────────────────────

class _CategoryDetailSheet extends StatelessWidget {
  final String category;
  final List<MoneyRecord> records;
  final String Function(DateTime) formatDate;

  const _CategoryDetailSheet({
    required this.category,
    required this.records,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
            'פירוט: $category',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: records.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'אין עדיין רישומים בקטגוריה הזו',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.textMedium),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: records.length,
                    itemBuilder: (_, i) => _buildDetailTile(context, records[i]),
                  ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: const Text(
              'סגירה',
              style: TextStyle(fontSize: 18, color: AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, MoneyRecord r) {
    final isIncome = r.type == 'income';
    final accentColor =
        isIncome ? AppColors.oliveGreen : AppColors.terracotta;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.typeLabel,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  formatDate(r.createdAt),
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (r.summaryText.isNotEmpty)
              Text(
                r.summaryText,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: accentColor),
              ),
            if (r.destination != null)
              Text('יעד: ${r.destination!}',
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.textDark)),
            if (r.extraText != null)
              Text(r.extraText!,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textMedium)),
            if (r.note != null)
              Text(r.note!,
                  style: const TextStyle(
                      fontSize: 15, color: AppColors.textMedium)),
          ],
        ),
      ),
    );
  }
}
