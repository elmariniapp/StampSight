import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

abstract final class DateFormatters {
  static String formatDate(
    DateTime date, [
    String pattern = 'dd/MM/yyyy',
    String locale = 'fr',
  ]) {
    return DateFormat(pattern, locale).format(date);
  }

  static String formatTime(
    DateTime date, [
    String pattern = 'HH:mm',
    String locale = 'fr',
  ]) {
    return DateFormat(pattern, locale).format(date);
  }

  static String formatDateTime(DateTime date, [String locale = 'fr']) {
    return DateFormat('dd/MM/yyyy HH:mm', locale).format(date);
  }

  static String formatRelative(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
    return DateFormat('dd MMM yyyy', l10n.languageCode).format(date);
  }

  static String overlayDate(DateTime date, [String locale = 'fr']) {
    return DateFormat('dd MMM yyyy', locale).format(date).toUpperCase();
  }

  static String overlayTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }
}
