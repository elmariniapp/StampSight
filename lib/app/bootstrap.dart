import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'routes/routing_state.dart';
import '../core/constants/storage_keys.dart';
import '../features/proofs/data/proof_repository.dart';
import '../features/clients/data/clients_repository.dart';
import '../features/session/domain/active_session_notifier.dart';
import '../features/settings/data/app_settings_repository.dart';
import '../l10n/app_locale.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await AppLocale.instance.load();
  await ProofRepository.instance.initialize();
  await ClientsRepository.instance.initialize();
  await AppSettingsRepository.instance.ensureLoaded();

  final prefs = await SharedPreferences.getInstance();
  final restoreSession =
      prefs.getBool(StorageKeys.restoreLastSession) ?? true;
  if (restoreSession) {
    await ActiveSessionNotifier.instance
        .restoreAfterClients(ClientsRepository.instance);
  } else {
    ActiveSessionNotifier.instance.endSession();
  }

  AppRoutingState.instance.onboardingComplete =
      prefs.getBool(StorageKeys.onboardingCompleted) ?? false;

  runApp(const StampSightApp());
}
