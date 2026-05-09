import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoldGradientText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;

  const GoldGradientText(
    this.text, {
    super.key,
    this.size = 24,
    this.weight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFFFFF7D5),
            Color(0xFFF7C948),
            Color(0xFFC78822),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: GoogleFonts.playfairDisplay(
          fontSize: size,
          fontWeight: weight,
          color: Colors.white,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
