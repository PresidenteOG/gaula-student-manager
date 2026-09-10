import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';

final teacherHistorialProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final usuario = ref.watch(usuarioActualProvider);
  if (usuario?.id == null) return [];
  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(ApiConstants.historialClasesProfesor(usuario!.id));
    return res.data as List<dynamic>;
  } catch (_) {
    return [];
  }
});

class TeacherHistorialScreen extends ConsumerWidget {
  const TeacherHistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final historialAsync = ref.watch(teacherHistorialProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).size.width < 600
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
            : const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.historialTitulo,
                        style: TextStyle(color: textColor, fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.historialSubtitulo,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                historialAsync.when(
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(64),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )),
                  error: (e, _) => Center(child: Text('${l10n.errorGenerico}: $e', style: const TextStyle(color: Colors.red))),
                  data: (clases) {
                    if (clases.isEmpty) return _EmptyState();

                    return Column(
                      children: clases.asMap().entries.map((entry) {
                        final index = entry.key;
                        final clase = entry.value;
                        return FadeInUp(
                          delay: Duration(milliseconds: 50 * index),
                          child: _SessionCard(clase: clase, isDark: isDark),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final dynamic clase;
  final bool isDark;

  const _SessionCard({required this.clase, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fecha = clase['fecha'] ?? '';
    final presentes = clase['presentes'] ?? 0;
    final ausentes = clase['ausentes'] ?? 0;
    final retrasos = clase['retrasos'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed('teacher-asistencia',
            pathParameters: {'sessionId': clase['sesionId'].toString()},
            queryParameters: {'fecha': fecha},
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 480;
            final dateBox = Container(
              width: isMobile ? 72 : 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    fecha.split('-').last,
                    style: TextStyle(color: AppColors.primary, fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getMes(fecha, AppLocalizations.of(context).localeName),
                    style: TextStyle(color: AppColors.primary, fontSize: isMobile ? 10 : 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
            final infoCol = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clase['materiaNombre'] ?? 'Materia',
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${clase['codigoGrupo']} • ${clase['horaInicio']} - ${clase['horaFin']}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        _StatMini(label: l10n.statPresentes, value: presentes, color: const Color(0xFF34D399)),
                        _StatMini(label: l10n.statAusentes, value: ausentes, color: const Color(0xFFEF4444)),
                        _StatMini(label: l10n.statRetrasos, value: retrasos, color: const Color(0xFFFBBF24)),
                      ],
                    ),
                  ],
                ],
              ),
            );
            return Row(
              children: [
                dateBox,
                const SizedBox(width: 16),
                infoCol,
                if (!isMobile) ...[
                  _StatMini(label: l10n.statPresentes, value: presentes, color: const Color(0xFF34D399)),
                  _StatMini(label: l10n.statAusentes, value: ausentes, color: const Color(0xFFEF4444)),
                  _StatMini(label: l10n.statRetrasos, value: retrasos, color: const Color(0xFFFBBF24)),
                  const SizedBox(width: 16),
                ],
                Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white24 : Colors.black26, size: 14),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _getMes(String fecha, [String locale = 'es_ES']) {
    try {
      final dt = DateTime.parse(fecha);
      return DateFormat('MMM', locale).format(dt).toUpperCase();
    } catch (_) {
      return '';
    }
  }
}

class _StatMini extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatMini({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(value.toString(), style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(64),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(Icons.history, color: AppColors.textSecondary, size: 64),
          const SizedBox(height: 16),
          Text(
            l10n.historialVacio,
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sinDatos,
            style: const TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


