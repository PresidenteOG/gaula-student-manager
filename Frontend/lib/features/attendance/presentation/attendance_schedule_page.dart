import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/attendance_providers.dart';
import '../../admin/application/providers/cursos_provider.dart';
import '../../admin/application/providers/anio_escolar_provider.dart';


class AttendanceSchedulePage extends ConsumerWidget {
  final bool isAdmin;
  const AttendanceSchedulePage({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(attendanceScheduleNotifierProvider);
    final notifier = ref.read(attendanceScheduleNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final cardColor = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final isMobile = MediaQuery.of(context).size.width < 700;
    final scheduleNow = DateTime.now();
    final fechaStr = l10n.localeName == 'en'
        ? DateFormat('EEEE, MMMM d, y', 'en').format(scheduleNow)
        : DateFormat("EEEE, d 'de' MMMM 'de' y", l10n.localeName).format(scheduleNow)
            .replaceAllMapped(RegExp(r'(?:^|(?<= ))\w'), (m) => m[0]!.toUpperCase());

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.attendanceScheduleMyClasses, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 16),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          fechaStr,
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _showOtherClassDialog(context, ref, isAdmin),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.backgroundDarkSurface,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                                      ),
                                      child: Text(l10n.attendanceScheduleOtherClass),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.attendanceScheduleMyClasses, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            fechaStr,
                                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _showOtherClassDialog(context, ref, isAdmin),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.backgroundDarkSurface,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                                    ),
                                    child: Text(l10n.attendanceScheduleOtherClass),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: EdgeInsets.all(isMobile ? 12 : 24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: borderColor),
                          boxShadow: isDark ? null : [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isAdmin) ...[
                                    FadeInUp(
                                      delay: const Duration(milliseconds: 100),
                                      child: _buildTodaySchedulePanel(context, state, notifier, isAdmin, isDark, textColor, borderColor, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 200),
                                    child: _buildHistoryPanel(context, state, notifier, isDark, textColor, borderColor, l10n),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isAdmin) ...[
                                    Expanded(
                                      flex: 2,
                                      child: FadeInUp(
                                        delay: const Duration(milliseconds: 100),
                                        child: _buildTodaySchedulePanel(context, state, notifier, isAdmin, isDark, textColor, borderColor, l10n),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                  ],
                                  Expanded(
                                    flex: 1,
                                    child: FadeInUp(
                                      delay: const Duration(milliseconds: 200),
                                      child: _buildHistoryPanel(context, state, notifier, isDark, textColor, borderColor, l10n),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedulePanel(BuildContext context, dynamic state, dynamic notifier, bool isAdmin, bool isDark, Color textColor, Color borderColor, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.attendanceScheduleTodaySchedule, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          if (state.pendingCount > 0)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      l10n.attendanceSchedulePendingClasses(state.pendingCount),
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          if (state.schedule.isEmpty)
            Text(l10n.attendanceScheduleNoClassesToday, style: const TextStyle(color: AppColors.textSecondary)),
          ...state.schedule.map((sessionData) => _buildSessionItem(context, sessionData, isAdmin, isDark, l10n)),
        ],
      ),
    );
  }

  Widget _buildHistoryPanel(BuildContext context, dynamic state, dynamic notifier, bool isDark, Color textColor, Color borderColor, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.attendanceScheduleHistory, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              onChanged: notifier.setDateFilter,
              style: TextStyle(color: textColor, fontSize: 12),
              decoration: InputDecoration(
                hintText: l10n.attendanceScheduleSearchByDate,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 16),
              ),
            ),
          ),
          if (state.filteredHistory.isEmpty)
            Text(l10n.attendanceScheduleNoHistory, style: const TextStyle(color: AppColors.textSecondary)),
          ...state.filteredHistory.map((h) => _buildHistoryItem(h, isDark)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(BuildContext context, dynamic sessionData, bool isAdmin, bool isDark, AppLocalizations l10n) {
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5) : Colors.white,
        border: Border.all(
          color: sessionData.isPending ? Colors.orange.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.access_time_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(sessionData.time, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sessionData.subject, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${sessionData.course} - ${sessionData.room}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (sessionData.isPending)
            ElevatedButton(
              onPressed: () {
                final path = isAdmin
                    ? '/admin/asistencia/${sessionData.id}'
                    : '/profesor/asistencia/${sessionData.id}';
                context.push(path);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, inherit: true),
              ),
              child: Text(l10n.attendanceScheduleTakeAttendance),
            ),
          if (!sessionData.isPending)
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(l10n.attendanceScheduleCompleted, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic history, bool isDark) {
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: (isDark ? AppColors.border : AppColors.borderLight).withValues(alpha: 0.5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(history.subject, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14)),
          if (history.profesor != null)
            Text('Docente: ${history.profesor}', style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(history.course, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${history.attended}/${history.total}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(history.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showOtherClassDialog(BuildContext context, WidgetRef ref, bool isAdmin) {
    final searchProvider = StateProvider.autoDispose<String>((ref) => '');

    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final l10n = AppLocalizations.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final isMobile = MediaQuery.of(context).size.width < 700;
          final cursosAsync = ref.watch(cursosListProvider);
          final aniosAsync = ref.watch(anioEscolarListProvider);
          final searchQuery = ref.watch(searchProvider);
          final textColor = isDark ? Colors.white : AppColors.textDark;
          final iconMutedColor = isDark ? Colors.white70 : AppColors.textSecondary;
          final bgCard = isDark ? AppColors.backgroundDarkCard : AppColors.backgroundLightCard;
          final bgSurface = isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface;

          return Dialog(
            backgroundColor: bgCard,
            insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.of(context).size.height * 0.85),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(l10n.attendanceScheduleSelectCourse, style: TextStyle(color: textColor, fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold))),
                        IconButton(icon: Icon(Icons.close, color: iconMutedColor), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.attendanceScheduleSelectCourseHint, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 24),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (val) => ref.read(searchProvider.notifier).state = val,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                hintText: l10n.attendanceScheduleSearchCourse,
                                hintStyle: const TextStyle(color: AppColors.textSecondary),
                                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                                filled: true,
                                fillColor: bgSurface,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 24),

                            aniosAsync.when(
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, _) => Center(child: Text(l10n.attendanceScheduleErrorLoadingYears(e.toString()))),
                              data: (anios) {
                                final activeYear = anios.firstWhere((a) => a.activo, orElse: () => anios.first);

                                return cursosAsync.when(
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (e, _) => Center(child: Text('${AppLocalizations.of(context).errorGenerico}: $e', style: const TextStyle(color: Colors.red))),
                                  data: (cursos) {
                                    final filtered = cursos.where((c) {
                                      final matchesYear = c.anioEscolarId == activeYear.id;
                                      final matchesSearch = c.codigoGrupo.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                           c.nombreCiclo.toLowerCase().contains(searchQuery.toLowerCase());
                                      return matchesYear && matchesSearch;
                                    }).toList();

                                    if (filtered.isEmpty) {
                                      return Center(child: Text(l10n.attendanceScheduleNoCourses, style: const TextStyle(color: AppColors.textSecondary)));
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        final c = filtered[index];
                                        return ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          leading: Container(
                                            width: 48, height: 48,
                                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                            child: const Icon(Icons.class_outlined, color: AppColors.primary),
                                          ),
                                          title: Text(c.codigoGrupo, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                          subtitle: Text(c.nombreCiclo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: iconMutedColor),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            _showSubjectSelectionDialog(context, ref, c, isAdmin);
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
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

  void _showSubjectSelectionDialog(BuildContext context, WidgetRef ref, dynamic curso, bool isAdmin) {
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final l10n = AppLocalizations.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final isMobile = MediaQuery.of(context).size.width < 700;
          final materiasAsync = ref.watch(cursoMateriasProvider(curso.id));
          final textColor = isDark ? Colors.white : AppColors.textDark;
          final iconMutedColor = isDark ? Colors.white70 : AppColors.textSecondary;
          final bgCard = isDark ? AppColors.backgroundDarkCard : AppColors.backgroundLightCard;

          return Dialog(
            backgroundColor: bgCard,
            insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500, maxHeight: MediaQuery.of(context).size.height * 0.80),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(curso.codigoGrupo, style: TextStyle(color: textColor, fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                        IconButton(icon: Icon(Icons.close, color: iconMutedColor), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.attendanceScheduleSelectSubjectHint, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: materiasAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('${AppLocalizations.of(context).errorGenerico}: $e', style: const TextStyle(color: Colors.red))),
                          data: (materias) {
                            if (materias.isEmpty) return Center(child: Text(l10n.attendanceScheduleNoSubjects, style: const TextStyle(color: AppColors.textSecondary)));
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: materias.length,
                              itemBuilder: (context, index) {
                                final m = materias[index];
                                final materiaId = m['id'] as int;
                                return ListTile(
                                  leading: const Icon(Icons.book_outlined, color: AppColors.accent),
                                  title: Text(m['nombre'] ?? l10n.attendanceScheduleSubjectFallback, style: TextStyle(color: textColor)),
                                  subtitle: Text(m['codigo'] ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: iconMutedColor),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    _showClaseSelectionDialog(context, ref, curso, m, materiaId, isAdmin);
                                  },
                                );
                              },
                            );
                          },
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

  void _showClaseSelectionDialog(BuildContext context, WidgetRef ref, dynamic curso, dynamic materia, int materiaId, bool isAdmin) {
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final l10n = AppLocalizations.of(context);
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final isMobile = MediaQuery.of(context).size.width < 700;
          final clasesAsync = ref.watch(clasesByMateriaProvider(materiaId));
          String diaLocal(String day) => switch (day) {
            'MONDAY'    => l10n.diaLunes,
            'TUESDAY'   => l10n.diaMartes,
            'WEDNESDAY' => l10n.diaMiercoles,
            'THURSDAY'  => l10n.diaJueves,
            'FRIDAY'    => l10n.diaViernes,
            'SATURDAY'  => l10n.diaSabado,
            'SUNDAY'    => l10n.diaDomingo,
            _           => day,
          };
          final textColor = isDark ? Colors.white : AppColors.textDark;
          final iconMutedColor = isDark ? Colors.white70 : AppColors.textSecondary;
          final bgCard = isDark ? AppColors.backgroundDarkCard : AppColors.backgroundLightCard;

          return Dialog(
            backgroundColor: bgCard,
            insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 480, maxHeight: MediaQuery.of(context).size.height * 0.75),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(materia['nombre'] ?? l10n.attendanceScheduleSessionsFallback, style: TextStyle(color: textColor, fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                        IconButton(icon: Icon(Icons.close, color: iconMutedColor), onPressed: () => Navigator.pop(ctx)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.attendanceScheduleSelectSessionHint, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: clasesAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('${AppLocalizations.of(context).errorGenerico}: $e', style: const TextStyle(color: Colors.red))),
                          data: (clases) {
                            final diaHoy = DateFormat('EEEE').format(DateTime.now()).toUpperCase();
                            final hoyClases = clases.where((c) => c['diaSemana'] == diaHoy).toList();

                            if (hoyClases.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.event_busy, color: AppColors.textSecondary, size: 48),
                                    const SizedBox(height: 16),
                                    Text(l10n.attendanceScheduleNoSessionsToday, style: const TextStyle(color: AppColors.textSecondary)),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: hoyClases.length,
                              itemBuilder: (context, index) {
                                final c = hoyClases[index];
                                final claseId = (c['id'] ?? '').toString();
                                if (claseId.isEmpty || claseId == 'null') return const SizedBox.shrink();
                                final dia = diaLocal(c['diaSemana'] ?? '');
                                final horaInicio = c['horaInicio'] ?? '';
                                final horaFin = c['horaFin'] ?? '';
                                final aula = c['aula'] ?? l10n.attendanceScheduleAulaFallback;
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  leading: Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                                    child: const Icon(Icons.access_time_outlined, color: AppColors.accent),
                                  ),
                                  title: Text('$dia · $horaInicio – $horaFin', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                                  subtitle: Text('$aula · ${curso.codigoGrupo}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      final path = isAdmin
                                          ? '/admin/asistencia/$claseId'
                                          : '/profesor/asistencia/$claseId';
                                      context.push(path);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(l10n.attendanceScheduleTakeAttendance),
                                  ),
                                );
                              },
                            );
                          },
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
}

