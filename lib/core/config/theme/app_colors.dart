import 'package:flutter/material.dart';

/// App-wide color constants following the "Spiritual Sanctuary" dark theme
/// Primary: Deep Space Navy (#0A0E21)
/// Secondary: Cyan/Blue accents for spiritual elements
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Dark Theme Base
  static const Color primaryBackground = Color(0xFF0A0E21); // Deep Space Navy
  static const Color secondaryBackground = Color(0xFF1D1E33); // Card background
  static const Color tertiaryBackground = Color(0xFF111328); // Darker variant

  // Accent Colors - Spiritual Blue/Cyan
  static const Color primaryAccent = Color(0xFF4FC3F7); // Bright Cyan
  static const Color secondaryAccent = Color(0xFF29B6F6); // Sky Blue
  static const Color tertiaryAccent = Color(0xFF0288D1); // Deep Blue
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF1E3A8A); // Deep Blue
  static const Color gradientEnd = Color(0xFF3B82F6); // Bright Blue
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green for completed prayers
  static const Color warning = Color(0xFFFFA726); // Orange for pending
  static const Color error = Color(0xFFEF5350); // Red for missed prayers
  static const Color info = Color(0xFF42A5F5); // Blue for information
  
  // Prayer Status Colors
  static const Color prayedInMasjid = Color(0xFF66BB6A); // Green - Congregation
  static const Color prayedAlone = Color(0xFF42A5F5); // Blue - Alone
  static const Color prayedQaza = Color(0xFFFFA726); // Orange - Qaza
  static const Color prayedMissed = Color(0xFFEF5350); // Red - Missed
  static const Color prayedPending = Color(0xFF78909C); // Grey - Not yet time
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB0BEC5); // Light Grey
  static const Color textTertiary = Color(0xFF78909C); // Medium Grey
  static const Color textDisabled = Color(0xFF546E7A); // Dark Grey
  
  // UI Element Colors
  static const Color cardBackground = Color(0xFF1D1E33); // Card background
  static const Color cardBorder = Color(0xFF2C2D48); // Subtle border
  static const Color divider = Color(0xFF2C2D48); // Divider line
  static const Color shadow = Color(0x40000000); // Shadow with 25% opacity
  
  // Bottom Navigation Colors
  static const Color bottomNavBackground = Color(0xFF111328);
  static const Color bottomNavSelected = Color(0xFF4FC3F7);
  static const Color bottomNavUnselected = Color(0xFF78909C);
  
  // Progress Indicator Colors
  static const Color progressBackground = Color(0xFF2C2D48);
  static const Color progressForeground = Color(0xFF4FC3F7);
  
  // Shimmer Effect Colors
  static const Color shimmerBase = Color(0xFF1D1E33);
  static const Color shimmerHighlight = Color(0xFF2C2D48);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x1AFFFFFF); // 10% white
  static const Color overlayMedium = Color(0x33FFFFFF); // 20% white
  static const Color overlayDark = Color(0x80000000); // 50% black
  
  // Special Colors
  static const Color quranTextArabic = Color(0xFFE8F5E9); // Light green tint
  static const Color hadithHighlight = Color(0xFFFFF9C4); // Light yellow
  
  /// Linear gradient for cards and containers
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1D1E33),
      Color(0xFF111328),
    ],
  );
  
  /// Linear gradient for progress indicators
  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4FC3F7),
      Color(0xFF0288D1),
    ],
  );
  
  /// Linear gradient for buttons
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF29B6F6),
      Color(0xFF0288D1),
    ],
  );
  
  /// Radial gradient for circular progress
  static const RadialGradient circularProgressGradient = RadialGradient(
    colors: [
      Color(0xFF4FC3F7),
      Color(0xFF0288D1),
    ],
  );
  
  /// Get prayer status color based on status
  static Color getPrayerStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'masjid':
      case 'congregation':
      case 'completed': // Backward compatibility for old database entries
        return prayedInMasjid;
      case 'alone':
        return prayedAlone;
      case 'qaza':
        return prayedQaza;
      case 'missed':
        return prayedMissed;
      case 'pending':
      default:
        return prayedPending;
    }
  }
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}