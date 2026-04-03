import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_locale.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class StampSightApp extends StatelessWidget {
  const StampSightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: AnimatedBuilder(
        animation: AppLocale.instance,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'StampSight',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: AppLocale.instance.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
