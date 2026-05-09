import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class PriceFormatter {
  static String format(double price) {
    // تنسيق بسيط مع فواصل آلاف (يدوي لتجنب الاعتماد على مكتبات خارجية إذا لم تكن موجودة)
    String priceStr = price.toStringAsFixed(0);
    if (priceStr.length > 3) {
      priceStr = priceStr.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
    return priceStr;
  }

  static Widget priceWidget(double price, {double fontSize = 18, Color? color}) {
    return Text(
      "${format(price)} SAR",
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? const Color(0xFFF7C948),
      ),
    );
  }
}
