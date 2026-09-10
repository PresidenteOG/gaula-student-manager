import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/gaula_profile_image.dart';
import '../../../attendance/application/attendance_providers.dart';
import '../../../attendance/domain/entities/class_attendance.dart';

class AttendanceSessionDetailDialog extends ConsumerWidget {
  final ClassAttendance record;
  const AttendanceSessionDetailDialog({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = MediaQuery.of(context).size.width < 700;

    String apiDate = record.date;
    try {
      if (record.date.contains('/')) {
        final parts = record.date.split('/');
        final dt = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        apiDate = DateFormat('yyyy-MM-dd').format(dt);
      }
    } catch (_) {}

    final studentsAsync = ref.watch(sessionDetailProvider((sessionId: record.sessionId, fecha: apiDate)));

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.assignment_ind_rounded, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.subject, style: TextStyle(color: textColor, fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        if (!isMobile)
                          Row(
                            children: [
                              _MetaBadge(label: record.course, icon: Icons.group_work_rounded),
                              const SizedBox(width: 12),
                              _MetaBadge(label: record.date, icon: Icons.calendar_month_rounded),
                              const SizedBox(width: 12),
                              _MetaBadge(label: record.hour, icon: Icons.calendar_month_rounded),
                            ],
                          )
                        else ...[
                          Row(children: [_MetaBadge(label: record.course, icon: Icons.group_work_rounded)]),
                          const SizedBox(height: 4),
                          Row(children: [_MetaBadge(label: record.date, icon: Icons.calendar_month_rounded)]),
                          const SizedBox(height: 4),
                          Row(children: [_MetaBadge(label: record.hour, icon: Icons.calendar_month_rounded)]),
                        ]
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 32),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 16),
                    Text(l10n.attendanceDetailRegisteredBy, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        record.profesor ?? l10n.attendanceDetailSystemAuto,
                        style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isMobile ? 16 : 32),

              Row(
                children: [
                  _QuickStat(
                    label: l10n.attendanceDetailPresent,
                    value: (record.total - record.absent).toString(),
                    color: Colors.greenAccent,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(width: 20),
                  _QuickStat(
                    label: l10n.attendanceDetailAbsent,
                    value: record.absent.toString(),
                    color: Colors.redAccent,
                    icon: Icons.error_outline_rounded,
                  ),
                  const SizedBox(width: 20),
                  _QuickStat(
                    label: l10n.attendanceDetailAttendance,
                    value: '${(record.attendanceRatio * 100).toInt()}%',
                    color: AppColors.primary,
                    icon: Icons.analytics_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text(l10n.attendanceDetailStudentList, style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 16),
              const Divider(),

              Expanded(
                child: studentsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text('${l10n.errorGenerico}: $e', style: const TextStyle(color: Colors.red))),
                  data: (students) {
                    if (students.isEmpty) return Center(child: Text(l10n.attendanceDetailNoRecords));

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: students.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return _StudentRow(student: student, l10n: l10n);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _QuickStat({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900, height: 1)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final dynamic student;
  final AppLocalizations l10n;
  const _StudentRow({required this.student, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final String status = student['estado']?.toString().toUpperCase() ?? 'PENDIENTE';

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (status) {
      case 'PRESENTE':
        statusColor = Colors.greenAccent;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = l10n.attendanceDetailStatusPresente;
        break;
      case 'AUSENTE':
      case 'FALTA':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_rounded;
        statusLabel = l10n.attendanceDetailStatusAusente;
        break;
      case 'RETRASO':
        statusColor = Colors.orangeAccent;
        statusIcon = Icons.watch_later_rounded;
        statusLabel = l10n.attendanceDetailStatusRetraso;
        break;
      case 'JUSTIFICADO':
        statusColor = Colors.blueAccent;
        statusIcon = Icons.verified_user_rounded;
        statusLabel = l10n.attendanceDetailStatusJustificado;
        break;
      default:
        statusColor = AppColors.textMuted;
        statusIcon = Icons.help_outline_rounded;
        statusLabel = l10n.attendanceDetailStatusPendiente;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkSurface : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        children: [
          GaulaProfileImage(
            fotoUrl: student['alumnoAvatar'] ?? student['avatar'],
            nombre: student['alumnoNombre'] ?? l10n.attendanceDetailStudentFallback,
            radius: 20,
            isSquare: true,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(student['alumnoNombre'] ?? l10n.attendanceDetailStudentFallback, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 14),
                const SizedBox(width: 8),
                Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MetaBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
