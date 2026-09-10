import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// The four possible attendance states for a student in a session.
/// `null` means the teacher has not recorded the student yet.
enum AttendanceStatus {
  presente,
  ausente,
  retraso,
  justificado;

  String get label {
    switch (this) {
      case AttendanceStatus.presente:    return 'Presente';
      case AttendanceStatus.ausente:     return 'Ausente';
      case AttendanceStatus.retraso:     return 'Retraso';
      case AttendanceStatus.justificado: return 'Justificado';
    }
  }

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case AttendanceStatus.presente:    return l10n.asistenciaPresente;
      case AttendanceStatus.ausente:     return l10n.asistenciaAusente;
      case AttendanceStatus.retraso:     return l10n.asistenciaRetraso;
      case AttendanceStatus.justificado: return l10n.asistenciaJustificado;
    }
  }

  Color get activeColor {
    switch (this) {
      case AttendanceStatus.presente:    return const Color(0xFF22C55E);
      case AttendanceStatus.ausente:     return const Color(0xFFEF4444);
      case AttendanceStatus.retraso:     return const Color(0xFFFFA50F);
      case AttendanceStatus.justificado: return const Color(0xFF3B82F6);
    }
  }

  IconData get icon {
    switch (this) {
      case AttendanceStatus.presente:    return Icons.check_circle_outline_rounded;
      case AttendanceStatus.ausente:     return Icons.cancel_outlined;
      case AttendanceStatus.retraso:     return Icons.timer_outlined;
      case AttendanceStatus.justificado: return Icons.assignment_outlined;
    }
  }

  Color cardBackground(bool isDark) {
    switch (this) {
      case AttendanceStatus.presente:    return isDark ? AppColors.backgroundDarkCard : Colors.white;
      case AttendanceStatus.ausente:     return isDark ? const Color(0xFF2D0A0A) : const Color(0xFFFDE8E8);
      case AttendanceStatus.retraso:     return isDark ? const Color(0xFF2D1A00) : const Color(0xFFFEF0DC);
      case AttendanceStatus.justificado: return isDark ? const Color(0xFF0A1428) : const Color(0xFFDCEEFF);
    }
  }

  Color cardBorderColor(bool isDark) {
    switch (this) {
      case AttendanceStatus.presente:    return isDark ? AppColors.border : AppColors.borderLight;
      case AttendanceStatus.ausente:     return const Color(0xFFEF4444).withValues(alpha: 0.5);
      case AttendanceStatus.retraso:     return const Color(0xFFFFA50F).withValues(alpha: 0.5);
      case AttendanceStatus.justificado: return const Color(0xFF3B82F6).withValues(alpha: 0.5);
    }
  }
}



