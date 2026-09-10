import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/teacher_dashboard_provider.dart';

class TeacherOverviewScreen extends ConsumerWidget {
  const TeacherOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final fechaStr = l10n.localeName == 'en'
        ? DateFormat('EEEE, MMMM d, y', 'en').format(now)
        : DateFormat("EEEE, d 'de' MMMM 'de' y", l10n.localeName).format(now);

    final dashboardAsync = ref.watch(teacherDashboardProvider);
    final teacherSlotsAsync = ref.watch(sesionesProximasProvider);
    final proximaSesionAsync = ref.watch(proximaSesionProvider);
    final pendientesAsync   = ref.watch(sesionesPendientesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (dashboardData) {
          final stats = [
            {'label': l10n.dashClasesHoy, 'value': dashboardData['clasesHoy']?.toString() ?? '0', 'icon': Icons.calendar_today, 'color': const Color(0xFF60A5FA)},
            {'label': l10n.dashAlumnosTotales, 'value': dashboardData['totalAlumnos']?.toString() ?? '0', 'icon': Icons.people, 'color': const Color(0xFF34D399)},
            {'label': l10n.dashIncidenciasHoy, 'value': dashboardData['incidenciasHoy']?.toString() ?? '0', 'icon': Icons.error_outline, 'color': const Color(0xFFF472B6)},
            {'label': l10n.dashAsistenciaMedia, 'value': dashboardData['asistenciaMedia']?.toString() ?? '90%', 'icon': Icons.trending_up, 'color': const Color(0xFFFBBF24)},
          ];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: SingleChildScrollView(
                padding: MediaQuery.of(context).size.width < 600
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
                    : const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    FadeInDown(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.saludoHola(usuario?.nombre.split(' ').first ?? l10n.saludoProfesor),
                                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textDark),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  fechaStr.substring(0, 1).toUpperCase() + fechaStr.substring(1),
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          _buildProfileAvatar(context, usuario?.avatar ?? '👨‍🏫'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Stats Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisExtent: 160,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
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
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 48),

                    // Main Content Area
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _SectionCard(
                            title: l10n.seccionListasPendientes,
                            icon: Icons.assignment_late,
                            iconColor: AppColors.warning,
                            child: pendientesAsync.when(
                              data: (pendientes) {
                                if (pendientes.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32),
                                    child: Center(child: Text(l10n.todoAlDia, style: const TextStyle(color: AppColors.textSecondary))),
                                  );
                                }
                                return Column(
                                  children: pendientes.map((p) => _PendingItem(
                                    sesionId: p['sesionId'].toString(),
                                    subject: p['materia'] ?? 'Clase',
                                    course: p['curso'] ?? '-',
                                    time: p['hora'] ?? '--:--',
                                    date: l10n.fechaHoy,
                                  )).toList(),
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('Error: $e'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: _SectionCard(
                            title: l10n.seccionProximasClases,
                            icon: Icons.calendar_today,
                            iconColor: AppColors.primary,
                            child: teacherSlotsAsync.when(
                              data: (sesiones) {
                                final hoyClases = sesiones /* solo contiene las de hoy */;
                                if (hoyClases.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32),
                                    child: Center(child: Text(l10n.sinClasesHoy, style: const TextStyle(color: AppColors.textSecondary))),
                                  );
                                }
                                return Column(
                                  children: hoyClases.map((s) => _ClassItem(
                                    subject: s['materia'] ?? 'Materia', 
                                    course: s['curso'] ?? 'Curso',
                                    time: s['hora']?.toString().split(' - ')[0] ?? '??:??', 
                                    room: s['aula'] ?? 'Aula N/A'
                                  )).toList(),
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('Error: $e'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Quick Access Banner (Match Figma)
                    FadeInUp(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFF1976D2)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            proximaSesionAsync.when(
                              data: (sesion) {
                                if (sesion == null) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.accesRapido, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                      Text(l10n.sinClasesProximas, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                    ],
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.proximaClaseLabel(sesion['materiaNombre'] ?? ''), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                    Text(l10n.aulaHoraLabel(sesion['aula'] ?? '—', sesion['horaInicio'] ?? '', sesion['horaFin'] ?? ''), style: const TextStyle(color: Colors.white70, fontSize: 16)),
                                  ],
                                );
                              },
                              loading: () => const CircularProgressIndicator(color: Colors.white),
                              error: (_, __) => Text(l10n.errorCargarProximaClase, style: const TextStyle(color: Colors.white70)),
                            ),
                            ElevatedButton(
                              onPressed: proximaSesionAsync.maybeWhen(
                                data: (sesion) => sesion != null
                                  ? () => context.pushNamed('teacher-asistencia', pathParameters: {'sessionId': sesion['id'].toString()})
                                  : null,
                                orElse: () => null,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.accentForeground,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              child: Text(l10n.irAPasarLista),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, String avatar) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isEmoji = avatar.length < 10 && !avatar.contains('.');
    return Container(
      width: 80, height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade200,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: isEmoji 
        ? Center(child: Text(avatar, style: const TextStyle(fontSize: 40)))
        : Image.network(
            '${ApiConstants.uploadsBaseUrl}$avatar',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(child: Text('👨‍🏫', style: TextStyle(fontSize: 40))),
          ),
    );
  }
}

// Reutilizamos componentes estilizados del AdminDashboard para mantener consistencia 100%
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(value, style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
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
  const _SectionCard({required this.title, required this.icon, required this.iconColor, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _PendingItem extends StatelessWidget {
  final String sesionId;
  final String subject;
  final String course;
  final String time;
  final String date;
  const _PendingItem({required this.sesionId, required this.subject, required this.course, required this.time, required this.date});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return InkWell(
      onTap: () => context.pushNamed('teacher-asistencia', pathParameters: {'sessionId': sesionId}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.warning.withValues(alpha: 0.1), Colors.transparent], begin: Alignment.centerLeft, end: Alignment.centerRight),
          border: const Border(left: BorderSide(color: AppColors.warning, width: 4)),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(subject, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Text(course, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 2,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.access_time, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassItem extends StatelessWidget {
  final String subject;
  final String course;
  final String time;
  final String room;
  const _ClassItem({required this.subject, required this.course, required this.time, required this.room});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).fechaHoy, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(course, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 2),
                Text(room, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
