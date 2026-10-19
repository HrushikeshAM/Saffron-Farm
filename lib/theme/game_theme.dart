import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTheme {
  // Wood & Indoor Farm Amber Palette
  static const Color woodDark = Color(0xFF23160D);
  static const Color woodMedium = Color(0xFF3E2718);
  static const Color woodWarm = Color(0xFF5D3A24);
  static const Color woodLight = Color(0xFF8B5A36);
  static const Color amberGlow = Color(0xFFF59E0B);
  static const Color orangeGlow = Color(0xFFEA580C);

  // Purple Saffron Palette
  static const Color saffronPurple = Color(0xFF7C3AED);
  static const Color saffronPurpleLight = Color(0xFFA855F7);
  static const Color saffronPurpleDeep = Color(0xFF581C87);
  static const Color saffronRedStigma = Color(0xFFEF4444);

  // Action Colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color forestGreen = Color(0xFF059669);
  static const Color waterBlue = Color(0xFF0284C7);
  static const Color waterBlueLight = Color(0xFF38BDF8);
  static const Color gold = Color(0xFFFBBF24);
  static const Color goldDark = Color(0xFFD97706);

  // Card & Panel Dark Slate Backgrounds
  static const Color panelBg = Color(0xFF181512);
  static const Color panelBorder = Color(0xFF4A3828);
  static const Color cardDark = Color(0xEE1F1A15);
  static const Color modalOverlay = Color(0xCC000000);

  static TextStyle get titleStyle => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFFF7ED),
        shadows: [
          const Shadow(
            color: Colors.black87,
            offset: Offset(1, 1),
            blurRadius: 3,
          ),
        ],
      );

  static TextStyle get headingStyle => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFFEF3C7),
      );

  static TextStyle get bodyStyle => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFE2E8F0),
      );

  static TextStyle get badgeStyle => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static BoxDecoration get panelDecoration => BoxDecoration(
        color: const Color(0xF0201914),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF785338), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x88000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get goldBorderDecoration => BoxDecoration(
        color: const Color(0xF0291F18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gold, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66F59E0B),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  /// Format compact coins as 1k, 1L, 1Cr etc up to 2 decimal points
  static String formatCompactCoins(num amount) {
    if (amount < 1000) {
      return '$amount';
    } else if (amount < 100000) {
      final val = amount / 1000;
      final str = val.toStringAsFixed(2);
      return '${_cleanTrailingZeros(str)}k';
    } else if (amount < 10000000) {
      final val = amount / 100000;
      final str = val.toStringAsFixed(2);
      return '${_cleanTrailingZeros(str)}L';
    } else {
      final val = amount / 10000000;
      final str = val.toStringAsFixed(2);
      return '${_cleanTrailingZeros(str)}Cr';
    }
  }

  /// Format exact coins with commas
  static String formatExactCoins(num amount) {
    final str = amount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  static String _cleanTrailingZeros(String str) {
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
    }
    return str;
  }
}
