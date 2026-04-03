import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppBorders {
  /// Bordure standard pour les cartes et conteneurs
  static const BorderSide standard = BorderSide(
    color: AppColors.border,
    width: 1.0,
  );

  /// Bordure accentuée pour les états sélectionnés ou focus
  static const BorderSide active = BorderSide(
    color: AppColors.primary,
    width: 1.0,
  );

  /// Bordure transparente
  static const BorderSide none = BorderSide(
    color: Colors.transparent,
    width: 0.0,
  );
}
