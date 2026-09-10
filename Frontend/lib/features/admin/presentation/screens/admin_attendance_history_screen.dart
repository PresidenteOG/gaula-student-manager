import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../attendance/application/attendance_providers.dart';
import '../../../attendance/domain/entities/class_attendance.dart';
import '../../application/providers/cursos_provider.dart';
import '../../../shared/models/curso_model.dart';
import '../widgets/attendance_detail_dialog.dart';
import '../widgets/gaula_pagination.dart';
import '../../../attendance/application/attendance_history_providers.dart';
import '../../../../shared/widgets/gaula_searchable_dropdown.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminAttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AdminAttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AdminAttendanceHistoryScreen> createState() => _AdminAttendanceHistoryScreenState();
}

class _AdminAttendanceHistoryScreenState extends ConsumerState<AdminAttendanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final cursosAsync = ref.watch(cursosListProvider);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeInUp(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(l10n.adminHistorialTitulo,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: isDark ? Colors.white : AppColors.textDark,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -1)),
                              ),
                              _RefreshButton(onTap: () {
                                ref.invalidate(globalAttendanceHistoryProvider);
                                ref.read(attendanceHistoryPageProvider.notifier).state = 0;
                              }),
                            ],
                          ),
                          Text(l10n.adminHistorialSubtitulo,
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      )
                    : Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.adminHistorialTituloDesktop,
                                  style: TextStyle(
                                      color: isDark ? Colors.white : AppColors.textDark,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1)),
                              Text(l10n.adminHistorialSubtituloDesktop,
                                  style: TextStyle(
                                      color: AppColors.textSecondary, fontSize: 16)),
                            ],
                          ),
                          const Spacer(),
                          _RefreshButton(onTap: () {
                            ref.invalidate(globalAttendanceHistoryProvider);
                            ref.read(attendanceHistoryPageProvider.notifier).state = 0;
                          }),
                        ],
                      ),
                const SizedBox(height: 40),

                Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: isDark ? AppColors.border : AppColors.borderLight,
                        width: 2),
                  ),
                  child: isMobile
                      ? Column(
                          children: [
                            _FilterInput(
                              hint: l10n.adminHistorialBuscarHint,
                              icon: Icons.search_rounded,
                              onChanged: (val) {
                                ref.read(attendanceHistorySearchProvider.notifier).state = val;
                                ref.read(attendanceHistoryPageProvider.notifier).state = 0;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _DateRangeFilter(
                                    range: ref.watch(attendanceHistoryDateRangeProvider),
                                    anyDateLabel: l10n.adminHistorialCualquierFecha,
                                    onTap: () async {
                                      final picked = await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                        initialDateRange: ref.read(attendanceHistoryDateRangeProvider),
                                      );
                                      if (picked != null) {
                                        ref.read(attendanceHistoryDateRangeProvider.notifier).state = picked;
                                        ref.read(attendanceHistoryPageProvider.notifier).state = 0;
                                      }
                                    },
                                    onClear: () {
                                      ref.read(attendanceHistoryDateRangeProvider.notifier).state = null;
                                      ref.read(attendanceHistoryPageProvider.notifier).state = 0;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GaulaSearchableDropdown<CursoModel?>(
                                    initialValue: [null, ...?cursosAsync.value]
                                        .where((c) =>
                                            c?.codigoGrupo ==
                                            ref.watch(attendanceHistoryCourseProvider))
                                        .firstOrNull,
                                    items: [null, ...?cursosAsync.value],
                                    label: l10n.adminHistorialCursoLabel,
                                    hint: l10n.adminHistorialGrupoHint,
                                    itemLabel: (c) =>
                                        c == null ? l10n.adminHistorialTodos : c.codigoGrupo,
                                    onChanged: (val) {
                                      ref
                                          .read(attendanceHistoryCourseProvider.notifier)
                                          .state = val?.codigoGrupo;
                                      ref
                                          .read(attendanceHistoryPageProvider.notifier)
                                          .state = 0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _FilterInput(
                                hint: l10n.adminHistorialBuscarHint,
                                icon: Icons.search_rounded,
                                onChanged: (val) {
                                  ref
                                      .read(attendanceHistorySearchProvider.notifier)
                                      .state = val;
                                  ref
                                      .read(attendanceHistoryPageProvider.notifier)
                                      .state = 0;
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            _DateRangeFilter(
                              range: ref.watch(attendanceHistoryDateRangeProvider),
                              anyDateLabel: l10n.adminHistorialCualquierFecha,
                              onTap: () async {
                                final picked = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  initialDateRange:
                                      ref.read(attendanceHistoryDateRangeProvider),
                                );
                                if (picked != null) {
                                  ref
                                      .read(attendanceHistoryDateRangeProvider.notifier)
                                      .state = picked;
                                  ref
                                      .read(attendanceHistoryPageProvider.notifier)
                                      .state = 0;
                                }
                              },
                              onClear: () {
                                ref
                                    .read(attendanceHistoryDateRangeProvider.notifier)
                                    .state = null;
                                ref
                                    .read(attendanceHistoryPageProvider.notifier)
                                    .state = 0;
                              },
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: GaulaSearchableDropdown<CursoModel?>(
                                initialValue: [null, ...?cursosAsync.value]
                                    .where((c) =>
                                        c?.codigoGrupo ==
                                        ref.watch(attendanceHistoryCourseProvider))
                                    .firstOrNull,
                                items: [null, ...?cursosAsync.value],
                                label: l10n.adminHistorialCursoLabel,
                                hint: l10n.adminHistorialTodosGrupos,
                                itemLabel: (c) =>
                                    c == null ? l10n.adminHistorialTodosGrupos : c.codigoGrupo,
                                onChanged: (val) {
                                  ref
                                      .read(attendanceHistoryCourseProvider.notifier)
                                      .state = val?.codigoGrupo;
                                  ref
                                      .read(attendanceHistoryPageProvider.notifier)
                                      .state = 0;
                                },
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 32),

                ref.watch(paginatedAttendanceHistoryProvider).when(
                  data: (records) {
                    if (records.isEmpty) return _buildEmptyState(isDark, l10n);
                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 40),
                          itemCount: records.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return FadeInRight(
                              delay: Duration(milliseconds: 30 * index),
                              child: _HistoryRecordTile(record: records[index]),
                            );
                          },
                        ),
                        GaulaPagination(
                          currentPage: ref.watch(attendanceHistoryPageProvider),
                          totalPages: ref.watch(attendanceHistoryTotalPagesProvider),
                          onPageChanged: (page) => ref.read(attendanceHistoryPageProvider.notifier).state = page,
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.textMuted.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          Text(l10n.adminHistorialSinRegistros, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _HistoryRecordTile extends StatelessWidget {
  final ClassAttendance record;
  const _HistoryRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);
    final percent = record.attendanceRatio * 100;
    final color = percent >= 90 ? Colors.greenAccent : (percent >= 70 ? AppColors.primary : Colors.orangeAccent);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: isMobile
          ? _buildMobileTile(context, isDark, l10n, percent, color)
          : _buildDesktopTile(context, isDark, l10n, percent, color),
    );
  }

  Widget _buildMobileTile(BuildContext context, bool isDark, AppLocalizations l10n, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _CourseBadge(label: record.course),
            const SizedBox(width: 8),
            Expanded(
              child: Text(record.subject,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
            Text('${percent.toInt()}%', style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person_pin_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(record.profesor ?? l10n.adminHistorialSinDocente,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
            Text(l10n.adminHistorialAlumnos((record.total - record.absent), record.total),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _showDetails(context),
              icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                minimumSize: const Size(36, 36),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopTile(BuildContext context, bool isDark, AppLocalizations l10n, double percent, Color color) {
    return Row(
      children: [
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
          child: Builder(
            builder: (context) {
              DateTime? dt;
              try {
                if (record.date.contains('/')) {
                  final parts = record.date.split('/');
                  dt = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                } else {
                  dt = DateTime.parse(record.date);
                }
              } catch (_) {
                dt = DateTime.now();
              }
              return Column(
                children: [
                  Text(dt.day.toString(), style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.w900, height: 1)),
                  Text(_getMonthAbbr(dt.month.toString()), style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CourseBadge(label: record.course),
                  const SizedBox(width: 12),
                  Expanded(child: Text(record.subject, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_pin_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(record.profesor ?? l10n.adminHistorialSinDocente, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${percent.toInt()}%', style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900)),
            Text(l10n.adminHistorialAlumnos((record.total - record.absent), record.total), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
        const SizedBox(width: 32),
        IconButton(
          onPressed: () => _showDetails(context),
          icon: const Icon(Icons.remove_red_eye_rounded, size: 18),
          style: IconButton.styleFrom(backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
        ),
      ],
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AttendanceSessionDetailDialog(record: record),
    );
  }

  String _getMonthAbbr(String m) {
    const months = {'1':'ENE','2':'FEB','3':'MAR','4':'ABR','5':'MAY','6':'JUN','7':'JUL','8':'AGO','9':'SEP','10':'OCT','11':'NOV','12':'DIC'};
    return months[m] ?? '???';
  }
}

class _CourseBadge extends StatelessWidget {
  final String label;
  const _CourseBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _FilterInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const _FilterInput({required this.hint, required this.icon, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final DateTimeRange? range;
  final String anyDateLabel;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const _DateRangeFilter({required this.range, required this.anyDateLabel, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = range != null ? AppColors.primary : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkSurface : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: range != null ? AppColors.primary : Colors.transparent, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded, color: color, size: 20),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                range == null ? anyDateLabel : '${DateFormat('d MMM').format(range!.start)} - ${DateFormat('d MMM').format(range!.end)}',
                style: TextStyle(color: color, fontWeight: range != null ? FontWeight.bold : FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (range != null) ...[
              const SizedBox(width: 12),
              IconButton(onPressed: onClear, icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.primary), constraints: const BoxConstraints()),
            ],
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
      style: IconButton.styleFrom(backgroundColor: AppColors.primary.withValues(alpha: 0.1), padding: const EdgeInsets.all(16)),
    );
  }
}
