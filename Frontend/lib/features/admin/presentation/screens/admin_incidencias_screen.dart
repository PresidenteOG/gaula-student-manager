import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/data/models/incidencia_model.dart';
import '../../../shared/providers/incidencia_provider.dart';
import '../../../../features/auth/application/providers/auth_provider.dart';
import '../../../admin/presentation/widgets/add_incidencia_dialog.dart';
import '../../../../shared/widgets/gaula_searchable_dropdown.dart';
import '../../application/providers/cursos_provider.dart';
import '../../application/providers/profesores_provider.dart';
import '../../application/providers/alumnos_provider.dart';
import '../widgets/gaula_pagination.dart';
import 'package:responsive_framework/responsive_framework.dart';

final _selectedIncidenciaProvider = StateProvider<IncidenciaModel?>((ref) => null);

class AdminIncidenciasScreen extends ConsumerStatefulWidget {
  const AdminIncidenciasScreen({super.key});

  @override
  ConsumerState<AdminIncidenciasScreen> createState() =>
      _AdminIncidenciasScreenState();
}

class _AdminIncidenciasScreenState
    extends ConsumerState<AdminIncidenciasScreen> {
  String _searchQuery = '';
  Timer? _debounce;

  void _showStatusUpdateDialog(BuildContext context, IncidenciaModel incident, WidgetRef widgetRef) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => Center(
        child: FadeInUp(
          duration: const Duration(milliseconds: 300),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 40)],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.actualizarEstado, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(l10n.etapaActualIncidencia, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                    const SizedBox(height: 32),
                    _statusSelectionCard(context, incident, 'ABIERTA', l10n.incidenciasAbiertaDesc, Icons.error_outline_rounded, Colors.redAccent, widgetRef),
                    const SizedBox(height: 12),
                    _statusSelectionCard(context, incident, 'EN_PROCESO', l10n.incidenciasEnProcesoDesc, Icons.hourglass_empty_rounded, Colors.amber, widgetRef),
                    const SizedBox(height: 12),
                    _statusSelectionCard(context, incident, 'CERRADA', l10n.incidenciasCerradaDesc, Icons.check_circle_outline_rounded, Colors.green, widgetRef, isClosure: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, IncidenciaModel incident, WidgetRef widgetRef) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => Center(
        child: ZoomIn(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDarkCard : Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 48),
                  ),
                  const SizedBox(height: 32),
                  Text(l10n.eliminarRegistro, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.incidenciaEliminadaDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancelar.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await widgetRef.read(incidenciaCrudProvider.notifier).eliminar(incident.id);
                            if (success && context.mounted) {
                              widgetRef.read(_selectedIncidenciaProvider.notifier).state = null;
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(l10n.eliminar.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String s) => switch (s.toLowerCase().replaceAll('_', '-')) {
        'abierta' || 'abierto' => const Color(0xFFEF4444),
        'en-proceso' => const Color(0xFFFBBF24),
        'cerrada' || 'cerrado' => const Color(0xFF34D399),
        _ => const Color(0xFF94A3B8),
      };

  Color _priorityColor(String p) => switch (p) {
        'alta' => const Color(0xFFEF4444),
        'media' => const Color(0xFFFBBF24),
        _ => const Color(0xFF60A5FA),
      };

  String _statusLabel(String s, [AppLocalizations? l10n]) {
    final result = switch (s.toLowerCase().replaceAll('_', '-')) {
      'abierta' || 'abierto' => l10n?.estadoAbierto ?? 'ABIERTO',
      'en-proceso' || 'en_proceso' => l10n?.estadoEnProceso ?? 'EN PROCESO',
      'cerrada' || 'cerrado' => l10n?.estadoCerrado ?? 'CERRADO',
      _ => s.toUpperCase(),
    };
    return result;
  }

  IconData _statusIcon(String s) => switch (s.toLowerCase().replaceAll('_', '-')) {
        'abierta' || 'abierto' => Icons.error_outline_rounded,
        'en-proceso' => Icons.hourglass_empty_rounded,
        'cerrada' || 'cerrado' => Icons.check_circle_outline_rounded,
        _ => Icons.help_outline_rounded,
      };

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(incidenciaListProvider);
    final cursosAsync = ref.watch(cursosListProvider);
    final alumnosAsync = ref.watch(alumnosListProvider);
    final profesoresAsync = ref.watch(profesoresListProvider);

    final usuario = ref.watch(usuarioActualProvider);
    final isStudent = usuario?.esAlumno ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Column(
            children: [
              // Sticky Header with Advanced Filters
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : 40),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.8),
                  border: Border(
                      bottom: BorderSide(
                          color: isDark
                              ? AppColors.border
                              : AppColors.borderLight)),
                ),
                child: Column(
                  children: [
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.incidenciasTitulo,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1)),
                              const SizedBox(height: 16),
                              if (!isStudent)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AddIncidenciaDialog(),
                                    ),
                                    icon: const Icon(Icons.add_alert_rounded,
                                        size: 20),
                                    label: Text(l10n.registrarIncidencia),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.incidenciasTitulo,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -1.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                      l10n.incidenciasTituloDesc,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              )),
                              const SizedBox(width: 16),
                              if (!isStudent)
                                ElevatedButton.icon(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AddIncidenciaDialog(),
                                  ),
                                  icon: const Icon(Icons.add_alert_rounded,
                                      size: 20),
                                  label: Text(l10n.registrarIncidencia),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 24),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                  ),
                                ),
                            ],
                          ),
                    const SizedBox(height: 40),
                    // Advanced Filters Row
                    isMobile
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildStatusFilter(isDark, ref),
                                const SizedBox(width: 8),
                                if (ref.watch(incidenciaFiltroStatusProvider) ==
                                    'cerrada')
                                  _buildResolutionFilter(isDark, ref),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              _buildStatusFilter(isDark, ref),
                              const SizedBox(width: 16),
                              if (ref.watch(incidenciaFiltroStatusProvider) ==
                                  'cerrada')
                                _buildResolutionFilter(isDark, ref),
                              if (ref.watch(incidenciaFiltroStatusProvider) ==
                                  'cerrada')
                                const SizedBox(width: 16),
                              Expanded(
                                child: cursosAsync.maybeWhen(
                                  data: (cursos) => GaulaSearchableDropdown<int?>(
                                    initialValue: ref.watch(incidenciaFiltroCursoProvider),
                                    items: [null, ...cursos.map((c) => c.id)],
                                    label: l10n.filtreCurs,
                                    hint: l10n.filtrarPorCurso,
                                    itemLabel: (id) => id == null
                                        ? l10n.todosCursos
                                        : cursos
                                            .firstWhere((c) => c.id == id)
                                            .codigoGrupo,
                                    onChanged: (val) {
                                      ref
                                          .read(
                                              incidenciaFiltroCursoProvider.notifier)
                                          .state = val;
                                    },
                                  ),
                                  orElse: () => const SizedBox.shrink(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: alumnosAsync.maybeWhen(
                                  data: (pagRes) => GaulaSearchableDropdown<int?>(
                                    initialValue: ref.watch(incidenciaFiltroAlumnoProvider),
                                    items: [null, ...pagRes.content.map((a) => a.id)],
                                    label: l10n.filtreAlumne,
                                    hint: l10n.filtrarPorAlumno,
                                    itemLabel: (id) => id == null
                                        ? l10n.todosAlumnos
                                        : pagRes.content
                                            .firstWhere((a) => a.id == id)
                                            .nombreCompleto,
                                    onChanged: (val) {
                                      ref
                                          .read(
                                              incidenciaFiltroAlumnoProvider.notifier)
                                          .state = val;
                                    },
                                  ),
                                  orElse: () => const SizedBox.shrink(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: profesoresAsync.maybeWhen(
                                  data: (pagRes) => GaulaSearchableDropdown<int?>(
                                    initialValue:
                                        ref.watch(incidenciaFiltroProfesorProvider),
                                    items: [null, ...pagRes.content.map((p) => p.id)],
                                    label: l10n.filtreProfessor,
                                    hint: l10n.filtrarPorProfesor,
                                    itemLabel: (id) => id == null
                                        ? l10n.todosProfesores
                                        : pagRes.content
                                            .firstWhere((p) => p.id == id)
                                            .nombreCompleto,
                                    onChanged: (val) {
                                      ref
                                          .read(incidenciaFiltroProfesorProvider
                                              .notifier)
                                          .state = val;
                                    },
                                  ),
                                  orElse: () => const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                    if (isMobile) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: cursosAsync.maybeWhen(
                              data: (cursos) => GaulaSearchableDropdown<int?>(
                                initialValue: ref.watch(incidenciaFiltroCursoProvider),
                                items: [null, ...cursos.map((c) => c.id)],
                                label: l10n.filtreCurs,
                                hint: l10n.filtrarPorCurso,
                                itemLabel: (id) => id == null
                                    ? l10n.todos
                                    : cursos
                                        .firstWhere((c) => c.id == id)
                                        .codigoGrupo,
                                onChanged: (val) {
                                  ref
                                      .read(incidenciaFiltroCursoProvider.notifier)
                                      .state = val;
                                },
                              ),
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: alumnosAsync.maybeWhen(
                              data: (pagRes) => GaulaSearchableDropdown<int?>(
                                initialValue: ref.watch(incidenciaFiltroAlumnoProvider),
                                items: [null, ...pagRes.content.map((a) => a.id)],
                                label: l10n.filtreAlumne,
                                hint: l10n.filtrarPorAlumno,
                                itemLabel: (id) => id == null
                                    ? l10n.todos
                                    : pagRes.content
                                        .firstWhere((a) => a.id == id)
                                        .nombreCompleto,
                                onChanged: (val) {
                                  ref
                                      .read(incidenciaFiltroAlumnoProvider.notifier)
                                      .state = val;
                                },
                              ),
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDarkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? AppColors.border
                                : AppColors.borderLight),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 300), () {
                            setState(() => _searchQuery = val);
                          });
                        },
                        style: TextStyle(color: textColor, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).buscarPorTituloDesc,
                          hintStyle: const TextStyle(color: AppColors.textSecondary),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.textSecondary, size: 24),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: listAsync.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(
                      child: Text('${AppLocalizations.of(context).errorGenerico}: $e',
                          style: const TextStyle(color: Colors.red))),
                  data: (paginatedResponse) {
                    final filtered = paginatedResponse.content.where((i) {
                      final query = _searchQuery.toLowerCase();
                      return i.titulo.toLowerCase().contains(query) ||
                             i.descripcion.toLowerCase().contains(query) ||
                             i.alumnoNombre.toLowerCase().contains(query);
                    }).toList();

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              if (ref.watch(incidenciaFiltroCursoProvider) !=
                                      null &&
                                  filtered.isNotEmpty)
                                _buildCourseSummary(filtered, isDark),

                              Expanded(
                                child: filtered.isEmpty
                                    ? _buildEmptyState(isDark)
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              padding: EdgeInsets.all(isMobile ? 16 : 40),
                                              itemCount: filtered.length,
                                              itemBuilder: (context, index) {
                                                final incident =
                                                    filtered[index];
                                                return FadeInUp(
                                                  delay: Duration(
                                                      milliseconds: 50 * index),
                                                  child: _IncidentListItem(
                                                    incident: incident,
                                                    onTap: () => _showDetailDialog(incident, isDark, isStudent, usuario?.esAdmin ?? false, isMobile, ref),
                                                    isDark: isDark,
                                                    statusColor: _statusColor,
                                                    statusIcon: _statusIcon,
                                                    statusLabel: (s) => _statusLabel(s, l10n),
                                                    priorityColor:
                                                        _priorityColor,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          GaulaPagination(
                                            currentPage: ref
                                                .watch(incidenciaPageProvider),
                                            totalPages:
                                                paginatedResponse.totalPages,
                                            onPageChanged: (newPage) {
                                              ref
                                                  .read(incidenciaPageProvider
                                                      .notifier)
                                                  .state = newPage;
                                            },
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildStatusFilter(bool isDark, WidgetRef ref) {
    final currentStatus = ref.watch(incidenciaFiltroStatusProvider);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['todas', 'abierta', 'en_proceso', 'cerrada'].map((s) {
          final active = currentStatus == s;
          return GestureDetector(
            onTap: () {
              ref.read(incidenciaFiltroStatusProvider.notifier).state = s;
              if (s != 'cerrada') {
                ref.read(incidenciaFiltroResolucionProvider.notifier).state = 'todas';
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10)
                      ]
                    : null,
              ),
              child: Text(
                switch (s) {
                  'todas' => l10n.tabTotes,
                  'abierta' => l10n.tabObert,
                  'en_proceso' => l10n.tabEnProces,
                  'cerrada' => l10n.tabTancat,
                  _ => s.toUpperCase(),
                },
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResolutionFilter(bool isDark, WidgetRef ref) {
    final currentRes = ref.watch(incidenciaFiltroResolucionProvider);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['todas', 'valida', 'invalida'].map((s) {
          final active = currentRes == s;
          return GestureDetector(
            onTap: () {
              ref.read(incidenciaFiltroResolucionProvider.notifier).state = s;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                switch (s) {
                  'todas' => l10n.tabTotes,
                  'valida' => l10n.resValida,
                  'invalida' => l10n.resInvalida,
                  _ => s.toUpperCase(),
                },
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCourseSummary(List<IncidenciaModel> filtered, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final Map<String, int> counts = {};
    for (var i in filtered) {
      counts[i.alumnoNombre] = (counts[i.alumnoNombre] ?? 0) + 1;
    }
    final sortedStudents = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return FadeInDown(
      child: Container(
        margin: const EdgeInsets.fromLTRB(40, 40, 40, 0),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.primary.withValues(alpha: 0.2),
                    Colors.purple.withValues(alpha: 0.1)
                  ]
                : [
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.purple.withValues(alpha: 0.05)
                  ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart_rounded,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 16),
                Text(l10n.topAlumnesIncidencies,
                    style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const Spacer(),
                Text('${filtered.length} ${l10n.alertesTotals}',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sortedStudents
                    .take(8)
                    .map((e) => Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black26 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey[200]!),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.02),
                                        blurRadius: 10)
                                  ],
                          ),
                          child: Column(
                            children: [
                              Text(e.key.split(' ')[0],
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : AppColors.textDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text('${e.value}',
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_rounded,
                size: 100, color: Colors.green.withValues(alpha: 0.1)),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context).noHayIncidencias,
                style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(AppLocalizations.of(context).incidenciasSistemaLimpio,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(IncidenciaModel selected, bool isDark,
      bool isStudent, bool isAdmin, bool isMobile, WidgetRef ref) {
    ref.read(_selectedIncidenciaProvider.notifier).state = selected;
    final l10nPanel = AppLocalizations.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => Consumer(
        builder: (context, ref, child) {
          final incident = ref.watch(_selectedIncidenciaProvider);
          if (incident == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
            return const SizedBox.shrink();
          }

          final isClosed = incident.estado.toLowerCase().replaceAll('_', '-') == 'cerrada';
          final resolutionColor = incident.resolucion == 'VALIDA' ? Colors.green : Colors.redAccent;

          return Center(
            child: FadeInRight(
              child: Container(
                width: isMobile ? MediaQuery.of(context).size.width : 480,
                margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                  borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(32),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1), blurRadius: 60, offset: const Offset(0, 30)),
                    if (isClosed && incident.resolucion != null)
                      BoxShadow(color: resolutionColor.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _statusColor(incident.estado).withValues(alpha: 0.9),
                                _statusColor(incident.estado).withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _statusLabel(incident.estado, l10nPanel).toUpperCase(),
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                    ),
                                  ),
                                  if (isClosed && incident.resolucion != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: resolutionColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(incident.resolucion == 'VALIDA' ? Icons.verified : Icons.error, color: Colors.white, size: 14),
                                          const SizedBox(width: 8),
                                          Text(
                                            incident.resolucion!.toUpperCase(),
                                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Text(incident.titulo, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2, height: 1.1)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.event_note_rounded, color: Colors.white70, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('EEEE, d MMMM yyyy', AppLocalizations.of(context).localeName).format(DateTime.parse(incident.fechaIncidencia)).toUpperCase(),
                                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(32),
                            children: [
                              _detailSectionCard(l10nPanel.incidenciasDescripcionHechos, incident.descripcion, Icons.notes_rounded, isDark),
                              const SizedBox(height: 24),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.6,
                                children: [
                                  _detailSectionCard(l10nPanel.incidenciasAlumnoLabel, incident.alumnoNombre, Icons.face_retouching_natural_rounded, isDark),
                                  _detailSectionCard(l10nPanel.incidenciasCursoGrupo, incident.cursoCodigo ?? 'N/A', Icons.school_rounded, isDark),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _detailSectionCard(l10nPanel.incidenciasProfesorResponsable, incident.profesorNombre, Icons.badge_rounded, isDark),
                            ],
                          ),
                        ),
                        if (!isStudent)
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
                              border: Border(top: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight)),
                            ),
                            child: Column(
                              children: [
                                _actionButton(
                                  label: 'ACTUALIZAR ESTADO',
                                  icon: Icons.published_with_changes_rounded,
                                  color: AppColors.primary,
                                  onPressed: () => _showStatusUpdateDialog(context, incident, ref),
                                ),
                                if (isAdmin) ...[
                                  const SizedBox(height: 12),
                                  _actionButton(
                                    label: 'ELIMINAR REGISTRO',
                                    icon: Icons.delete_sweep_rounded,
                                    color: Colors.redAccent.withValues(alpha: 0.1),
                                    textColor: Colors.redAccent,
                                    isOutlined: true,
                                    onPressed: () => _showDeleteConfirmation(context, incident, ref),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailSectionCard(String label, String value, IconData icon, bool isDark, {Color? accentColor}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor ?? AppColors.primary),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: accentColor ?? (isDark ? Colors.white : AppColors.textDark), fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon, required Color color, Color? textColor, bool isOutlined = false, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : color,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isOutlined ? BorderSide(color: textColor ?? color) : BorderSide.none,
          ),
          elevation: 0,
        ),
      ),
    );
  }


  Widget _statusSelectionCard(BuildContext context, IncidenciaModel incident, String label, String subtitle, IconData icon, Color color, WidgetRef ref, {bool isClosure = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = incident.estado.toUpperCase() == label.replaceFirst('_', '-');

    return InkWell(
      onTap: () async {
        if (isClosure) {
          final resolucion = await _showResolutionDialog(context);
          if (resolucion != null) {
            final success = await ref.read(incidenciaCrudProvider.notifier).updateEstado(incident.id, 'CERRADA', resolucion: resolucion);
            if (success) {
              ref.read(_selectedIncidenciaProvider.notifier).update((state) => state?.copyWith(estado: 'CERRADA', resolucion: () => resolucion));
            }
            if (context.mounted) Navigator.pop(context);
          }
        } else {
          final success = await ref.read(incidenciaCrudProvider.notifier).updateEstado(incident.id, label);
          if (success) {
            ref.read(_selectedIncidenciaProvider.notifier).update((state) => state?.copyWith(estado: label, resolucion: () => null));
          }
          if (context.mounted) Navigator.pop(context);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.replaceFirst('_', ' '), style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }

  Future<String?> _showResolutionDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) => Center(
        child: ZoomIn(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 480,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDarkCard : Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 48),
                  ),
                  const SizedBox(height: 32),
                  Text(AppLocalizations.of(context).resolucionIncidencia, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Builder(builder: (ctx) => Text(
                    AppLocalizations.of(ctx).incidenciaConfirmacioText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.5),
                  )),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, 'INVALIDA'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('ES INVÁLIDA', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'VALIDA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Builder(builder: (ctx) => Text(AppLocalizations.of(ctx).incidenciasEsValida, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ),  // ConstrainedBox
        ),
      ),
    );
  }

}

class _IncidentListItem extends StatelessWidget {
  final IncidenciaModel incident;
  final VoidCallback onTap;
  final bool isDark;
  final Function statusColor;
  final Function statusIcon;
  final Function statusLabel;
  final Function priorityColor;

  const _IncidentListItem({
    required this.incident,
    required this.onTap,
    required this.isDark,
    required this.statusColor,
    required this.statusIcon,
    required this.statusLabel,
    required this.priorityColor,
  });

  String _gravedadLabel(String g, AppLocalizations l10n) => switch (g) {
    'LEVE' => l10n.incidenciaSeveridadLeve,
    'GRAVE' => l10n.incidenciaSeveridadGrave,
    'MUY_GRAVE' => l10n.incidenciaSeveridadMuyGrave,
    _ => g,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final color = statusColor(incident.estado.toLowerCase());

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: isDark ? AppColors.border : AppColors.borderLight,
                width: 1.5),
            boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5))
                      ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(statusIcon(incident.estado.toLowerCase()),
                    color: color, size: 28),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(incident.titulo,
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: -0.5),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                        const SizedBox(width: 12),
                        _PriorityBadge(
                            label: _gravedadLabel(incident.gravedad, l10n),
                            color:
                                priorityColor(incident.gravedad.toLowerCase())),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: Text(incident.alumnoNombre,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                        const SizedBox(width: 10),
                        Text('•',
                            style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(incident.cursoCodigo ?? AppLocalizations.of(context).incidenciaPendiente,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (incident.estado.toLowerCase().replaceAll('_', '-') == 'cerrada' && incident.resolucion != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (incident.resolucion == 'VALIDA' ? Colors.green : Colors.redAccent).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            incident.resolucion == 'VALIDA' ? AppLocalizations.of(context).resValida : AppLocalizations.of(context).resInvalida,
                            style: TextStyle(
                              color: incident.resolucion == 'VALIDA' ? Colors.green : Colors.redAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      _StatusBadge(
                          label: statusLabel(incident.estado.toLowerCase()),
                          color: color),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                      DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(incident.fechaIncidencia)),
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(label.toUpperCase(),
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5)),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PriorityBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(label.toUpperCase(),
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 9,
              letterSpacing: 1)),
    );
  }
}








