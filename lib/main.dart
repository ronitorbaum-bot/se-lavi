import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme.dart';
import 'models/money_record.dart';
import 'models/reminder_record.dart';
import 'screens/home/home_screen.dart';
import 'screens/transactions/transactions_screen.dart';
import 'screens/transactions/widgets/category_picker_sheet.dart';
import 'screens/transactions/widgets/expense_form_sheet.dart';
import 'screens/transactions/widgets/income_form_sheet.dart';
import 'screens/reminders/reminders_screen.dart';
import 'screens/contacts/contacts_screen.dart';

void main() {
  runApp(const SeLaviApp());
}

class SeLaviApp extends StatelessWidget {
  const SeLaviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'סה-לביא',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: const Locale('he', 'IL'),
      supportedLocales: const [Locale('he', 'IL')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<ReminderRecord> _reminders = [];
  final List<MoneyRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    final today = DateTime.now();
    _records.addAll([
      MoneyRecord(
        id: 'demo_1',
        type: 'income',
        category: 'תקציב',
        amount: 2000,
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 8, minute: 0, second: 0),
      ),
      MoneyRecord(
        id: 'demo_2',
        type: 'expense',
        category: 'כלבו',
        amount: 42,
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 9, minute: 30, second: 0),
      ),
      MoneyRecord(
        id: 'demo_3',
        type: 'expense',
        category: 'חשמל',
        amount: 180,
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 10, minute: 15, second: 0),
      ),
      MoneyRecord(
        id: 'demo_4',
        type: 'expense',
        category: 'כביסה',
        weight: 3.5,
        amount: 17.50,
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 11, minute: 0, second: 0),
      ),
      MoneyRecord(
        id: 'demo_5',
        type: 'expense',
        category: 'נסיעות',
        destination: 'טבריה',
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 13, minute: 45, second: 0),
      ),
      MoneyRecord(
        id: 'demo_6',
        type: 'expense',
        category: 'בריאות',
        amount: 65,
        extraText: '★ לדוגמה',
        createdAt: today.copyWith(hour: 15, minute: 30, second: 0),
      ),
    ]);
  }

  void _onTabChange(int index) => setState(() => _currentIndex = index);

  void _addReminder(ReminderRecord r) =>
      setState(() => _reminders.insert(0, r));

  void _deleteReminder(String id) =>
      setState(() => _reminders.removeWhere((r) => r.id == id));

  void _toggleDone(String id) {
    setState(() {
      final idx = _reminders.indexWhere((r) => r.id == id);
      if (idx != -1) _reminders[idx].isDone = !_reminders[idx].isDone;
    });
  }

  void _deleteRecord(String id) =>
      setState(() => _records.removeWhere((r) => r.id == id));

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('נרשם, תודה',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: const Text('הרישום נוסף לרשימה. אפשר להמשיך.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 56),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('הבנתי', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _openExpenseFlow() async {
    final category = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CategoryPickerSheet(),
    );
    if (category == null || !mounted) return;

    final record = await showModalBottomSheet<MoneyRecord>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExpenseFormSheet(category: category),
    );

    if (record != null && mounted) {
      setState(() => _records.insert(0, record));
      _showSuccessDialog();
    }
  }

  Future<void> _openIncomeForm() async {
    final record = await showModalBottomSheet<MoneyRecord>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const IncomeFormSheet(),
    );

    if (record != null && mounted) {
      setState(() => _records.insert(0, record));
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onTabChange: _onTabChange,
        reminders: _reminders,
        onOpenExpenseForm: _openExpenseFlow,
        onOpenIncomeForm: _openIncomeForm,
      ),
      TransactionsScreen(
        records: _records,
        onOpenExpense: _openExpenseFlow,
        onOpenIncome: _openIncomeForm,
        onDelete: _deleteRecord,
      ),
      RemindersScreen(
        reminders: _reminders,
        onAdd: _addReminder,
        onDelete: _deleteReminder,
        onToggleDone: _toggleDone,
      ),
      const ContactsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_outlined),
            activeIcon: Icon(Icons.wb_sunny),
            label: 'היום שלי',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'כספים',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'תזכורות',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'אנשי קשר',
          ),
        ],
      ),
    );
  }
}
