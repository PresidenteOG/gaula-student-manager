import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../auth/application/providers/auth_provider.dart';
import '../../shared/providers/horario_provider.dart';
import '../../attendance/application/attendance_providers.dart';
import '../../shared/presentation/horario_screen.dart';

class StudentOverviewScreen extends ConsumerWidget {
  const StudentOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final alumnoId = usuario?.id;
    final now = DateTime.now();
    final fechaStr = l10n.localeName == 'en'
        ? DateFormat('EEEE, MMMM d, y', 'en').format(now)
        : DateFormat("EEEE, d 'de' MMMM 'de' y", l10n.localeName).format(now);

    final horarioAsync = alumnoId != null
        ? ref.watch(studentHorarioProvider(alumnoId))
        : null;

    final summaryAsync = alumnoId != null
        ? ref.watch(studentAttendanceSummaryProvider(alumnoId))
        : null;

    // Build today's day key (English uppercase for backend)
    final diaHoyEn = DateFormat('EEEE', 'en_US').format(now).toUpperCase();

    final isMobile = GaulaResponsive.isM(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: isMobile
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
            : const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            FadeInDown(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.saludoHola(usuario?.nombre.split(' ').first ?? l10n.saludoEstudiante),
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 48,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fechaStr.substring(0, 1).toUpperCase() + fechaStr.substring(1),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: isMobile ? 13 : 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 24 : 48),

            // Stats Grid — live data
            if (summaryAsync != null)
              summaryAsync.when(
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(color: AppColors.primary),
                )),
                error: (_, __) => _StatsGrid(pct: 100, ausentes: 0, retrasos: 0, horasFaltadas: 0, total: 0),
                data: (resumen) {
                  final pct = (resumen['porcentajeAsistencia'] as num?)?.toDouble() ?? 100.0;
                  final ausentes = resumen['ausentes'] ?? 0;
                  final retrasos = resumen['retrasos'] ?? 0;
                  final horasFaltadas = (resumen['horasFaltadas'] as num?)?.toDouble() ?? 0.0;
                  final total = resumen['totalClases'] ?? 0;
                  return _StatsGrid(pct: pct, ausentes: ausentes, retrasos: retrasos, horasFaltadas: horasFaltadas, total: total, isMobile: isMobile);
                },
              )
            else
              _StatsGrid(pct: 100, ausentes: 0, retrasos: 0, horasFaltadas: 0, total: 0, isMobile: isMobile),

            SizedBox(height: isMobile ? 24 : 48),

            // Mis Clases de Hoy — real schedule
            _SectionCard(
              title: l10n.misClasesHoy,
              icon: Icons.school_outlined,
              iconColor: AppColors.primary,
              actionWidget: TextButton.icon(
                onPressed: () {
                  if (alumnoId != null) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: AppColors.backgroundDarkCard,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 800),
                          child: HorarioScreen(isStudent: true, studentId: alumnoId),
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.calendar_month, color: AppColors.primary),
                label: Text(l10n.horarioCompleto, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              child: horarioAsync == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text(l10n.cargandoHorario, style: const TextStyle(color: AppColors.textSecondary))),
                  )
                : horarioAsync.when(
                    loading: () => const Center(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: Text(l10n.errorCargandoHorario, style: const TextStyle(color: Colors.redAccent))),
                    ),
                    data: (clases) {
                      final hoyClases = clases.where((c) => c.diaSemana == diaHoyEn).toList();
                      if (hoyClases.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: Text(l10n.sinClasesHoyAlumno, style: const TextStyle(color: AppColors.textSecondary))),
                        );
                      }
                      return Column(
                        children: hoyClases.map((c) => _StudentClassItem(
                          subject: c.materiaNombre ?? 'Materia',
                          time: c.horaInicio,
                          room: c.aula ?? 'Aula',
                          teacher: c.profesorNombre ?? '',
                        )).toList(),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final double pct;
  final int ausentes, retrasos, total;
  final double horasFaltadas;
  final bool isMobile;

  const _StatsGrid({required this.pct, required this.ausentes, required this.retrasos, required this.horasFaltadas, required this.total, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final statColor = pct >= 80 ? const Color(0xFF34D399) : pct >= 60 ? const Color(0xFFFBBF24) : const Color(0xFFEF4444);
    final l10n = AppLocalizations.of(context);
    final stats = [
      {'label': l10n.dashAsistenciaTotal, 'value': '$pct%', 'icon': Icons.check_circle_outline, 'color': statColor},
      {'label': l10n.dashAusencias, 'value': '$ausentes', 'icon': Icons.cancel_outlined, 'color': const Color(0xFFEF4444)},
      {'label': l10n.dashRetrasos, 'value': '$retrasos', 'icon': Icons.access_time, 'color': const Color(0xFFFBBF24)},
      {'label': l10n.dashHorasFaltadas, 'value': '${horasFaltadas.toStringAsFixed(1)}h', 'icon': Icons.timer_off_outlined, 'color': const Color(0xFFF472B6)},
      {'label': l10n.dashClasesTotales, 'value': '$total', 'icon': Icons.calendar_month, 'color': const Color(0xFF60A5FA)},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: isMobile ? 180 : 300,
        mainAxisExtent: isMobile ? 120 : 160,
        crossAxisSpacing: isMobile ? 12 : 24,
        mainAxisSpacing: isMobile ? 12 : 24,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: _StatCard(
            label: stat['label'] as String,
            value: stat['value'] as String,
            icon: stat['icon'] as IconData,
            color: stat['color'] as Color,
            isMobile: isMobile,
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isMobile;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: isMobile ? 36 : 48, height: isMobile ? 36 : 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: isMobile ? 18 : 24),
              ),
              Text(value, style: TextStyle(color: color, fontSize: isMobile ? 22 : 30, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: isMobile ? 11 : 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final Widget? actionWidget;
  const _SectionCard({required this.title, required this.icon, required this.iconColor, required this.child, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    final isMobile = GaulaResponsive.isM(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Icon(icon, color: iconColor, size: isMobile ? 20 : 24),
              Text(title, style: TextStyle(color: textColor, fontSize: isMobile ? 16 : 24, fontWeight: FontWeight.bold)),
              if (actionWidget != null) actionWidget!,
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          child,
        ],
      ),
    );
  }
}

class _StudentClassItem extends StatelessWidget {
  final String subject;
  final String time;
  final String room;
  final String teacher;
  const _StudentClassItem({required this.subject, required this.time, required this.room, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5) : Colors.grey.shade50,
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(time, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('$room • $teacher', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          // const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

