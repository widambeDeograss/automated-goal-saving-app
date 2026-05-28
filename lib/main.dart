import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/wallet.dart';
import 'state/wallet_provider.dart';
import 'theme/tokens.dart';
import 'screens/akiba_hub_screen.dart';
import 'screens/wallet_type_choice_screen.dart';
import 'screens/create_step1_screen.dart';
import 'screens/create_step2_screen.dart';
import 'screens/create_step3_screen.dart';
import 'screens/create_lock_period_screen.dart';
import 'screens/create_group_members_screen.dart';
import 'screens/create_confirm_screen.dart';
import 'screens/wallet_detail_screen.dart';
import 'screens/group_detail_screen.dart';
import 'screens/fund_wallet_screen.dart';
import 'screens/withdraw_funds_screen.dart';
import 'screens/withdraw_request_form_screen.dart';
import 'screens/edit_wallet_screen.dart';
import 'screens/goal_reached_screen.dart';
import 'screens/invitations_inbox_screen.dart';
import 'screens/approvals_list_screen.dart';
import 'screens/approve_request_screen.dart';
import 'screens/spend_prompt_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: const PesahakikaApp(),
    ),
  );
}

class PesahakikaApp extends StatefulWidget {
  const PesahakikaApp({super.key});

  @override
  State<PesahakikaApp> createState() => _PesahakikaAppState();
}

class _PesahakikaAppState extends State<PesahakikaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() => setState(() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PESAHAKIKA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      initialRoute: '/',
      onGenerateRoute: (settings) => _generateRoute(settings, _toggleTheme),
    );
  }
}

Route<dynamic> _generateRoute(RouteSettings settings, VoidCallback toggleTheme) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AkibaHubScreen(), settings: settings);

    case '/create/choose':
      return MaterialPageRoute(builder: (_) => const WalletTypeChoiceScreen(), settings: settings);

    case '/create/step1':
      final draft = settings.arguments as WalletDraft? ?? WalletDraft();
      return MaterialPageRoute(builder: (_) => CreateStep1Screen(draft: draft), settings: settings);

    case '/create/step2':
      final draft = settings.arguments as WalletDraft;
      return MaterialPageRoute(builder: (_) => CreateStep2Screen(draft: draft), settings: settings);

    case '/create/step3':
      final draft = settings.arguments as WalletDraft;
      return MaterialPageRoute(builder: (_) => CreateStep3Screen(draft: draft), settings: settings);

    case '/create/lock':
      final draft = settings.arguments as WalletDraft;
      return MaterialPageRoute(builder: (_) => CreateLockPeriodScreen(draft: draft), settings: settings);

    case '/create/members':
      final draft = settings.arguments as WalletDraft;
      return MaterialPageRoute(builder: (_) => CreateGroupMembersScreen(draft: draft), settings: settings);

    case '/create/confirm':
      final draft = settings.arguments as WalletDraft;
      return MaterialPageRoute(builder: (_) => CreateConfirmScreen(draft: draft), settings: settings);

    case '/detail':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => WalletDetailScreen(walletId: walletId), settings: settings);

    case '/group-detail':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => GroupDetailScreen(walletId: walletId), settings: settings);

    case '/fund':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => FundWalletScreen(walletId: walletId), settings: settings);

    case '/withdraw':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => WithdrawFundsScreen(walletId: walletId), settings: settings);

    case '/group-withdraw':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => WithdrawRequestFormScreen(walletId: walletId), settings: settings);

    case '/edit':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => EditWalletScreen(walletId: walletId), settings: settings);

    case '/goal-reached':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => GoalReachedScreen(walletId: walletId), settings: settings);

    case '/invitations':
      return MaterialPageRoute(builder: (_) => const InvitationsInboxScreen(), settings: settings);

    case '/approvals':
      return MaterialPageRoute(builder: (_) => const ApprovalsListScreen(), settings: settings);

    case '/approve':
      final requestId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => ApproveRequestScreen(requestId: requestId), settings: settings);

    case '/spend-prompt':
      final walletId = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => SpendPromptScreen(walletId: walletId), settings: settings);

    default:
      return MaterialPageRoute(builder: (_) => const AkibaHubScreen());
  }
}
