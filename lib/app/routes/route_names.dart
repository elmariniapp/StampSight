abstract final class RouteNames {
  static const String home = 'home';
  static const String capture = 'capture';
  static const String captureConfirm = 'capture-confirm';
  static const String library = 'library';
  static const String proofDetail = 'proof-detail';
  static const String settings = 'settings';
  static const String clients = 'clients';
  static const String clientDetail = 'client-detail';
  static const String clientNew = 'client-new';
  static const String clientEdit = 'client-edit';
  static const String siteNew = 'site-new';
  static const String siteEdit = 'site-edit';
  static const String contextPicker = 'context-picker';
  static const String onboarding = 'onboarding';
  static const String paywall = 'paywall';
  static const String settingsGeneral = 'settings-general';
  static const String settingsCapture = 'settings-capture';
  static const String settingsMetadata = 'settings-metadata';
  static const String settingsExports = 'settings-exports';
  static const String settingsSession = 'settings-session';
  static const String settingsStorage = 'settings-storage';
  static const String settingsPermissions = 'settings-permissions';
  static const String settingsPro = 'settings-pro';
  static const String settingsHelp = 'settings-help';
  static const String settingsAbout = 'settings-about';
  static const String settingsLegal = 'settings-legal';
}

abstract final class RoutePaths {
  static const String home = '/';
  static const String capture = '/capture';
  static const String captureConfirm = '/capture/confirm';
  static const String library = '/library';
  static const String proofDetail = '/proof/:id';
  static const String settings = '/settings';
  static const String clients = '/clients';
  static const String clientDetail = '/clients/:clientId';
  static const String clientNew = '/clients/new';
  static const String clientEdit = '/clients/:clientId/edit';
  static const String siteNew = '/sites/new';
  static const String siteEdit = '/sites/:siteId/edit';
  static const String contextPicker = '/context-picker';
  static const String onboarding = '/onboarding';
  static const String paywall = '/paywall';

  static const String settingsGeneral = '/settings/general';
  static const String settingsCapture = '/settings/capture-settings';
  static const String settingsMetadata = '/settings/metadata';
  static const String settingsExports = '/settings/exports';
  static const String settingsSession = '/settings/session';
  static const String settingsStorage = '/settings/storage';
  static const String settingsPermissions = '/settings/permissions';
  static const String settingsPro = '/settings/pro';
  static const String settingsHelp = '/settings/help';
  static const String settingsAbout = '/settings/about';
  static String settingsLegalKind(String kind) => '/settings/legal/$kind';

  static String proofDetailFor(String id) => '/proof/$id';
  static String clientDetailFor(String id) => '/clients/$id';
  static String clientEditFor(String id) => '/clients/$id/edit';
  static String siteEditFor(String id) => '/sites/$id/edit';
}
