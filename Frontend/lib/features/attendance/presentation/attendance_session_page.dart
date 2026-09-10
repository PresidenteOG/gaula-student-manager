import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../application/attendance_providers.dart';
import '../domain/value_objects/attendance_status.dart';
import '../domain/entities/attendance_student.dart';
import '../../../l10n/app_localizations.dart';

class AttendanceSessionPage extends ConsumerStatefulWidget {
  final String sessionId;
  const AttendanceSessionPage({super.key, required this.sessionId});

  @override
  ConsumerState<AttendanceSessionPage> createState() => _AttendanceSessionPageState();
}

class _AttendanceSessionPageState extends ConsumerState<AttendanceSessionPage> {
  AttendanceStudent? _enlargedStudent;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final state = ref.watch(attendanceSessionNotifierProvider(widget.sessionId));
    final notifier = ref.read(attendanceSessionNotifierProvider(widget.sessionId).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              _buildPageHeader(context, state, notifier, textColor, isDark, l10n),

              // Class Info
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: _ClassInfoCard(session: state.session),
              ),

              // Content
              Expanded(
                child: state.isOneByOne
                    ? _buildOneByOne(state, notifier, textColor, isDark, l10n)
                    : _buildClasico(state, notifier, textColor, isDark),
              ),
            ],
          ),

          // Floating Save FAB
          Positioned(
            bottom: 24,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state.canSave ? 1.0 : 0.45,
              child: ElevatedButton.icon(
                onPressed: state.canSave
                    ? () async {
                        final ok = await notifier.saveAttendance();
                        if (!context.mounted) return;
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text(l10n.guardar)]),
                              backgroundColor: const Color(0xFF22C55E),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          context.pop();
                        }
                      }
                    : null,
                icon: state.isSaving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_rounded, size: 22),
                label: Text(
                  state.isSaving ? l10n.loading : l10n.guardar,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.accentForeground,
                  disabledBackgroundColor: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
                  disabledForegroundColor: isDark ? AppColors.textMuted : AppColors.textMuted,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 8,
                ),
              ),
            ),
          ),

          // Photo Modal
          if (_enlargedStudent != null) _buildPhotoModal(textColor, isDark),
        ],
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, dynamic state, dynamic notifier, Color textColor, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: back button + title — wrapped in Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back button — fixed min-size, won't expand
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.textSecondary : AppColors.textMuted, size: 18),
                      const SizedBox(width: 4),
                      Text(l10n.volverMisClases, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Title — Flexible so it ellipsizes before stealing space from mode buttons
                Flexible(
                  child: Text(
                    '${l10n.asistenciaPasarLista}: ${state.session?.subject ?? ""}',
                    style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Mode toggle — intrinsic size, never squeezed
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModeButton(
                  label: l10n.modoUnoEnUno,
                  icon: Icons.person_rounded,
                  isActive: state.isOneByOne,
                  onTap: () => notifier.setMode(isOneByOne: true),
                ),
                _ModeButton(
                  label: l10n.modoClasico,
                  icon: Icons.grid_view_rounded,
                  isActive: !state.isOneByOne,
                  onTap: () => notifier.setMode(isOneByOne: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClasico(dynamic state, dynamic notifier, Color textColor, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth >= 1280) {
          columns = 4;
        } else if (constraints.maxWidth >= 1024) {
          columns = 3;
        } else if (constraints.maxWidth >= 640) {
          columns = 2;
        }

        final gridWidth = constraints.maxWidth - 48;
        final cardWidth = (gridWidth - (columns - 1) * 16) / columns;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(state.students.length, (index) {
              final alumno = state.students[index];
              return SizedBox(
                width: cardWidth,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  delay: Duration(milliseconds: 40 * index),
                  child: _StudentAttendanceCard(
                    alumno: alumno,
                    onStatusChanged: (status) => notifier.recordStatus(alumno.id, status, alumno.attendanceId),
                    onAvatarTap: () => setState(() => _enlargedStudent = alumno),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildOneByOne(dynamic state, dynamic notifier, Color textColor, bool isDark, AppLocalizations l10n) {
    final alumno = state.currentStudent;
    if (alumno == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: FadeInRight(
        key: ValueKey(state.currentIndex),
        duration: const Duration(milliseconds: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05), blurRadius: 40, offset: const Offset(0, 20))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _enlargedStudent = alumno),
                    child: _GradientAvatar(
                      size: 192,
                      avatarUrl: alumno.avatar.isNotEmpty ? alumno.avatar : null,
                      child: const _SilhouetteIcon(size: 100),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    alumno.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.asistenciaAlumnoIndex(state.currentIndex + 1, state.students.length),
                    style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.8,
                    children: AttendanceStatus.values.map((status) {
                      final isActive = alumno.status == status;
                      return _StatusButton(
                        label: status.localizedLabel(l10n),
                        activeColor: status.activeColor,
                        isActive: isActive,
                        large: true,
                        onTap: () => notifier.recordStatus(alumno.id, status, alumno.attendanceId),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: state.currentIndex > 0 ? () => notifier.setCurrentIndex(state.currentIndex - 1) : null,
                        icon: const Icon(Icons.chevron_left_rounded),
                        label: Text(l10n.volver),
                        style: TextButton.styleFrom(foregroundColor: isDark ? AppColors.textSecondary : AppColors.textMuted),
                      ),
                      TextButton.icon(
                        onPressed: state.currentIndex < state.students.length - 1 ? () => notifier.setCurrentIndex(state.currentIndex + 1) : null,
                        label: Text(l10n.siguienteLabel),
                        icon: const Icon(Icons.chevron_right_rounded),
                        style: TextButton.styleFrom(foregroundColor: isDark ? AppColors.textSecondary : AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoModal(Color textColor, bool isDark) {
    final student = _enlargedStudent!;
    return GestureDetector(
      onTap: () => setState(() => _enlargedStudent = null),
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 60)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GradientAvatar(
                        size: 280,
                        avatarUrl: student.avatar.isNotEmpty ? student.avatar : null,
                        child: const _SilhouetteIcon(size: 160),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        student.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -16, right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() => _enlargedStudent = null),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                      ),
                      child: Icon(Icons.close, color: textColor, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Supporting Widgets ---

class _GradientAvatar extends StatelessWidget {
  final double size;
  final Widget child;
  /// URL relativa de la imagen del alumno (sin el base URL).
  /// Si es null o vacía, se muestra el widget [child] (silueta) como fallback.
  final String? avatarUrl;

  const _GradientAvatar({
    required this.size,
    required this.child,
    this.avatarUrl,
  });

  bool get _hasRealAvatar {
    if (avatarUrl == null || avatarUrl!.isEmpty) return false;
    // Los emojis son cortos y no contienen '.'
    if (avatarUrl!.length < 10 && !avatarUrl!.contains('.')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size, height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
          shape: BoxShape.circle,
        ),
        child: _hasRealAvatar
            ? Image.network(
                '${ApiConstants.uploadsBaseUrl}$avatarUrl',
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (_, __, ___) => Center(child: child),
                loadingBuilder: (context, widget, loadingProgress) {
                  if (loadingProgress == null) return widget;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  );
                },
              )
            : Center(child: child),
      ),
    );
  }
}

class _SilhouetteIcon extends StatelessWidget {
  final double size;
  const _SilhouetteIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(Icons.person_rounded, size: size, color: isDark ? AppColors.textMuted : AppColors.textMuted.withValues(alpha: 0.5));
  }
}

class _StudentAttendanceCard extends StatelessWidget {
  final AttendanceStudent alumno;
  final Function(AttendanceStatus) onStatusChanged;
  final VoidCallback onAvatarTap;

  const _StudentAttendanceCard({
    required this.alumno,
    required this.onStatusChanged,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    final statusColor = alumno.status;
    final cardBg = statusColor?.cardBackground(isDark)
        ?? (isDark ? AppColors.backgroundDarkCard : Colors.white);
    final cardBorder = statusColor?.cardBorderColor(isDark)
        ?? (isDark ? AppColors.border : AppColors.borderLight);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardBorder,
          width: statusColor != null && statusColor != AttendanceStatus.presente ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Column(
              children: [
                _GradientAvatar(
                  size: 96,
                  avatarUrl: alumno.avatar.isNotEmpty ? alumno.avatar : null,
                  child: const _SilhouetteIcon(size: 54),
                ),
                const SizedBox(height: 10),
                Text(
                  alumno.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            childAspectRatio: 2.5,
            children: AttendanceStatus.values.map((status) {
              final isActive = alumno.status == status;
              return _StatusButton(
                label: status.label,
                activeColor: status.activeColor,
                isActive: isActive,
                large: false,
                onTap: () => onStatusChanged(status),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color activeColor;
  final bool isActive;
  final bool large;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.activeColor,
    required this.isActive,
    required this.large,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? activeColor : (isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? activeColor : (isDark ? AppColors.border : AppColors.borderLight), width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              // Colors.white on activeColor background = CORRECT (colored container)
              color: isActive ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.textMuted),
              fontSize: large ? 15 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ClassInfoCard extends StatelessWidget {
  final dynamic session;
  const _ClassInfoCard({required this.session});

  @override
  Widget build(BuildContext context) {
    if (session == null) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);
    final dateStr = l10n.localeName == 'en'
        ? DateFormat('MMMM d, y', 'en').format(session.date)
        : DateFormat("d 'de' MMMM, y", l10n.localeName).format(session.date);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              dateStr,
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          _InfoChip(label: l10n.asistenciaHoraLabel, value: session.time),
          const SizedBox(width: 16),
          Flexible(child: _InfoChip(label: l10n.materia, value: session.subject)),
          const SizedBox(width: 16),
          Flexible(child: _InfoChip(label: l10n.asistenciaCursoLabel, value: session.course)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  const _ModeButton({required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colors.white on AppColors.primary background = CORRECT (colored container)
            Icon(icon, size: 18, color: isActive ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.textMuted)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isActive ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.textMuted), fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
