import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Marges adaptatives et grilles : téléphone, tablette, grands écrans, sans framework lourd.
abstract final class AppContentLayout {
  static const double maxContentWidth = 720;
  static const double tabletBreakpoint = 600;
  static const double largeTabletBreakpoint = 900;

  /// Marge horizontale : au moins [AppSpacing.screenPadding], centrée si largeur > contenu max.
  static double horizontalMargin(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return horizontalMarginForWidth(w);
  }

  static double horizontalMarginForWidth(double width) {
    const minPad = AppSpacing.screenPadding;
    final centered = (width - maxContentWidth) / 2;
    return centered > minPad ? centered : minPad;
  }

  static int libraryGridCrossAxisCount(double contentWidth) {
    if (contentWidth >= largeTabletBreakpoint) return 4;
    if (contentWidth >= tabletBreakpoint) return 3;
    return 2;
  }

  static double libraryGridChildAspectRatio(int crossAxisCount) {
    return switch (crossAxisCount) {
      4 => 0.58,
      3 => 0.57,
      _ => 0.56,
    };
  }

  /// Bas de scroll confortable sous encoche / indicateur d’accueil iOS.
  static double scrollBottomInset(BuildContext context) {
    return AppSpacing.xxl + MediaQuery.paddingOf(context).bottom;
  }
}
