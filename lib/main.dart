import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme.dart';
import 'models/reminder_record.dart';
import 'screens/home/home_screen.dart';
import 'screens/transactions/transactions_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onTabChange: _onTabChange,
        reminders: _reminders,
      ),
      const TransactionsScreen(),
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
