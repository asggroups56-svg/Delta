import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:my_template/features/home/presentation/view/screen/accounting_dashboard_screen.dart';

class AccountingDashboardShell extends StatefulWidget {
  const AccountingDashboardShell({super.key});

  @override
  State<AccountingDashboardShell> createState() =>
      _AccountingDashboardShellState();
}

class _AccountingDashboardShellState extends State<AccountingDashboardShell> {
  Future<void> _toggleLanguage() async {
    final next = context.locale.languageCode == 'ar' ? 'en' : 'ar';
    await context.setLocale(Locale(next));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AccountingDashboardScreen(
      embeddedInShell: true,
      onToggleLanguage: _toggleLanguage,
    );
  }
}
