import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../shared/models/curso_model.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

class CourseGrid extends StatelessWidget {
  final Map<String, List<CursoModel>> groupedCursos;
  final bool esAdmin;
  final Function(String) onTap;
  final Function(String)? onAddGroup;

  const CourseGrid({
    super.key,
    required this.groupedCursos,
    required this.esAdmin,
    required this.onTap,
    this.onAddGroup,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(isMobile ? 20 : 40),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
          crossAxisSpacing: isMobile ? 16 : 32,
          mainAxisSpacing: isMobile ? 16 : 32,
          // Taller ratio: prevents bottom overflow when group chips fill the card
          childAspectRatio: isMobile ? 1.4 : 0.75,
        ),
        itemCount: groupedCursos.length,
        itemBuilder: (context, index) {
          final cycleCode = groupedCursos.keys.elementAt(index);
          final cycleCursos = groupedCursos[cycleCode]!;

          Color cardColor = AppColors.primary;
          if (cycleCursos.isNotEmpty &&
              cycleCursos.first.colorCiclo.startsWith('#')) {
            final hex = cycleCursos.first.colorCiclo.replaceFirst('#', '');
            if (hex.length == 6) {
              cardColor = Color(int.parse('FF$hex', radix: 16));
            }
          }

          return FadeInUp(
            delay: Duration(milliseconds: 50 * index),
            child: CourseCard(
              cycleCode: cycleCode,
              cursos: cycleCursos,
              color: cardColor,
              onTap: () => onTap(cycleCode),
              onAddGroup: onAddGroup != null ? () => onAddGroup!(cycleCode) : null,
            ),
          );
        },
      ),
    );
  }
}

class HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isPrimary;
  final VoidCallback? onTap;

  const HeaderButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnColor =
        isPrimary ? color : (isDark ? color : AppColors.backgroundLightSurface);
    final contentColor = isPrimary
        ? Colors.white
        : (isDark ? AppColors.textPrimary : AppColors.primary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: label.isEmpty ? 12 : 20, vertical: 12),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark ? Colors.transparent : AppColors.borderLight),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: contentColor, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: contentColor, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }
}

class CourseCard extends ConsumerWidget {
  final String cycleCode;
  final List<CursoModel> cursos;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onAddGroup;

  const CourseCard({
    super.key,
    required this.cycleCode,
    required this.cursos,
    required this.color,
    this.onTap,
    this.onAddGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, String> subnames = {
      'DAM': 'Desarrollo de Aplicaciones Multiplataforma',
      'DAW': 'Desarrollo de Aplicaciones Web',
      'ASIX': 'Administración de Sistemas Informáticos en Red',
      'SMIX': 'Sistemas Microinformáticos y Redes',
    };
    final String subname = subnames[cycleCode] ?? cycleCode;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10)
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FittedBox: scales down long codes (ASIX, SMIX) inside fixed 60px badge
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        cycleCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (onAddGroup != null &&
                        (ref.watch(usuarioActualProvider)?.esAdmin ?? false))
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.primary, size: 24),
                        tooltip: AppLocalizations.of(context).anadirCursoModalidad,
                        onPressed: onAddGroup,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(cycleCode,
                style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subname,
                style: TextStyle(
                    color:
                        isDark ? AppColors.textSecondary : AppColors.textMuted,
                    fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(
              '${cursos.length} ${cursos.length == 1 ? 'curso' : 'cursos'}',
              style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textMuted,
                  fontSize: 14),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: cursos.map((curso) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDarkSurface
                            : AppColors.backgroundLightSurface,
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        curso.codigoGrupo,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

