import 'package:flutter/material.dart';

abstract final class AppColors {
  // --- Couleurs de marque ---
  static const Color primary = Color(0xFF0D1B2A); // Bleu nuit signature
  static const Color primaryLight = Color(0xFF334155); // Slate 700
  static const Color primaryDark = Color(0xFF020617); // Slate 950
  
  static const Color accent = Color(0xFF2563EB); // Blue 600
  static const Color accentLight = Color(0xFF3B82F6); // Blue 500

  static const Color secondary = Color(0xFFF59E0B); // Amber 500
  static const Color secondaryLight = Color(0xFFFBBF24); // Amber 400

  // --- Surfaces et fonds ---
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color surfaceDark = Color(0xFF0F172A); // Slate 900 (Pour capture/écrans sombres)

  // --- Typographie ---
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF8FAFC); // Slate 50

  // --- Éléments de structure ---
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color divider = Color(0xFFF1F5F9); // Slate 100

  // --- États ---
  static const Color disabled = Color(0xFFCBD5E1); // Slate 300
  static const Color disabledText = Color(0xFF94A3B8); // Slate 400
  
  // --- Sémantique ---
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color info = Color(0xFF2563EB); // Blue 600

  // --- Palette premium par catégorie de preuve ---
  static const Color categoryInspection = Color(0xFF334155); // Slate 700
  static const Color categoryDelivery    = Color(0xFFD97706); // Amber 600
  static const Color categoryProgress    = Color(0xFF166534); // Green 800
  static const Color categoryIncident    = Color(0xFFDC2626); // Red 600
  static const Color categoryInventory   = Color(0xFF5B21B6); // Violet 800
  static const Color categoryOther       = Color(0xFF94A3B8); // Slate 400

  // --- Overlays (Transparences standardisées) ---
  static final Color overlayLight = Colors.white.withValues(alpha: 0.1);
  static final Color overlayMedium = Colors.white.withValues(alpha: 0.2);
  static final Color overlayDark = Colors.black.withValues(alpha: 0.3);
  static final Color overlayDarker = Colors.black.withValues(alpha: 0.5);
}
