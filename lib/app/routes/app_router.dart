import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'routing_state.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/capture/domain/capture_launch_mode.dart';
import '../../features/capture/presentation/capture_screen.dart';
import '../../features/capture/presentation/capture_confirm_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/proofs/presentation/proof_detail_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/pages/settings_about_page.dart';
import '../../features/settings/presentation/pages/settings_capture_page.dart';
import '../../features/settings/presentation/pages/settings_exports_page.dart';
import '../../features/settings/presentation/pages/settings_general_page.dart';
import '../../features/settings/presentation/pages/settings_help_legal_page.dart';
import '../../features/settings/presentation/pages/settings_legal_placeholder_page.dart';
import '../../features/settings/presentation/pages/settings_metadata_page.dart';
import '../../features/settings/presentation/pages/settings_permissions_page.dart';
import '../../features/settings/presentation/pages/settings_pro_page.dart';
import '../../features/settings/presentation/pages/settings_session_page.dart';
import '../../features/settings/presentation/pages/settings_storage_page.dart';
import '../../features/clients/presentation/clients_list_screen.dart';
import '../../features/clients/presentation/client_detail_screen.dart';
import '../../features/clients/presentation/client_form_screen.dart';
import '../../features/clients/presentation/site_mission_form_screen.dart';
import '../../features/context/presentation/context_picker_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/paywall/presentation/paywall_screen.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutingState.instance.onboardingComplete
        ? RoutePaths.home
        : RoutePaths.onboarding,
    refreshListenable: AppRoutingState.instance,
    redirect: (context, state) {
      final done = AppRoutingState.instance.onboardingComplete;
      final loc = state.matchedLocation;
      if (!done && loc != RoutePaths.onboarding) {
        return RoutePaths.onboarding;
      }
      if (done && loc == RoutePaths.onboarding) {
        return RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.paywall,
        name: RouteNames.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.capture,
        name: RouteNames.capture,
        builder: (context, state) {
          final mode = state.extra is CaptureLaunchMode
              ? state.extra! as CaptureLaunchMode
              : CaptureLaunchMode.newProof;
          return CaptureScreen(launchMode: mode);
        },
      ),
      GoRoute(
        path: RoutePaths.captureConfirm,
        name: RouteNames.captureConfirm,
        builder: (context, state) => CaptureConfirmScreen(
              capturedImagePath: state.extra as String?,
            ),
      ),
      GoRoute(
        path: RoutePaths.library,
        name: RouteNames.library,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: RoutePaths.proofDetail,
        name: RouteNames.proofDetail,
        builder: (context, state) => ProofDetailScreen(
          proofId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'general',
            name: RouteNames.settingsGeneral,
            builder: (context, state) => const SettingsGeneralPage(),
          ),
          GoRoute(
            path: 'capture-settings',
            name: RouteNames.settingsCapture,
            builder: (context, state) => const SettingsCapturePage(),
          ),
          GoRoute(
            path: 'metadata',
            name: RouteNames.settingsMetadata,
            builder: (context, state) => const SettingsMetadataPage(),
          ),
          GoRoute(
            path: 'exports',
            name: RouteNames.settingsExports,
            builder: (context, state) => const SettingsExportsPage(),
          ),
          GoRoute(
            path: 'session',
            name: RouteNames.settingsSession,
            builder: (context, state) => const SettingsSessionPage(),
          ),
          GoRoute(
            path: 'storage',
            name: RouteNames.settingsStorage,
            builder: (context, state) => const SettingsStoragePage(),
          ),
          GoRoute(
            path: 'permissions',
            name: RouteNames.settingsPermissions,
            builder: (context, state) => const SettingsPermissionsPage(),
          ),
          GoRoute(
            path: 'pro',
            name: RouteNames.settingsPro,
            builder: (context, state) => const SettingsProPage(),
          ),
          GoRoute(
            path: 'help',
            name: RouteNames.settingsHelp,
            builder: (context, state) => const SettingsHelpLegalPage(),
          ),
          GoRoute(
            path: 'about',
            name: RouteNames.settingsAbout,
            builder: (context, state) => const SettingsAboutPage(),
          ),
          GoRoute(
            path: 'legal/:kind',
            name: RouteNames.settingsLegal,
            builder: (context, state) => SettingsLegalPlaceholderPage(
                  titleKey: state.pathParameters['kind'] ?? 'unknown',
                ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.clients,
        name: RouteNames.clients,
        builder: (context, state) => const ClientsListScreen(),
      ),
      GoRoute(
        path: RoutePaths.clientNew,
        name: RouteNames.clientNew,
        builder: (context, state) => const ClientFormScreen(),
      ),
      GoRoute(
        path: RoutePaths.clientDetail,
        name: RouteNames.clientDetail,
        builder: (context, state) => ClientDetailScreen(
          clientId: state.pathParameters['clientId']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.clientEdit,
        name: RouteNames.clientEdit,
        builder: (context, state) => ClientFormScreen(
          clientId: state.pathParameters['clientId'],
        ),
      ),
      GoRoute(
        path: RoutePaths.siteNew,
        name: RouteNames.siteNew,
        builder: (context, state) => SiteMissionFormScreen(
          clientId: state.uri.queryParameters['clientId'],
        ),
      ),
      GoRoute(
        path: RoutePaths.siteEdit,
        name: RouteNames.siteEdit,
        builder: (context, state) => SiteMissionFormScreen(
          siteId: state.pathParameters['siteId'],
        ),
      ),
      GoRoute(
        path: RoutePaths.contextPicker,
        name: RouteNames.contextPicker,
        builder: (context, state) => const ContextPickerScreen(),
      ),
    ],
  );
}
