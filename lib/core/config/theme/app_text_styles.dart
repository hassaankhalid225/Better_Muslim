import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App-wide text styles using Google Fonts (Poppins for modern, clean look)
/// Follows Material Design typography guidelines with custom spiritual theme
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // ============================================
  // HEADINGS
  // ============================================

  /// H1 - Main app title (e.g., "BetterMuslim")
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  /// H2 - Page titles (e.g., "Prayer History")
  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  /// H3 - Section titles (e.g., "Daily Progress")
  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  /// H4 - Card titles (e.g., "Fajr", "Dhuhr")
  static TextStyle h4 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// H5 - Subsection titles
  static TextStyle h5 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// H6 - Small headings
  static TextStyle h6 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY TEXT
  // ============================================

  /// Body Large - Main content text
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body Medium - Secondary content
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Body Small - Tertiary content
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // ============================================
  // LABELS & CAPTIONS
  // ============================================

  /// Label Large - Button text, important labels
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  /// Label Medium - Form labels, tags
  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  /// Label Small - Small tags, badges
  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );

  /// Caption - Timestamps, metadata
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  // ============================================
  // SPECIAL STYLES
  // ============================================

  /// Prayer time text (e.g., "5:12 AM")
  static TextStyle prayerTime = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Prayer name (e.g., "Fajr")
  static TextStyle prayerName = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Progress percentage (e.g., "20%")
  static TextStyle progressPercentage = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryAccent,
    letterSpacing: -1,
  );

  /// Progress label (e.g., "Daily Progress")
  static TextStyle progressLabel = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Date text (e.g., "Monday, 15 May 2023")
  static TextStyle dateText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Hijri date text (e.g., "25 Shawwal 1444")
  static TextStyle hijriDate = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  /// Bottom navigation label
  static TextStyle bottomNavLabel = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Bottom navigation label (selected)
  static TextStyle bottomNavLabelSelected = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryAccent,
  );

  // ============================================
  // ARABIC TEXT STYLES
  // ============================================

  /// Arabic Quran text - Large
  static TextStyle quranArabicLarge = GoogleFonts.amiri(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.quranTextArabic,
    height: 2.0,
  );

  /// Arabic Quran text - Medium
  static TextStyle quranArabicMedium = GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.quranTextArabic,
    height: 1.8,
  );

  /// Arabic Hadith text
  static TextStyle hadithArabic = GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.8,
  );

  /// Arabic Ayah text (small)
  static TextStyle ayahArabicSmall = GoogleFonts.amiri(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  /// General Quran text for display
  static TextStyle quranText = quranArabicMedium;


  // ============================================
  // TRANSLATION STYLES
  // ============================================

  /// Quran translation text
  static TextStyle quranTranslation = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  /// Hadith translation text
  static TextStyle hadithTranslation = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ============================================
  // BUTTON STYLES
  // ============================================

  /// Primary button text
  static TextStyle buttonPrimary = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  /// Secondary button text
  static TextStyle buttonSecondary = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryAccent,
    letterSpacing: 0.5,
  );

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply font weight to any text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply font size to any text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Apply opacity to text style color
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withValues(alpha: opacity));
  }
}
