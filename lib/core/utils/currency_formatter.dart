import 'package:intl/intl.dart';

/// Handles decimal-safe currency calculations and formatting using integer minor units (e.g. cents/halalas).
class CurrencyFormatter {
  /// Converts a major decimal value (e.g., 1500.50) to minor integer units (150050).
  static int toMinorUnits(double majorUnits) {
    return (majorUnits * 100).round();
  }

  /// Converts minor integer units (150050) to major double for display (1500.50).
  static double toMajorUnits(int minorUnits) {
    return minorUnits / 100.0;
  }

  /// Formats minor integer units into a localized currency string.
  static String format(int minorUnits, {String symbol = 'ر.س'}) {
    final format = NumberFormat.currency(
      locale: 'ar_SA',
      symbol: symbol,
      decimalDigits: 2,
    );
    return format.format(toMajorUnits(minorUnits));
  }

  /// Compact format for dashboard badges
  static String formatCompact(int minorUnits, {String symbol = 'ر.س'}) {
    final format = NumberFormat.compactCurrency(
      locale: 'ar_SA',
      symbol: symbol,
      decimalDigits: 1,
    );
    return format.format(toMajorUnits(minorUnits));
  }

  /// Parses a user-input string into minor integer units safely.
  static int parseToMinorUnits(String input) {
    final clean = input.replaceAll(RegExp(r'[^\d.-]'), '');
    final val = double.tryParse(clean) ?? 0.0;
    return toMinorUnits(val);
  }
}
