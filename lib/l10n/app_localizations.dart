import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_locale.dart';
import 'app_strings.dart';

class AppLocalizations extends AppStrings {
  const AppLocalizations._(this._strings);

  final AppStrings _strings;

  static AppLocalizations of(BuildContext context) {
    final value = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(value != null, 'AppLocalizations not found in context.');
    return value!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = AppLocale.supportedLocales;

  @override
  String get languageCode => _strings.languageCode;

  @override
  String get about => _strings.about;

  @override
  String get address => _strings.address;

  @override
  String get all => _strings.all;

  @override
  String get appTagline => _strings.appTagline;

  @override
  String get branding => _strings.branding;

  @override
  String get brandingPlaceholder => _strings.brandingPlaceholder;

  @override
  String get cameraPreview => _strings.cameraPreview;

  @override
  String get cancel => _strings.cancel;

  @override
  String get close => _strings.close;

  @override
  String get capture => _strings.capture;

  @override
  String get captureComingSoon => _strings.captureComingSoon;

  @override
  String get captureProof => _strings.captureProof;

  @override
  String get captureTitle => _strings.captureTitle;

  @override
  String get coordinates => _strings.coordinates;

  @override
  String get date => _strings.date;

  @override
  String get dateFormat => _strings.dateFormat;

  @override
  String get dateFormatEuropean => _strings.dateFormatEuropean;

  @override
  String get dateFormatUs => _strings.dateFormatUs;

  @override
  String get delete => _strings.delete;

  @override
  String get deleteProofMessage => _strings.deleteProofMessage;

  @override
  String get deleteProofTitle => _strings.deleteProofTitle;

  @override
  String get detail => _strings.detail;

  @override
  String get english => _strings.english;

  @override
  String get exportAction => _strings.exportAction;

  @override
  String get exportComingSoon => _strings.exportComingSoon;

  @override
  String get exportPdf => _strings.exportPdf;

  @override
  String get pdfGenerating => _strings.pdfGenerating;

  @override
  String get exportImageSaved => _strings.exportImageSaved;

  @override
  String get shareFailed => _strings.shareFailed;

  @override
  String get pdfFailed => _strings.pdfFailed;

  @override
  String get favorite => _strings.favorite;

  @override
  String get librarySearchHint => _strings.librarySearchHint;

  @override
  String get favoritesOnly => _strings.favoritesOnly;

  @override
  String get sortNewestFirst => _strings.sortNewestFirst;

  @override
  String get sortOldestFirst => _strings.sortOldestFirst;

  @override
  String get sortFavoritesFirst => _strings.sortFavoritesFirst;

  @override
  String get allTypes => _strings.allTypes;

  @override
  String get formats => _strings.formats;

  @override
  String get french => _strings.french;

  @override
  String get gpsCoordinates => _strings.gpsCoordinates;

  @override
  String get homeHeadline => _strings.homeHeadline;

  @override
  String get homeTitle => _strings.homeTitle;

  @override
  String get homeSupportingText => _strings.homeSupportingText;

  @override
  String get importAction => _strings.importAction;

  @override
  String get importComingSoon => _strings.importComingSoon;

  @override
  String get justNow => _strings.justNow;

  @override
  String get language => _strings.language;

  @override
  String get libraryTitle => _strings.libraryTitle;

  @override
  String get metadata => _strings.metadata;

  @override
  String get newProof => _strings.newProof;

  @override
  String get noProofFound => _strings.noProofFound;

  @override
  String get overlay => _strings.overlay;

  @override
  String get overlayDate => _strings.overlayDate;

  @override
  String get overlayPreferences => _strings.overlayPreferences;

  @override
  String get overlayTime => _strings.overlayTime;

  @override
  String get privacyPolicy => _strings.privacyPolicy;

  @override
  String get legalNotice => _strings.legalNotice;

  @override
  String get proComingSoon => _strings.proComingSoon;

  @override
  String get proDescription => _strings.proDescription;

  @override
  String get proLabel => _strings.proLabel;

  @override
  String get onboardingNext => _strings.onboardingNext;

  @override
  String get onboardingStart => _strings.onboardingStart;

  @override
  String get onboardingSlide1Title => _strings.onboardingSlide1Title;

  @override
  String get onboardingSlide1Body => _strings.onboardingSlide1Body;

  @override
  String get onboardingSlide2Title => _strings.onboardingSlide2Title;

  @override
  String get onboardingSlide2Body => _strings.onboardingSlide2Body;

  @override
  String get onboardingSlide3Title => _strings.onboardingSlide3Title;

  @override
  String get onboardingSlide3Body => _strings.onboardingSlide3Body;

  @override
  String get onboardingSlide1Kicker => _strings.onboardingSlide1Kicker;

  @override
  String get onboardingSlide2Kicker => _strings.onboardingSlide2Kicker;

  @override
  String get onboardingSlide3Kicker => _strings.onboardingSlide3Kicker;

  @override
  String get onboardingSlide1Benefit1 => _strings.onboardingSlide1Benefit1;

  @override
  String get onboardingSlide1Benefit2 => _strings.onboardingSlide1Benefit2;

  @override
  String get onboardingSlide1Benefit3 => _strings.onboardingSlide1Benefit3;

  @override
  String get onboardingSlide2Benefit1 => _strings.onboardingSlide2Benefit1;

  @override
  String get onboardingSlide2Benefit2 => _strings.onboardingSlide2Benefit2;

  @override
  String get onboardingSlide2Benefit3 => _strings.onboardingSlide2Benefit3;

  @override
  String get onboardingSlide3Benefit1 => _strings.onboardingSlide3Benefit1;

  @override
  String get onboardingSlide3Benefit2 => _strings.onboardingSlide3Benefit2;

  @override
  String get onboardingSlide3Benefit3 => _strings.onboardingSlide3Benefit3;

  @override
  String get onboardingTrustRow => _strings.onboardingTrustRow;

  @override
  String get onboardingPrivacyCompact => _strings.onboardingPrivacyCompact;

  @override
  String get onboardingMicroProofHeadline => _strings.onboardingMicroProofHeadline;

  @override
  String get onboardingMicroProofRow1Label =>
      _strings.onboardingMicroProofRow1Label;

  @override
  String get onboardingMicroProofRow1Value =>
      _strings.onboardingMicroProofRow1Value;

  @override
  String get onboardingMicroProofRow2Label =>
      _strings.onboardingMicroProofRow2Label;

  @override
  String get onboardingMicroProofRow2Value =>
      _strings.onboardingMicroProofRow2Value;

  @override
  String get onboardingMicroProofRow3Label =>
      _strings.onboardingMicroProofRow3Label;

  @override
  String get onboardingMicroProofRow3Value =>
      _strings.onboardingMicroProofRow3Value;

  @override
  String get onboardingMicroProofBadge => _strings.onboardingMicroProofBadge;

  @override
  String get onboardingMicroContextHeadline =>
      _strings.onboardingMicroContextHeadline;

  @override
  String get onboardingMicroContextRow1Label =>
      _strings.onboardingMicroContextRow1Label;

  @override
  String get onboardingMicroContextRow1Value =>
      _strings.onboardingMicroContextRow1Value;

  @override
  String get onboardingMicroContextRow2Label =>
      _strings.onboardingMicroContextRow2Label;

  @override
  String get onboardingMicroContextRow2Value =>
      _strings.onboardingMicroContextRow2Value;

  @override
  String get onboardingMicroContextRow3Label =>
      _strings.onboardingMicroContextRow3Label;

  @override
  String get onboardingMicroContextRow3Value =>
      _strings.onboardingMicroContextRow3Value;

  @override
  String get onboardingMicroContextBadge => _strings.onboardingMicroContextBadge;

  @override
  String get onboardingMicroDeliverHeadline =>
      _strings.onboardingMicroDeliverHeadline;

  @override
  String get onboardingMicroDeliverRow1Label =>
      _strings.onboardingMicroDeliverRow1Label;

  @override
  String get onboardingMicroDeliverRow1Value =>
      _strings.onboardingMicroDeliverRow1Value;

  @override
  String get onboardingMicroDeliverRow2Label =>
      _strings.onboardingMicroDeliverRow2Label;

  @override
  String get onboardingMicroDeliverRow2Value =>
      _strings.onboardingMicroDeliverRow2Value;

  @override
  String get onboardingMicroDeliverRow3Label =>
      _strings.onboardingMicroDeliverRow3Label;

  @override
  String get onboardingMicroDeliverRow3Value =>
      _strings.onboardingMicroDeliverRow3Value;

  @override
  String get onboardingMicroDeliverBadge => _strings.onboardingMicroDeliverBadge;

  @override
  String get locationRationaleTitle => _strings.locationRationaleTitle;

  @override
  String get locationRationaleBody => _strings.locationRationaleBody;

  @override
  String get locationRationaleContinue => _strings.locationRationaleContinue;

  @override
  String get permissionSheetContinue => _strings.permissionSheetContinue;

  @override
  String get cameraPrePermissionTitle => _strings.cameraPrePermissionTitle;

  @override
  String get cameraPrePermissionBody => _strings.cameraPrePermissionBody;

  @override
  String get locationPrePermissionTitle => _strings.locationPrePermissionTitle;

  @override
  String get locationPrePermissionBody => _strings.locationPrePermissionBody;

  @override
  String get locationPrePermissionBodySettings =>
      _strings.locationPrePermissionBodySettings;

  @override
  String get paywallHeadline => _strings.paywallHeadline;

  @override
  String get paywallSubtitle => _strings.paywallSubtitle;

  @override
  String get paywallPlanFree => _strings.paywallPlanFree;

  @override
  String get paywallPlanPro => _strings.paywallPlanPro;

  @override
  String get paywallRecommended => _strings.paywallRecommended;

  @override
  String get paywallFreeFeature1 => _strings.paywallFreeFeature1;

  @override
  String get paywallFreeFeature2 => _strings.paywallFreeFeature2;

  @override
  String get paywallFreeFeature3 => _strings.paywallFreeFeature3;

  @override
  String get paywallProFeature1 => _strings.paywallProFeature1;

  @override
  String get paywallProFeature2 => _strings.paywallProFeature2;

  @override
  String get paywallProFeature3 => _strings.paywallProFeature3;

  @override
  String get paywallContinueFree => _strings.paywallContinueFree;

  @override
  String get paywallBillingNote => _strings.paywallBillingNote;

  @override
  String get proofDetailTitle => _strings.proofDetailTitle;

  @override
  String get proofNotFound => _strings.proofNotFound;

  @override
  String get proofTypeDelivery => _strings.proofTypeDelivery;

  @override
  String get proofTypeIncident => _strings.proofTypeIncident;

  @override
  String get proofTypeInspection => _strings.proofTypeInspection;

  @override
  String get proofTypeInventory => _strings.proofTypeInventory;

  @override
  String get proofTypeOther => _strings.proofTypeOther;

  @override
  String get proofTypeWorkProgress => _strings.proofTypeWorkProgress;

  @override
  String get proofsWillAppearHere => _strings.proofsWillAppearHere;

  @override
  String get emptyHomeTitle => _strings.emptyHomeTitle;

  @override
  String get emptyHomeSubtitle => _strings.emptyHomeSubtitle;

  @override
  String get emptyHomeCta => _strings.emptyHomeCta;

  @override
  String get emptyLibraryTitle => _strings.emptyLibraryTitle;

  @override
  String get emptyLibrarySubtitle => _strings.emptyLibrarySubtitle;

  @override
  String get recentProofs => _strings.recentProofs;

  @override
  String get save => _strings.save;

  @override
  String get settingsTitle => _strings.settingsTitle;

  @override
  String get share => _strings.share;

  @override
  String get shareComingSoon => _strings.shareComingSoon;

  @override
  String get showAddress => _strings.showAddress;

  @override
  String get showCoordinates => _strings.showCoordinates;

  @override
  String get showDate => _strings.showDate;

  @override
  String get showTime => _strings.showTime;

  @override
  String get source => _strings.source;

  @override
  String get sourceLocal => _strings.sourceLocal;

  @override
  String get termsOfService => _strings.termsOfService;

  @override
  String get time => _strings.time;

  @override
  String get timeFormat => _strings.timeFormat;

  @override
  String get timeFormat12h => _strings.timeFormat12h;

  @override
  String get timeFormat24h => _strings.timeFormat24h;

  @override
  String get viewAll => _strings.viewAll;

  @override
  String daysAgo(int count) => _strings.daysAgo(count);

  @override
  String hoursAgo(int count) => _strings.hoursAgo(count);

  @override
  String minutesAgo(int count) => _strings.minutesAgo(count);

  @override
  String proofCount(int count) => _strings.proofCount(count);

  @override
  String versionLabel(String version) => _strings.versionLabel(version);

  @override
  String get myProofsTitle => _strings.myProofsTitle;

  @override
  String get clientsTitle => _strings.clientsTitle;

  @override
  String get activeSession => _strings.activeSession;

  @override
  String get noActiveSession => _strings.noActiveSession;

  @override
  String get startSession => _strings.startSession;

  @override
  String get changeContext => _strings.changeContext;

  @override
  String get endSession => _strings.endSession;

  @override
  String get nextProofsWillUse => _strings.nextProofsWillUse;

  @override
  String get chooseContext => _strings.chooseContext;

  @override
  String get sessionEmptyHint => _strings.sessionEmptyHint;

  @override
  String get sessionWith => _strings.sessionWith;

  @override
  String get context => _strings.context;

  @override
  String get skip => _strings.skip;

  @override
  String get validate => _strings.validate;

  @override
  String get chooseClient => _strings.chooseClient;

  @override
  String get chooseSite => _strings.chooseSite;

  @override
  String get siteForClient => _strings.siteForClient;

  @override
  String get modifyContext => _strings.modifyContext;

  @override
  String get unclassified => _strings.unclassified;

  @override
  String get noContext => _strings.noContext;

  @override
  String get addContext => _strings.addContext;

  @override
  String get contextUpdated => _strings.contextUpdated;

  @override
  String get proofSaved => _strings.proofSaved;

  @override
  String get proofSaveFailed => _strings.proofSaveFailed;

  @override
  String autoStyledProofTitle(
          String typeLabel, String dateLine, String timeLine) =>
      _strings.autoStyledProofTitle(typeLabel, dateLine, timeLine);

  @override
  String proofReferenceLine(String referenceId) =>
      _strings.proofReferenceLine(referenceId);

  @override
  String get shareProofCoverPhoto => _strings.shareProofCoverPhoto;

  @override
  String get exportProofCoverPhoto => _strings.exportProofCoverPhoto;

  @override
  String get supportEmailCopied => _strings.supportEmailCopied;

  @override
  String get settingsStorageActionFailed => _strings.settingsStorageActionFailed;

  @override
  String get saveAndNewProof => _strings.saveAndNewProof;

  @override
  String get confirmProof => _strings.confirmProof;

  @override
  String defaultProofTitle(String formattedDate) =>
      _strings.defaultProofTitle(formattedDate);

  @override
  String get proofType => _strings.proofType;

  @override
  String get note => _strings.note;

  @override
  String get noteOptional => _strings.noteOptional;

  @override
  String get noNote => _strings.noNote;

  @override
  String get addNote => _strings.addNote;

  @override
  String get classifiedAs => _strings.classifiedAs;

  @override
  String get newClient => _strings.newClient;

  @override
  String get editClient => _strings.editClient;

  @override
  String get clientName => _strings.clientName;

  @override
  String get clientNotFound => _strings.clientNotFound;

  @override
  String get clientNameHint => _strings.clientNameHint;

  @override
  String get company => _strings.company;

  @override
  String get companyHint => _strings.companyHint;

  @override
  String get color => _strings.color;

  @override
  String get clientNote => _strings.clientNote;

  @override
  String get noClients => _strings.noClients;

  @override
  String get emptyClientsSubtitle => _strings.emptyClientsSubtitle;

  @override
  String get addFirstClient => _strings.addFirstClient;

  @override
  String get addClient => _strings.addClient;

  @override
  String get noSites => _strings.noSites;

  @override
  String get noSitesForClient => _strings.noSitesForClient;

  @override
  String get addSite => _strings.addSite;

  @override
  String get sitesAndMissions => _strings.sitesAndMissions;

  @override
  String get startSessionWith => _strings.startSessionWith;

  @override
  String siteCount(int count) => _strings.siteCount(count);

  @override
  String get newSite => _strings.newSite;

  @override
  String get editSite => _strings.editSite;

  @override
  String get siteName => _strings.siteName;

  @override
  String get siteNameHint => _strings.siteNameHint;

  @override
  String get siteType => _strings.siteType;

  @override
  String get siteAddress => _strings.siteAddress;

  @override
  String get siteAddressHint => _strings.siteAddressHint;

  @override
  String get siteNote => _strings.siteNote;

  @override
  String get clientLabel => _strings.clientLabel;

  @override
  String get siteTypeIntervention => _strings.siteTypeIntervention;

  @override
  String get siteTypeMaintenance => _strings.siteTypeMaintenance;

  @override
  String get siteTypeDelivery => _strings.siteTypeDelivery;

  @override
  String get siteTypeControl => _strings.siteTypeControl;

  @override
  String get siteTypeOther => _strings.siteTypeOther;

  @override
  String get colorPalette => _strings.colorPalette;

  @override
  String get proofContext => _strings.proofContext;

  @override
  String get proofInformations => _strings.proofInformations;

  @override
  String get proofDeleted => _strings.proofDeleted;

  @override
  String get addressUnavailable => _strings.addressUnavailable;

  @override
  String get coordinatesUnavailable => _strings.coordinatesUnavailable;

  // PDF premium report
  @override
  String get pdfSubtitle => _strings.pdfSubtitle;

  @override
  String get pdfProofSummary => _strings.pdfProofSummary;

  @override
  String get pdfPhotographicEvidence => _strings.pdfPhotographicEvidence;

  @override
  String get pdfPhotographicEvidencePlural =>
      _strings.pdfPhotographicEvidencePlural;

  @override
  String get pdfLocationSection => _strings.pdfLocationSection;

  @override
  String get pdfObservations => _strings.pdfObservations;

  @override
  String get pdfTraceability => _strings.pdfTraceability;

  @override
  String get pdfNoObservation => _strings.pdfNoObservation;

  @override
  String get pdfCapturedOn => _strings.pdfCapturedOn;

  @override
  String get pdfExportedOn => _strings.pdfExportedOn;

  @override
  String get pdfGeoRecorded => _strings.pdfGeoRecorded;

  @override
  String get pdfAddressResolved => _strings.pdfAddressResolved;

  @override
  String get pdfReference => _strings.pdfReference;

  @override
  String get pdfYes => _strings.pdfYes;

  @override
  String get pdfNo => _strings.pdfNo;

  @override
  String get pdfGeneratedBy => _strings.pdfGeneratedBy;

  @override
  String get pdfFieldProofDoc => _strings.pdfFieldProofDoc;

  @override
  String get pdfAutoGenerated => _strings.pdfAutoGenerated;

  @override
  String get pdfClient => _strings.pdfClient;

  @override
  String get pdfSiteMission => _strings.pdfSiteMission;

  // Multi-photo flow
  @override
  String get addAnotherPhoto => _strings.addAnotherPhoto;

  @override
  String get finishThisProof => _strings.finishThisProof;

  @override
  String get multiPhotoPromptTitle => _strings.multiPhotoPromptTitle;

  @override
  String get multiPhotoPromptBody => _strings.multiPhotoPromptBody;

  @override
  String get photoAdded => _strings.photoAdded;

  @override
  String get additionalPhotos => _strings.additionalPhotos;

  @override
  String proofDraftPhotosSummary(int count) =>
      _strings.proofDraftPhotosSummary(count);

  @override
  String get removeDraftPhotoTitle => _strings.removeDraftPhotoTitle;

  @override
  String get removeDraftPhotoBody => _strings.removeDraftPhotoBody;

  @override
  String get primaryPhotoBadge => _strings.primaryPhotoBadge;

  // Library selection & grouped export
  @override
  String get selectMode => _strings.selectMode;

  @override
  String get cancelSelection => _strings.cancelSelection;

  @override
  String selectedCount(int count) => _strings.selectedCount(count);

  @override
  String get exportSelection => _strings.exportSelection;

  @override
  String get groupedReport => _strings.groupedReport;

  @override
  String get groupedPdfGenerating => _strings.groupedPdfGenerating;

  @override
  String get groupedPdfFailed => _strings.groupedPdfFailed;

  @override
  String get pdfGroupedCoverTitle => _strings.pdfGroupedCoverTitle;

  @override
  String get pdfGroupedCoverSubtitle => _strings.pdfGroupedCoverSubtitle;

  @override
  String get pdfGroupedProofsIncluded => _strings.pdfGroupedProofsIncluded;

  @override
  String get pdfGroupedExportDate => _strings.pdfGroupedExportDate;

  @override
  String get pdfGroupedProofSection => _strings.pdfGroupedProofSection;

  @override
  String get pdfDocumentSummaryTitle => _strings.pdfDocumentSummaryTitle;

  @override
  String get pdfDataIncludedDescription => _strings.pdfDataIncludedDescription;

  @override
  String get pdfDocumentScopeNote => _strings.pdfDocumentScopeNote;

  @override
  String get pdfPhotosInExport => _strings.pdfPhotosInExport;

  @override
  String get pdfGroupedClosingTitle => _strings.pdfGroupedClosingTitle;

  @override
  String get pdfGroupedTotalPhotographs => _strings.pdfGroupedTotalPhotographs;

  @override
  String get deleteClient => _strings.deleteClient;

  @override
  String get deleteClientConfirmTitle => _strings.deleteClientConfirmTitle;

  @override
  String get deleteClientConfirmBody => _strings.deleteClientConfirmBody;

  @override
  String get clientDeleted => _strings.clientDeleted;

  @override
  String get settingsHubSubtitle => _strings.settingsHubSubtitle;

  @override
  String get settingsSectionGeneral => _strings.settingsSectionGeneral;

  @override
  String get settingsSectionCapture => _strings.settingsSectionCapture;

  @override
  String get settingsSectionMetadata => _strings.settingsSectionMetadata;

  @override
  String get settingsSectionExports => _strings.settingsSectionExports;

  @override
  String get settingsSectionClientsSession =>
      _strings.settingsSectionClientsSession;

  @override
  String get settingsSectionStorage => _strings.settingsSectionStorage;

  @override
  String get settingsSectionPermissions =>
      _strings.settingsSectionPermissions;

  @override
  String get settingsSectionPro => _strings.settingsSectionPro;

  @override
  String get settingsSectionHelpLegal => _strings.settingsSectionHelpLegal;

  @override
  String get settingsSectionAbout => _strings.settingsSectionAbout;

  @override
  String get settingsRegionalPreferences =>
      _strings.settingsRegionalPreferences;

  @override
  String get settingsTimezoneMode => _strings.settingsTimezoneMode;

  @override
  String get settingsTimezoneAutomatic => _strings.settingsTimezoneAutomatic;

  @override
  String get settingsTimezoneManual => _strings.settingsTimezoneManual;

  @override
  String get settingsBadgeSoon => _strings.settingsBadgeSoon;

  @override
  String get settingsPhotoQuality => _strings.settingsPhotoQuality;

  @override
  String get settingsPhotoQualityStandard =>
      _strings.settingsPhotoQualityStandard;

  @override
  String get settingsPhotoQualityHigh => _strings.settingsPhotoQualityHigh;

  @override
  String get settingsPhotoQualityMax => _strings.settingsPhotoQualityMax;

  @override
  String get settingsImageCompression => _strings.settingsImageCompression;

  @override
  String get settingsCompressionLow => _strings.settingsCompressionLow;

  @override
  String get settingsCompressionMedium => _strings.settingsCompressionMedium;

  @override
  String get settingsCompressionHigh => _strings.settingsCompressionHigh;

  @override
  String get settingsOpenCameraDirect => _strings.settingsOpenCameraDirect;

  @override
  String get settingsCameraGrid => _strings.settingsCameraGrid;

  @override
  String get settingsCameraGridHint => _strings.settingsCameraGridHint;

  @override
  String get settingsMultiPhotoPrompt => _strings.settingsMultiPhotoPrompt;

  @override
  String get settingsPersistCaptureChoices =>
      _strings.settingsPersistCaptureChoices;

  @override
  String get settingsIncludeClientExport =>
      _strings.settingsIncludeClientExport;

  @override
  String get settingsIncludeSiteExport => _strings.settingsIncludeSiteExport;

  @override
  String get settingsIncludeNoteExport => _strings.settingsIncludeNoteExport;

  @override
  String get settingsAutoNaming => _strings.settingsAutoNaming;

  @override
  String get settingsAutoReference => _strings.settingsAutoReference;

  @override
  String get settingsExportOpenPdfAfter => _strings.settingsExportOpenPdfAfter;

  @override
  String get settingsExportShareAfter => _strings.settingsExportShareAfter;

  @override
  String get settingsExportAllPhotosPdf => _strings.settingsExportAllPhotosPdf;

  @override
  String get settingsReportStyle => _strings.settingsReportStyle;

  @override
  String get settingsReportStyleStandard =>
      _strings.settingsReportStyleStandard;

  @override
  String get settingsReportStylePremium =>
      _strings.settingsReportStylePremium;

  @override
  String get settingsGroupedReportAllowed =>
      _strings.settingsGroupedReportAllowed;

  @override
  String get settingsExportSortOrder => _strings.settingsExportSortOrder;

  @override
  String get settingsPdfBranding => _strings.settingsPdfBranding;

  @override
  String get settingsPdfCredibilityFooter =>
      _strings.settingsPdfCredibilityFooter;

  @override
  String get settingsPdfDetailedLocation =>
      _strings.settingsPdfDetailedLocation;

  @override
  String get settingsRestoreSession => _strings.settingsRestoreSession;

  @override
  String get settingsConfirmSessionChange =>
      _strings.settingsConfirmSessionChange;

  @override
  String get settingsConfirmClientDelete =>
      _strings.settingsConfirmClientDelete;

  @override
  String get settingsClientDeletePolicy => _strings.settingsClientDeletePolicy;

  @override
  String get settingsPolicyBlock => _strings.settingsPolicyBlock;

  @override
  String get settingsPolicyDetach => _strings.settingsPolicyDetach;

  @override
  String get settingsPolicyCascade => _strings.settingsPolicyCascade;

  @override
  String get settingsPolicyPrepared => _strings.settingsPolicyPrepared;

  @override
  String get settingsStorageOverview => _strings.settingsStorageOverview;

  @override
  String get settingsStorageLocalData => _strings.settingsStorageLocalData;

  @override
  String get settingsStoragePdfExports => _strings.settingsStoragePdfExports;

  @override
  String get settingsStorageCache => _strings.settingsStorageCache;

  @override
  String get settingsStorageTemp => _strings.settingsStorageTemp;

  @override
  String get settingsClearCache => _strings.settingsClearCache;

  @override
  String get settingsDeleteTempExports =>
      _strings.settingsDeleteTempExports;

  @override
  String get settingsOptimizeStorage => _strings.settingsOptimizeStorage;

  @override
  String get settingsStorageCalculating => _strings.settingsStorageCalculating;

  @override
  String get settingsStorageUnavailable =>
      _strings.settingsStorageUnavailable;

  @override
  String get settingsConfirmAction => _strings.settingsConfirmAction;

  @override
  String get settingsDone => _strings.settingsDone;

  @override
  String get settingsPermissionCamera => _strings.settingsPermissionCamera;

  @override
  String get settingsPermissionLocation =>
      _strings.settingsPermissionLocation;

  @override
  String get settingsPermissionPhotos => _strings.settingsPermissionPhotos;

  @override
  String get settingsPermissionGranted => _strings.settingsPermissionGranted;

  @override
  String get settingsPermissionDenied => _strings.settingsPermissionDenied;

  @override
  String get settingsPermissionLimited => _strings.settingsPermissionLimited;

  @override
  String get settingsOpenAppSettings => _strings.settingsOpenAppSettings;

  @override
  String get settingsProPageTitle => _strings.settingsProPageTitle;

  @override
  String get settingsProCurrentPlan => _strings.settingsProCurrentPlan;

  @override
  String get settingsProBenefits => _strings.settingsProBenefits;

  @override
  String get settingsRestorePurchases => _strings.settingsRestorePurchases;

  @override
  String get settingsFaq => _strings.settingsFaq;

  @override
  String faqQuestion(int index) => _strings.faqQuestion(index);

  @override
  String faqAnswer(int index) => _strings.faqAnswer(index);

  @override
  String get settingsContactSupport => _strings.settingsContactSupport;

  @override
  String get settingsReportBug => _strings.settingsReportBug;

  @override
  String get settingsContactSupportSubtitle =>
      _strings.settingsContactSupportSubtitle;

  @override
  String get settingsReportBugSubtitle => _strings.settingsReportBugSubtitle;

  @override
  String get supportMailBody => _strings.supportMailBody;

  @override
  String bugReportMailBody(
    String appVersion,
    String buildNumber,
    String osLine,
  ) =>
      _strings.bugReportMailBody(appVersion, buildNumber, osLine);

  @override
  String get settingsLegalPlaceholder => _strings.settingsLegalPlaceholder;

  @override
  String get settingsAboutBuild => _strings.settingsAboutBuild;

  @override
  String get settingsOpenSource => _strings.settingsOpenSource;

  @override
  String get settingsPreparedNotice => _strings.settingsPreparedNotice;

  @override
  String get captureManualIntro => _strings.captureManualIntro;

  @override
  String get openCamera => _strings.openCamera;

  @override
  String get pdfExportReady => _strings.pdfExportReady;

  @override
  String pdfExportSavedToPath(String fileName) =>
      _strings.pdfExportSavedToPath(fileName);

  @override
  String get groupedReportDisabled => _strings.groupedReportDisabled;

  @override
  String get sessionReplaceConfirmTitle =>
      _strings.sessionReplaceConfirmTitle;

  @override
  String get sessionReplaceConfirmBody =>
      _strings.sessionReplaceConfirmBody;

  @override
  String get sessionReplaceConfirmAction =>
      _strings.sessionReplaceConfirmAction;

  @override
  String get clientDeleteBlockedTitle => _strings.clientDeleteBlockedTitle;

  @override
  String clientDeleteBlockedBody(
    int siteCount,
    int proofCount,
    bool hasActiveSession,
  ) =>
      _strings.clientDeleteBlockedBody(
        siteCount,
        proofCount,
        hasActiveSession,
      );

  @override
  String clientDeleteImpactLines(
    int siteCount,
    int proofCount,
    bool hasActiveSession,
  ) =>
      _strings.clientDeleteImpactLines(
        siteCount,
        proofCount,
        hasActiveSession,
      );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      AppLocalizations._(AppLocale.stringsFor(locale)),
    );
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
