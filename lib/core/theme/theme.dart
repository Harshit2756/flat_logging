import 'package:flat_logging/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

/// AppTheme provides light and dark theme configurations with Material 3 support
/// Generated with Flutter Theme Generator - Clean, modular, and maintainable
///
/// Features:
/// ✅ Uses HSizes for consistent design tokens
/// ✅ Modular structure with separate theme components
/// ✅ Material 3 compliant color schemes
/// ✅ Support for 6 contrast modes (light, dark, medium/high contrast variants)
/// ✅ Production-ready with proper type declarations
class HAppTheme {
  HAppTheme._(); // Private constructor to prevent instantiation

  // static ThemeData lightTheme = ThemeData(
  //   useMaterial3: true,
  //   fontFamily: 'Poppins',
  //   colorScheme: ColorScheme.fromSeed(seedColor: HColors.primary, secondary: HColors.secondary),
  //   disabledColor: HColors.grey,
  //   brightness: Brightness.light,
  //   primaryColor: HColors.primary,
  //   textTheme: HTextTheme.lightTextTheme,
  //   chipTheme: HChipTheme.lightChipTheme,
  //   scaffoldBackgroundColor: HColors.white,
  //   appBarTheme: HAppBarTheme.lightAppBarTheme,
  //   checkboxTheme: HCheckboxTheme.lightCheckboxTheme,
  //   bottomSheetTheme: HBottomSheetTheme.lightBottomSheetTheme,
  //   elevatedButtonTheme: HElevatedButtonTheme.lightElevatedButtonTheme,
  //   segmentedButtonTheme: HSegmentedButtonTheme.lightSegmentedButtonTheme,
  //   filledButtonTheme: const FilledButtonThemeData(),
  //   outlinedButtonTheme: HOutlinedButtonTheme.lightOutlinedButtonTheme,
  //   inputDecorationTheme: HTextFormFieldTheme.lightInputDecorationTheme,
  //   floatingActionButtonTheme:
  //   HFloatingActionButtonTheme.lightFloatingActionButtonTheme,
  //   listTileTheme: HListTileTheme.lightListTileTheme,
  // );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 PUBLIC THEME GETTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light theme configuration
  static ThemeData get lightTheme => theme(lightScheme());

  /// Dark theme configuration
  static ThemeData get darkTheme => theme(darkScheme());

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🌈 COLOR SCHEMES - Material 3 compliant
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light color scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFff6b2c),
      surfaceTint: Color(0xFFff6b2c),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFffbb7c),
      onPrimaryContainer: Color(0xFFd74304),
      secondary: Color(0xFF00bfa6),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF50fff6),
      onSecondaryContainer: Color(0xFF00977e),
      tertiary: Color(0xFF9d4edd),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFed9eff),
      onTertiaryContainer: Color(0xFF7526b5),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFFFFBFE),
      onSurface: Color(0xFF1C1B1F),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
      shadow: Color(0xFFff6b2c),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color(0xFFF4EFF4),
      inversePrimary: Color(0xFFeb5718),
      primaryFixed: Color(0xFFffbb7c),
      onPrimaryFixed: Color(0xFFc32f00),
      primaryFixedDim: Color(0xFFffa768),
      onPrimaryFixedVariant: Color(0xFFeb5718),
      secondaryFixed: Color(0xFF50fff6),
      onSecondaryFixed: Color(0xFF00836a),
      secondaryFixedDim: Color(0xFF3cfbe2),
      onSecondaryFixedVariant: Color(0xFF00ab92),
      tertiaryFixed: Color(0xFFed9eff),
      onTertiaryFixed: Color(0xFF6112a1),
      tertiaryFixedDim: Color(0xFFd98aff),
      onTertiaryFixedVariant: Color(0xFF893ac9),
      surfaceDim: Color(0xFFE6E0E9),
      surfaceBright: Color(0xFFFFFBFE),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF3EDF7),
      surfaceContainerHigh: Color(0xFFECE6F0),
      surfaceContainerHighest: Color(0xFFE6E0E9),
    );
  }

  /// Dark color scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFeb5718),
      surfaceTint: Color(0xFFeb5718),
      onPrimary: Color(0xFFaf1b00),
      primaryContainer: Color(0xFFc32f00),
      onPrimaryContainer: Color(0xFFffbb7c),
      secondary: Color(0xFF00ab92),
      onSecondary: Color(0xFF006f56),
      secondaryContainer: Color(0xFF00836a),
      onSecondaryContainer: Color(0xFF50fff6),
      tertiary: Color(0xFF893ac9),
      onTertiary: Color(0xFF4d008d),
      tertiaryContainer: Color(0xFF6112a1),
      onTertiaryContainer: Color(0xFFed9eff),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF10090D),
      onSurface: Color(0xFFE6E0E9),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFFff6b2c),
      primaryFixed: Color(0xFFffbb7c),
      onPrimaryFixed: Color(0xFFc32f00),
      primaryFixedDim: Color(0xFFffa768),
      onPrimaryFixedVariant: Color(0xFFeb5718),
      secondaryFixed: Color(0xFF50fff6),
      onSecondaryFixed: Color(0xFF00836a),
      secondaryFixedDim: Color(0xFF3cfbe2),
      onSecondaryFixedVariant: Color(0xFF00ab92),
      tertiaryFixed: Color(0xFFed9eff),
      onTertiaryFixed: Color(0xFF6112a1),
      tertiaryFixedDim: Color(0xFFd98aff),
      onTertiaryFixedVariant: Color(0xFF893ac9),
      surfaceDim: Color(0xFF10090D),
      surfaceBright: Color(0xFF362F33),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xFF1D1418),
      surfaceContainer: Color(0xFF211A1E),
      surfaceContainerHigh: Color(0xFF2B2329),
      surfaceContainerHighest: Color(0xFF362F33),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎯 MAIN THEME BUILDER - Clean and modular structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Main theme function that combines all theme components
  /// Uses clean, modular structure with proper HSizes integration
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    // colorSchemeSeed: colorScheme.primary,
    colorScheme: colorScheme,
    textTheme: _textTheme,
    brightness: colorScheme.brightness,
    appBarTheme: colorScheme.brightness == Brightness.light ? _lightAppBarTheme : _darkAppBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    textButtonTheme: _textButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    dividerTheme: _dividerTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    tabBarTheme: _tabBarTheme,
    switchTheme: _switchTheme,
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    sliderTheme: _sliderTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 THEME COMPONENTS - All using HSizes for consistency
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Text theme using HSizes for consistent font sizes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: HSizes.fontSizeDisplayLarge, fontWeight: FontWeight.w400, letterSpacing: -0.25, height: 1.1228070175438596),
    displayMedium: TextStyle(fontSize: HSizes.fontSizeDisplayMedium, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.1555555555555554),
    displaySmall: TextStyle(fontSize: HSizes.fontSizeDisplaySmall, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.2222222222222223),
    headlineLarge: TextStyle(fontSize: HSizes.fontSizeHeadlineLarge, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.25),
    headlineMedium: TextStyle(fontSize: HSizes.fontSizeHeadlineMedium, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.2857142857142858),
    headlineSmall: TextStyle(fontSize: HSizes.fontSizeHeadlineSmall, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.3333333333333333),
    titleLarge: TextStyle(fontSize: HSizes.fontSizeTitleLarge, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.2727272727272727),
    titleMedium: TextStyle(fontSize: HSizes.fontSizeTitleMedium, fontWeight: FontWeight.w500, letterSpacing: 0.15, height: 1.5),
    titleSmall: TextStyle(fontSize: HSizes.fontSizeTitleSmall, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4285714285714286),
    labelLarge: TextStyle(fontSize: HSizes.fontSizeLabelLarge, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.4285714285714286),
    labelMedium: TextStyle(fontSize: HSizes.fontSizeLabelMedium, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.3333333333333333),
    labelSmall: TextStyle(fontSize: HSizes.fontSizeLabelSmall, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.4545454545454546),
    bodyLarge: TextStyle(fontSize: HSizes.fontSizeBodyLarge, fontWeight: FontWeight.w400, letterSpacing: 0.15, height: 1.5),
    bodyMedium: TextStyle(fontSize: HSizes.fontSizeBodyMedium, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1.4285714285714286),
    bodySmall: TextStyle(fontSize: HSizes.fontSizeBodySmall, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.3333333333333333),
  );

  /// Elevated button theme
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: HSizes.elevationLevel2,
      padding: EdgeInsets.symmetric(horizontal: HSizes.spacingLG, vertical: HSizes.spacingMD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    ),
  );

  /// Text button theme
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: HSizes.spacingLG, vertical: HSizes.spacingMD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    ),
  );

  /// Outlined button theme
  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: HSizes.spacingLG, vertical: HSizes.spacingMD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    ),
  );

  /// Input decoration theme
  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: HSizes.spacingMD, vertical: HSizes.spacingMD),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(HSizes.radiusMD)),
  );

  /// App bar theme for light mode
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: lightScheme().primary,
    foregroundColor: lightScheme().onPrimary,
    elevation: HSizes.elevationLevel1,
    centerTitle: false,
    titleSpacing: HSizes.spacingMD,
    scrolledUnderElevation: HSizes.elevationLevel1,
  );

  /// App bar theme for dark mode
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: darkScheme().primary,
    foregroundColor: darkScheme().onPrimary,
    elevation: HSizes.elevationLevel1,
    centerTitle: false,
    titleSpacing: HSizes.spacingMD,
    scrolledUnderElevation: HSizes.elevationLevel1,
  );

  /// Card theme
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: HSizes.elevationLevel1,
    margin: EdgeInsets.all(HSizes.spacingSM),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusLG)),
  );

  /// Chip theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: EdgeInsets.symmetric(horizontal: HSizes.spacingMD, vertical: HSizes.spacingSM),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusFull)),
  );

  /// Progress indicator theme
  static final ProgressIndicatorThemeData _progressIndicatorTheme = ProgressIndicatorThemeData();

  /// Divider theme
  static final DividerThemeData _dividerTheme = DividerThemeData(thickness: HSizes.borderWidthThin, space: HSizes.spacingMD);

  /// Bottom navigation bar theme
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme = BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed);

  /// Tab bar theme
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelPadding: EdgeInsets.symmetric(horizontal: HSizes.spacingMD, vertical: HSizes.spacingSM),
  );

  /// Switch theme
  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return lightScheme().primary;
      }
      return null;
    }),
  );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.radiusXS)));

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData();

  /// Slider theme
  static final SliderThemeData _sliderTheme = SliderThemeData();
}

/// Custom theme colors extension for additional brand colors
extension CustomColors on ColorScheme {
  /// Success color for positive actions and states
  Color get success => const Color(0xFF2E7D32);

  /// Warning color for caution states
  Color get warning => const Color(0xFFF57C00);

  /// Info color for informational states
  Color get info => const Color(0xFF1976D2);
}
