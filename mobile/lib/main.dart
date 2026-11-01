import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase only when the generated project config is present.
  // The placeholder Firebase file is intentionally safe for local/dev builds.
  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final notificationService = AppNotificationService();
      await notificationService.initialize();
    } catch (e) {
      // ignore: avoid_print
      print('[DEV] Firebase init skipped: $e');
    }
  } else {
    // ignore: avoid_print
    print('[DEV] Firebase config not detected; app running in local-safe mode.');
  }

  runApp(const ProviderScope(child: PesoPlanApp()));
}

class PesoPlanApp extends ConsumerWidget {
  const PesoPlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ConnectivitySyncObserver(
      child: MaterialApp.router(
        title: 'Peso Plan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        routerConfig: router,
        locale: const Locale('en', 'PH'),
        supportedLocales: const [
          Locale('en', 'PH'),
          Locale('en', 'US'),
          Locale('fil', 'PH'),
        ],
      ),
    );
  }
}

class ConnectivitySyncObserver extends ConsumerStatefulWidget {
  const ConnectivitySyncObserver({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConnectivitySyncObserver> createState() =>
      _ConnectivitySyncObserverState();
}

class _ConnectivitySyncObserverState
    extends ConsumerState<ConnectivitySyncObserver> {
  bool _syncing = false;
  bool? _previousOnline;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(connectivityOnlineProvider, (previous, next) {
      next.whenData((online) async {
        ref.read(isOnlineProvider.notifier).state = online;
        final becameOnline = online && _previousOnline != true;
        _previousOnline = online;
        if (online && becameOnline && !_syncing) {
          _syncing = true;
          await ref.read(offlineQueueServiceProvider).syncAll();
          ref.invalidate(offlineQueueProvider);
          _syncing = false;
        }
      });
    });
    return widget.child;
  }
}
