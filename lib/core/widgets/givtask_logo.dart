import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GivTaskLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const GivTaskLogo({
    super.key,
    this.size = 60.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;
    final fontSize = size * 0.7; // Scale font size relative to icon size
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.volunteer_activism,
          color: logoColor,
          size: size,
        ),
        SizedBox(width: size * 0.25),
        Text(
          'GivTask',
          style: GoogleFonts.inter(
            color: logoColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
