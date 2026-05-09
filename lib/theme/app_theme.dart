import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF050915);
  static const Color accent = Color(0xFFF7C948);
  static const Color text = Colors.white;
  static const Color muted = Color(0xFF9B9EB0);
  static const Color card = Color.fromARGB(200, 10, 15, 30);

  // الخطوط المعتمدة للهوية الجديدة
  static String get mainArabicFont => GoogleFonts.cairo().fontFamily!;
  static String get englishBodyFont => GoogleFonts.raleway().fontFamily!;
  static String get englishDetailFont => GoogleFonts.montserrat().fontFamily!;
  static String get luxurySerifFont => GoogleFonts.playfairDisplay().fontFamily!;
  static String get scriptFont => GoogleFonts.greatVibes().fontFamily!;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    fontFamily: mainArabicFont,
    cardColor: card,
    primaryColor: accent,
    textTheme: GoogleFonts.cairoTextTheme(const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      bodyMedium: TextStyle(color: text, fontSize: 16),
      bodySmall: TextStyle(color: muted, fontSize: 14),
    )).copyWith(
      titleLarge: GoogleFonts.playfairDisplay(color: text, fontWeight: FontWeight.bold, fontSize: 22),
      titleMedium: GoogleFonts.raleway(color: text, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.montserrat(color: muted, fontSize: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: text),
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: text,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );



  static LinearGradient goldGradient = const LinearGradient(
    colors: [Color(0xFFFFF7D5), Color(0xFFF7C948), Color(0xFFC78822)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
