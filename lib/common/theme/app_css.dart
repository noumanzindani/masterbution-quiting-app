import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Prebuilt [TextStyle]s so screens don't re-specify font/size/weight.
/// Colour is applied per-use via the `.textColor()` extension below (styles
/// stay colour-agnostic because colour is theme/context dependent).
///
/// Type pairing: Outfit for display/headings (friendly, rounded, non-clinical),
/// DM Sans for body/labels (highly legible at small sizes).
class AppCss {
  // Display / headings ------------------------------------------------------
  TextStyle get displayBold28 =>
      GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  TextStyle get headingBold22 =>
      GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, height: 1.25);
  TextStyle get titleSemi18 =>
      GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600);
  TextStyle get titleSemi16 =>
      GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600);

  // Body / labels -----------------------------------------------------------
  TextStyle get body16 =>
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, height: 1.45);
  TextStyle get body14 =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);
  TextStyle get medium14 =>
      GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500);
  TextStyle get label12 =>
      GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500);
  TextStyle get buttonSemi16 =>
      GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600);

  // Numbers (streak counters etc.) — tabular so digits don't jitter ---------
  TextStyle get counterBold40 => GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

/// Fluent colour application: `appCss.body16.textColor(theme.darkText)`.
extension TextStyleX on TextStyle {
  TextStyle textColor(Color color) => copyWith(color: color);
  TextStyle sized(double size) => copyWith(fontSize: size);
  TextStyle weight(FontWeight w) => copyWith(fontWeight: w);
}
