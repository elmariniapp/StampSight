import 'package:flutter/material.dart';

abstract final class AppShadows {
  /// Ombre très légère, pour les petits éléments (pills, badges)
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Ombre standard, pour les cartes et éléments de liste
  static final List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ];

  /// Ombre prononcée, pour les éléments flottants (bottom nav, boutons d'action)
  static final List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  /// Ombre très prononcée, pour les modales et sheets
  static final List<BoxShadow> xl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];
}
