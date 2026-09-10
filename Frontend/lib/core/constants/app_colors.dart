import 'package:flutter/material.dart';

/// Paleta de colores exacta extraída del prototipo Figma/React (theme.css).
/// Proporciona consistencia visual al 100% con la web.
class AppColors {
  AppColors._();

  // ── Colores Base (Modo Oscuro Premium) ──
  static const Color backgroundDark      = Color(0xFF0A0E1A); // --background
  static const Color backgroundDarkCard  = Color(0xFF111827); // --card
  static const Color backgroundDarkSurface = Color(0xFF1E293B); // --secondary
  static const Color border              = Color(0xFF1E293B); // --border
  
  // ── Colores Base (Modo Claro Premium - Blanco con toque Azul) ──
  static const Color backgroundLight     = Color(0xFFE3F2FD); // --background
  static const Color backgroundLightCard = Color(0xFFFFFFFF); // --card
  static const Color backgroundLightSurface = Color(0xFFF1F5F9);
  static const Color borderLight         = Color(0xFFD1E9FF); // More visible border in light mode

  // ── Primario y Acentos (FINALE EXACT) ──
  static const Color primary             = Color(0xFF60A5FA); // --primary (dark)
  static const Color primaryLight        = Color(0xFF93C5FD); // --blue-light
  static const Color primaryDark         = Color(0xFF3B82F6); // --blue-dark
  static const Color bluePrimary         = Color(0xFF2196F3); // --blue-primary (light mode)
  
  static const Color delay               = Color(0xFFFFA50F); // Figma EXACT for Retraso
  static const Color accent              = Color(0xFFFBBF24); // --accent (Amber 400)
  static const Color accentForeground    = Color(0xFF0A0E1A);
  static const Color yellowPrimary       = Color(0xFFFF9800); // --yellow-primary

  // ── Texto ──
  static const Color textPrimary         = Color(0xFFE8EEF7); // --foreground (dark)
  static const Color textSecondary       = Color(0xFF94A3B8); // --muted-foreground (dark)
  static const Color textMuted           = Color(0xFF334155); // Darker for better contrast in light mode
  static const Color textDark            = Color(0xFF0F172A); // --foreground (light)

  // ── Estados Semánticos ──
  static const Color success             = Color(0xFF34D399); // --chart-3 (Emerald)
  static const Color error               = Color(0xFFEF4444); // --destructive
  static const Color errorLight          = Color(0xFFF87171);
  static const Color warning             = Color(0xFFFBBF24); // --chart-2
  static const Color info                = Color(0xFF60A5FA);

  // ── UI Tokens ──
  static const Color present             = Color(0xFF34D399);
  static const Color absent              = Color(0xFFEF4444);
  static const Color late                = Color(0xFFF59E0B);
  static const Color excused             = Color(0xFF3B82F6);

  // ── Sidebar Tokens (FINALE EXACT) ──
  static const Color sidebarBackground   = Color(0xFF0F172A); // --sidebar (dark)
  static const Color sidebarDark         = Color(0xFF0F172A); 
  static const Color sidebarBorder       = Color(0xFF1E293B); // --sidebar-border
  static const Color sidebarAccent       = Color(0xFF1E293B); // --sidebar-accent
  static const Color sidebarLight        = Color(0xFFFFFFFF); // --sidebar (light)
  
  // ── Muted & Glass ──
  static const Color mutedForeground     = Color(0xFF94A3B8); // --muted-foreground
  static const Color backdropBlur        = Color(0xCC0F172A); // 80% opacity
  static const Color cicloDAM            = Color(0xFF60A5FA);
  static const Color cicloDAW            = Color(0xFF34D399);
  static const Color cicloASIX           = Color(0xFFA78BFA);
  static const Color cicloSMIX           = Color(0xFFFBBF24);

  // ── Gradientes Figma ──
  static const LinearGradient logoGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Devuelve el color semántico según el estado (ACTIVO, INACTIVO, etc.)
  static Color forEstado(String? estado) {
    switch (estado?.toUpperCase()) {
      case 'ACTIVO':
        return success;
      case 'INACTIVO':
        return error;
      case 'PENDIENTE':
        return warning;
      default:
        return textSecondary;
    }
  }
}
