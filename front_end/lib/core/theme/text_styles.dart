import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headers (Poppins)
  static TextStyle header1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle header2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle header3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Body Text (Inter)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.lightGray,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.lightGray,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumGray,
  );

  // Vitals Display
  static TextStyle vitalValue = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.0,
  );

  static TextStyle vitalValueMedium = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle vitalLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGray,
    letterSpacing: 1.2,
  );

  // Labels (uppercase, small)
  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mediumGray,
    letterSpacing: 1.2,
  );

  static TextStyle labelWhite = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 1.2,
  );

  // Buttons
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  // Caption
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumGray,
  );

  // Numbers (large display)
  static TextStyle displayNumber = GoogleFonts.poppins(
    fontSize: 64,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.0,
  );
}
