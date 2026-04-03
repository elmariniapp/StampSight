abstract final class StorageKeys {
  static const String proofsData = 'proofs_data';
  static const String overlayShowDate = 'overlay_show_date';
  static const String overlayShowTime = 'overlay_show_time';
  static const String overlayShowAddress = 'overlay_show_address';
  static const String overlayShowCoordinates = 'overlay_show_coordinates';
  static const String dateFormat = 'date_format';
  static const String timeFormat = 'time_format';
  static const String localeCode = 'locale_code';
  static const String defaultProofType = 'default_proof_type';
  static const String clientsData = 'clients_data';
  static const String sitesData = 'sites_data';
  static const String activeSessionData = 'active_session_data';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String locationRationaleAcknowledged =
      'location_rationale_acknowledged';

  // ---------------------------------------------------------------------------
  // Centre Réglages — préférences produit (préfixe cohérent)
  // ---------------------------------------------------------------------------
  static const String photoQuality = 'settings_photo_quality';
  static const String imageCompression = 'settings_image_compression';
  static const String openCameraFromNewProof = 'settings_open_camera_from_new';
  static const String cameraGridEnabled = 'settings_camera_grid';
  static const String multiPhotoPromptEnabled = 'settings_multi_photo_prompt';
  static const String persistCaptureChoices = 'settings_persist_capture_choices';
  static const String timeZoneMode = 'settings_timezone_mode';

  static const String exportIncludeClient = 'settings_export_include_client';
  static const String exportIncludeSite = 'settings_export_include_site';
  static const String exportIncludeNote = 'settings_export_include_note';
  static const String autoProofNaming = 'settings_auto_proof_naming';
  static const String autoProofReference = 'settings_auto_proof_reference';

  static const String openPdfAfterGeneration = 'settings_open_pdf_after';
  static const String proposeShareAfterPdf = 'settings_share_after_pdf';
  static const String includeAllPhotosInPdf = 'settings_pdf_include_all_photos';
  static const String pdfReportStyle = 'settings_pdf_report_style';
  static const String groupedReportAllowed = 'settings_grouped_report_allowed';
  static const String exportDefaultSortOrder = 'settings_export_sort_order';
  static const String pdfBrandingVisible = 'settings_pdf_branding_visible';
  static const String pdfCredibilityFooter = 'settings_pdf_credibility_footer';
  static const String pdfDetailedLocation = 'settings_pdf_detailed_location';

  static const String restoreLastSession = 'settings_restore_last_session';
  static const String confirmBeforeSessionChange =
      'settings_confirm_session_change';
  static const String confirmBeforeClientDelete =
      'settings_confirm_client_delete';
  static const String clientDeletePolicy = 'settings_client_delete_policy';
}
