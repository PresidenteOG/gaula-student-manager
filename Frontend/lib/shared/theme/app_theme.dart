import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/storage/secure_storage.dart';

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(secureStorageProvider));
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(secureStorageProvider));
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SecureStorageService _storage;

  LocaleNotifier(this._storage) : super(const Locale('es', 'ES')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = await _storage.getLocale();
    if (code != null) state = _fromCode(code);
  }

  Future<void> setLocaleFromCode(String code) async {
    state = _fromCode(code);
    await _storage.saveLocale(code);
  }

  static Locale _fromCode(String code) {
    switch (code) {
      case 'EN': return const Locale('en', 'US');
      case 'CA': return const Locale('ca');
      default:   return const Locale('es', 'ES');
    }
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SecureStorageService _storage;

  ThemeNotifier(this._storage) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await _storage.getTheme();
    if (mode == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Cambia el tema localmente. 
  /// NOTA: El guardado en servidor se hace desde el AuthRepository 
  /// o ProfileController cuando se pulsa el switch.
  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _storage.saveTheme(mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }
}

/// Sistema de diseño y tema de la aplicación GAULA.
///
/// Usa la tipografía Inter de Google Fonts (consistente con el diseño de Figma).
/// El tema oscuro es el principal de la app.
/// El tema claro está disponible para preferencia del usuario.
abstract class AppTheme {
  AppTheme._();

  // ── Fuente principal ──
  static TextTheme _textTheme(Color baseColor) => GoogleFonts.interTextTheme(
    TextTheme(
      // Títulos de pantalla
      displayLarge:  TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: baseColor),
      displayMedium: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: baseColor),
      displaySmall:  TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: baseColor),
      // Encabezados de sección
      headlineLarge:  TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: baseColor),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: baseColor),
      headlineSmall:  TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: baseColor),
      // Títulos de tarjeta / etiquetas
      titleLarge:  TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: baseColor),
      titleSmall:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: baseColor),
      // Cuerpo de texto
      bodyLarge:   TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: baseColor),
      bodyMedium:  TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: baseColor),
      bodySmall:   TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: baseColor),
      // Etiquetas pequeñas / chips
      labelLarge:  TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: baseColor),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      labelSmall:  TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: baseColor, letterSpacing: 0.5),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // TEMA OSCURO
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary:                    AppColors.primary,
        secondary:                  AppColors.primaryLight,
        surface:                    AppColors.backgroundDarkCard,
        error:                      AppColors.error,
        onPrimary:                  Colors.white,
        onSecondary:                Colors.white,
        onSurface:                  AppColors.textPrimary,
        onError:                    Colors.white,
        outline:                    AppColors.border,
        surfaceContainerHighest:    AppColors.backgroundDarkSurface,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme(AppColors.textPrimary),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: AppColors.backgroundDarkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Botones primarios ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Botones de texto ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // ── Botones OutlinedButton ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Campos de texto (TextField / TextFormField) ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundDarkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        errorStyle: const TextStyle(color: AppColors.error),
      ),

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDarkCard,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Drawer (sidebar en móvil) ──
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.sidebarDark,
        scrimColor: Colors.black54,
      ),

      // ── BottomNavigationBar (móvil) ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDarkCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundDarkSurface,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── Divisores ──
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ── Diálogos ──
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundDarkCard,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── SnackBars ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.backgroundDarkSurface,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TEMA CLARO
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary:                    AppColors.primary,
        secondary:                  AppColors.primaryDark,
        surface:                    AppColors.backgroundLightCard,
        error:                      AppColors.error,
        onPrimary:                  Colors.white,
        onSecondary:                Colors.white,
        onSurface:                  AppColors.textDark,
        onError:                    Colors.white,
        outline:                    AppColors.borderLight,
        surfaceContainerHighest:    AppColors.backgroundLightSurface,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textTheme(AppColors.textDark),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Cards en modo claro ──
      cardTheme: CardThemeData(
        color: AppColors.backgroundLightCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Inputs en modo claro ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        errorStyle: const TextStyle(color: AppColors.error),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textDark,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Drawer (sidebar en móvil) ──
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        scrimColor: Colors.black26,
      ),

      // ── BottomNavigationBar (móvil) ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundLightSurface,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.textDark, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── Divisores ──
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // ── Diálogos ──
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // ── SnackBars ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textDark,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
