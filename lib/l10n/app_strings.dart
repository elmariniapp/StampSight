abstract class AppStrings {
  const AppStrings();

  String get languageCode;

  String get appTagline;
  String get homeTitle;
  String get homeHeadline;
  String get homeSupportingText;
  String get newProof;
  String get capture;
  String get importAction;
  String get share;
  String get exportAction;
  String get delete;
  String get cancel;
  String get close;
  String get save;
  String get viewAll;
  String get all;
  String get libraryTitle;
  String get settingsTitle;
  String get captureTitle;
  String get proofDetailTitle;
  String get recentProofs;
  String get cameraPreview;
  String get captureComingSoon;
  String get importComingSoon;
  String get overlay;
  String get overlayPreferences;
  String get date;
  String get time;
  String get address;
  String get gpsCoordinates;
  String get showDate;
  String get showTime;
  String get showAddress;
  String get showCoordinates;
  String get language;
  String get french;
  String get english;
  String get formats;
  String get dateFormat;
  String get timeFormat;
  String get branding;
  String get brandingPlaceholder;
  String get about;
  String get metadata;
  String get coordinates;
  String get overlayDate;
  String get overlayTime;
  String get source;
  String get sourceLocal;
  String get favorite;
  String get librarySearchHint;
  String get favoritesOnly;
  String get sortNewestFirst;
  String get sortOldestFirst;
  String get sortFavoritesFirst;
  String get allTypes;
  String get noProofFound;
  String get proofsWillAppearHere;
  String get emptyHomeTitle;
  String get emptyHomeSubtitle;
  String get emptyHomeCta;
  String get emptyLibraryTitle;
  String get emptyLibrarySubtitle;
  String get captureProof;
  String get detail;
  String get proofNotFound;
  String get shareComingSoon;
  String get exportComingSoon;
  String get exportPdf;
  String get pdfGenerating;
  String get exportImageSaved;
  String get shareFailed;
  String get pdfFailed;
  String get deleteProofTitle;
  String get deleteProofMessage;
  String get proLabel;
  String get proDescription;
  String get proComingSoon;

  // Onboarding
  String get onboardingNext;
  String get onboardingStart;
  String get onboardingSlide1Title;
  String get onboardingSlide1Body;
  String get onboardingSlide2Title;
  String get onboardingSlide2Body;
  String get onboardingSlide3Title;
  String get onboardingSlide3Body;
  String get onboardingSlide1Kicker;
  String get onboardingSlide2Kicker;
  String get onboardingSlide3Kicker;
  String get onboardingSlide1Benefit1;
  String get onboardingSlide1Benefit2;
  String get onboardingSlide1Benefit3;
  String get onboardingSlide2Benefit1;
  String get onboardingSlide2Benefit2;
  String get onboardingSlide2Benefit3;
  String get onboardingSlide3Benefit1;
  String get onboardingSlide3Benefit2;
  String get onboardingSlide3Benefit3;
  String get onboardingTrustRow;
  String get onboardingPrivacyCompact;

  String get onboardingMicroProofHeadline;
  String get onboardingMicroProofRow1Label;
  String get onboardingMicroProofRow1Value;
  String get onboardingMicroProofRow2Label;
  String get onboardingMicroProofRow2Value;
  String get onboardingMicroProofRow3Label;
  String get onboardingMicroProofRow3Value;
  String get onboardingMicroProofBadge;

  String get onboardingMicroContextHeadline;
  String get onboardingMicroContextRow1Label;
  String get onboardingMicroContextRow1Value;
  String get onboardingMicroContextRow2Label;
  String get onboardingMicroContextRow2Value;
  String get onboardingMicroContextRow3Label;
  String get onboardingMicroContextRow3Value;
  String get onboardingMicroContextBadge;

  String get onboardingMicroDeliverHeadline;
  String get onboardingMicroDeliverRow1Label;
  String get onboardingMicroDeliverRow1Value;
  String get onboardingMicroDeliverRow2Label;
  String get onboardingMicroDeliverRow2Value;
  String get onboardingMicroDeliverRow3Label;
  String get onboardingMicroDeliverRow3Value;
  String get onboardingMicroDeliverBadge;

  String get locationRationaleTitle;
  String get locationRationaleBody;
  String get locationRationaleContinue;

  /// Pré-permissions contextuelles (capture / enregistrement)
  String get permissionSheetContinue;
  String get cameraPrePermissionTitle;
  String get cameraPrePermissionBody;
  String get locationPrePermissionTitle;
  String get locationPrePermissionBody;
  String get locationPrePermissionBodySettings;

  // Paywall / pricing
  String get paywallHeadline;
  String get paywallSubtitle;
  String get paywallPlanFree;
  String get paywallPlanPro;
  String get paywallRecommended;
  String get paywallFreeFeature1;
  String get paywallFreeFeature2;
  String get paywallFreeFeature3;
  String get paywallProFeature1;
  String get paywallProFeature2;
  String get paywallProFeature3;
  String get paywallContinueFree;
  String get paywallBillingNote;

  String get proofTypeInspection;
  String get proofTypeDelivery;
  String get proofTypeWorkProgress;
  String get proofTypeIncident;
  String get proofTypeInventory;
  String get proofTypeOther;
  String get justNow;
  String get dateFormatEuropean;
  String get dateFormatUs;
  String get timeFormat24h;
  String get timeFormat12h;
  String get termsOfService;
  String get privacyPolicy;
  String get legalNotice;

  String proofCount(int count);
  String versionLabel(String version);
  String minutesAgo(int count);
  String hoursAgo(int count);
  String daysAgo(int count);

  // Navigation
  String get myProofsTitle;
  String get clientsTitle;

  // Session
  String get activeSession;
  String get noActiveSession;
  String get startSession;
  String get changeContext;
  String get endSession;
  String get nextProofsWillUse;
  String get chooseContext;
  String get sessionEmptyHint;
  String get sessionWith;

  // Context
  String get context;
  String get skip;
  String get validate;
  String get chooseClient;
  String get chooseSite;
  String get siteForClient;
  String get modifyContext;
  String get unclassified;
  String get noContext;
  String get addContext;
  String get contextUpdated;
  String get proofSaved;
  String get proofSaveFailed;

  /// Titre auto : type · date · heure (réglage nommage auto).
  String autoStyledProofTitle(String typeLabel, String dateLine, String timeLine);

  /// Ligne de description pour la référence auto (alignée PDF).
  String proofReferenceLine(String referenceId);

  String get shareProofCoverPhoto;
  String get exportProofCoverPhoto;

  String get supportEmailCopied;
  String get settingsStorageActionFailed;

  String get saveAndNewProof;
  String get confirmProof;
  String defaultProofTitle(String formattedDate);
  String get proofType;
  String get note;
  String get noteOptional;
  String get noNote;
  String get addNote;
  String get classifiedAs;

  // Client
  String get newClient;
  String get editClient;
  String get clientName;
  String get clientNotFound;
  String get clientNameHint;
  String get company;
  String get companyHint;
  String get color;
  String get clientNote;
  String get noClients;
  String get emptyClientsSubtitle;
  String get addFirstClient;
  String get addClient;
  String get noSites;
  String get noSitesForClient;
  String get addSite;
  String get sitesAndMissions;
  String get startSessionWith;
  String siteCount(int count);

  // Site
  String get newSite;
  String get editSite;
  String get siteName;
  String get siteNameHint;
  String get siteType;
  String get siteAddress;
  String get siteAddressHint;
  String get siteNote;
  String get clientLabel;

  // Site types
  String get siteTypeIntervention;
  String get siteTypeMaintenance;
  String get siteTypeDelivery;
  String get siteTypeControl;
  String get siteTypeOther;

  // Client color palette labels
  String get colorPalette;

  // Proof detail
  String get proofContext;
  String get proofInformations;
  String get proofDeleted;
  String get addressUnavailable;
  String get coordinatesUnavailable;

  // PDF premium report
  String get pdfSubtitle;
  String get pdfProofSummary;
  String get pdfPhotographicEvidence;
  String get pdfPhotographicEvidencePlural;
  String get pdfLocationSection;
  String get pdfObservations;
  String get pdfTraceability;
  String get pdfNoObservation;
  String get pdfCapturedOn;
  String get pdfExportedOn;
  String get pdfGeoRecorded;
  String get pdfAddressResolved;
  String get pdfReference;
  String get pdfYes;
  String get pdfNo;
  String get pdfGeneratedBy;
  String get pdfFieldProofDoc;
  String get pdfAutoGenerated;
  String get pdfClient;
  String get pdfSiteMission;

  // Multi-photo flow
  String get addAnotherPhoto;
  String get finishThisProof;
  String get multiPhotoPromptTitle;
  String get multiPhotoPromptBody;
  String get photoAdded;
  String get additionalPhotos;

  /// Résumé discret du brouillon multi-photos sur l’écran de confirmation.
  String proofDraftPhotosSummary(int count);

  String get removeDraftPhotoTitle;
  String get removeDraftPhotoBody;

  /// Pastille sur la photo principale (couverture).
  String get primaryPhotoBadge;

  // Library selection & grouped export
  String get selectMode;
  String get cancelSelection;
  String selectedCount(int count);
  String get exportSelection;
  String get groupedReport;
  String get groupedPdfGenerating;
  String get groupedPdfFailed;
  String get pdfGroupedCoverTitle;
  String get pdfGroupedCoverSubtitle;
  String get pdfGroupedProofsIncluded;
  String get pdfGroupedExportDate;
  String get pdfGroupedProofSection;

  /// Synthèse / fin de document PDF (contenu utile, non décoratif)
  String get pdfDocumentSummaryTitle;
  String get pdfDataIncludedDescription;
  String get pdfDocumentScopeNote;
  String get pdfPhotosInExport;
  String get pdfGroupedClosingTitle;
  String get pdfGroupedTotalPhotographs;

  // Suppression client
  String get deleteClient;
  String get deleteClientConfirmTitle;
  String get deleteClientConfirmBody;
  String get clientDeleted;

  // Réglages — hub & sous-pages
  String get settingsHubSubtitle;
  String get settingsSectionGeneral;
  String get settingsSectionCapture;
  String get settingsSectionMetadata;
  String get settingsSectionExports;
  String get settingsSectionClientsSession;
  String get settingsSectionStorage;
  String get settingsSectionPermissions;
  String get settingsSectionPro;
  String get settingsSectionHelpLegal;
  String get settingsSectionAbout;
  String get settingsRegionalPreferences;
  String get settingsTimezoneMode;
  String get settingsTimezoneAutomatic;
  String get settingsTimezoneManual;
  String get settingsBadgeSoon;
  String get settingsPhotoQuality;
  String get settingsPhotoQualityStandard;
  String get settingsPhotoQualityHigh;
  String get settingsPhotoQualityMax;
  String get settingsImageCompression;
  String get settingsCompressionLow;
  String get settingsCompressionMedium;
  String get settingsCompressionHigh;
  String get settingsOpenCameraDirect;
  String get settingsCameraGrid;
  String get settingsCameraGridHint;
  String get settingsMultiPhotoPrompt;
  String get settingsPersistCaptureChoices;
  String get settingsIncludeClientExport;
  String get settingsIncludeSiteExport;
  String get settingsIncludeNoteExport;
  String get settingsAutoNaming;
  String get settingsAutoReference;
  String get settingsExportOpenPdfAfter;
  String get settingsExportShareAfter;
  String get settingsExportAllPhotosPdf;
  String get settingsReportStyle;
  String get settingsReportStyleStandard;
  String get settingsReportStylePremium;
  String get settingsGroupedReportAllowed;
  String get settingsExportSortOrder;
  String get settingsPdfBranding;
  String get settingsPdfCredibilityFooter;
  String get settingsPdfDetailedLocation;
  String get settingsRestoreSession;
  String get settingsConfirmSessionChange;
  String get settingsConfirmClientDelete;
  String get settingsClientDeletePolicy;
  String get settingsPolicyBlock;
  String get settingsPolicyDetach;
  String get settingsPolicyCascade;
  String get settingsPolicyPrepared;
  String get settingsStorageOverview;
  String get settingsStorageLocalData;
  String get settingsStoragePdfExports;
  String get settingsStorageCache;
  String get settingsStorageTemp;
  String get settingsClearCache;
  String get settingsDeleteTempExports;
  String get settingsOptimizeStorage;
  String get settingsStorageCalculating;
  String get settingsStorageUnavailable;
  String get settingsConfirmAction;
  String get settingsDone;
  String get settingsPermissionCamera;
  String get settingsPermissionLocation;
  String get settingsPermissionPhotos;
  String get settingsPermissionGranted;
  String get settingsPermissionDenied;
  String get settingsPermissionLimited;
  String get settingsOpenAppSettings;
  String get settingsProPageTitle;
  String get settingsProCurrentPlan;
  String get settingsProBenefits;
  String get settingsRestorePurchases;
  String get settingsFaq;
  /// Index attendu : 1 à 15. Hors plage : chaîne vide.
  String faqQuestion(int index);
  String faqAnswer(int index);
  String get settingsContactSupport;
  String get settingsReportBug;
  String get settingsContactSupportSubtitle;
  String get settingsReportBugSubtitle;
  String get supportMailBody;
  String bugReportMailBody(
    String appVersion,
    String buildNumber,
    String osLine,
  );
  String get settingsLegalPlaceholder;
  String get settingsAboutBuild;
  String get settingsOpenSource;
  String get settingsPreparedNotice;
  String get captureManualIntro;
  String get openCamera;
  String get pdfExportReady;

  String pdfExportSavedToPath(String fileName);

  String get groupedReportDisabled;

  String get sessionReplaceConfirmTitle;

  String get sessionReplaceConfirmBody;

  String get sessionReplaceConfirmAction;

  String get clientDeleteBlockedTitle;

  String clientDeleteBlockedBody(int siteCount, int proofCount, bool hasActiveSession);

  String clientDeleteImpactLines(int siteCount, int proofCount, bool hasActiveSession);
}

