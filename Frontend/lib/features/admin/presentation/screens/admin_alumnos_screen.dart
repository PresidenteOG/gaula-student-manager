import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/add_alumno_dialog.dart';
import '../widgets/gaula_pagination.dart';
import '../../application/providers/alumnos_provider.dart';
import '../../application/providers/cursos_provider.dart';
import '../../domain/entities/alumno_model.dart';
import '../../../shared/models/curso_model.dart';
import '../../../../shared/widgets/gaula_profile_image.dart';
import '../../../../shared/widgets/gaula_searchable_dropdown.dart';
import 'package:responsive_framework/responsive_framework.dart';

final _alumnoResumenProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, alumnoId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(
      ApiConstants.asistenciaResumenAlumno(alumnoId),
      options: Options(sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),
    );
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    // 500 = backend error (e.g. alumno without modalidad set).
    // Return a safe empty resumen so the card renders in degraded mode.
    if (e.response?.statusCode == 500 || e.response?.statusCode == 404) {
      return {
        'alumnoId': alumnoId,
        'porcentajeAsistencia': 0.0,
        'totalClases': 0,
        'presentes': 0,
        'ausentes': 0,
        'retrasos': 0,
        'justificados': 0,
        'horasFaltadas': 0.0,
        'modulos': <dynamic>[],
        '_error': 'HTTP ${e.response?.statusCode}',
      };
    }
    rethrow;
  }
});

class AdminAlumnosScreen extends ConsumerStatefulWidget {
  const AdminAlumnosScreen({super.key});

  @override
  ConsumerState<AdminAlumnosScreen> createState() => _AdminAlumnosScreenState();
}

class _AdminAlumnosScreenState extends ConsumerState<AdminAlumnosScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _resetPage() {
    ref.read(alumnosPageProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(alumnosListProvider);
    final cursosAsync = ref.watch(cursosListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    final cursoFiltro = ref.watch(alumnosCursoFiltroProvider);
    final currentPage = ref.watch(alumnosPageProvider);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              // Sticky Header
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
                              Text(l10n.alumnosTitulo,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1)),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => const AddAlumnoDialog(),
                                  ),
                                  icon: const Icon(Icons.person_add_alt_1_rounded,
                                      size: 20),
                                  label: Text(l10n.matricularAlumno),
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
                                    Text(l10n.alumnosTitulo,
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                        l10n.alumnosTituloDesc,
                                        style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              ElevatedButton.icon(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => const AddAlumnoDialog(),
                                ),
                                icon: const Icon(Icons.person_add_alt_1_rounded,
                                    size: 20),
                                label: Text(l10n.matricularAlumno),
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
                    const SizedBox(height: 32),
                    // Search & Filters Bar
                    isMobile
                        ? Column(
                            children: [
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
                                  controller: _searchCtrl,
                                  onChanged: (val) {
                                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                                    _debounce = Timer(const Duration(milliseconds: 500), () {
                                      ref.read(alumnosBusquedaProvider.notifier).state = val;
                                      _resetPage();
                                    });
                                  },
                                  style: TextStyle(color: textColor, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: l10n.buscarProfesoresHint,
                                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                                    prefixIcon: const Icon(Icons.search_rounded,
                                        color: AppColors.textSecondary, size: 24),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              cursosAsync.maybeWhen(
                                data: (cursos) =>
                                    GaulaSearchableDropdown<CursoModel?>(
                                  initialValue: cursos
                                      .where((c) => c.id == cursoFiltro)
                                      .firstOrNull,
                                  items: [null, ...cursos],
                                  label: l10n.alumnoCurso,
                                  hint: l10n.todosCursos,
                                  itemLabel: (c) => c == null
                                      ? l10n.todosCursos
                                      : c.codigoGrupo,
                                  onChanged: (val) {
                                    ref
                                        .read(alumnosCursoFiltroProvider.notifier)
                                        .state = val?.id;
                                    _resetPage();
                                  },
                                ),
                                orElse: () => const SizedBox.shrink(),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
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
                                    controller: _searchCtrl,
                                    onChanged: (val) {
                                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                                      _debounce = Timer(const Duration(milliseconds: 500), () {
                                        ref.read(alumnosBusquedaProvider.notifier).state = val;
                                        _resetPage();
                                      });
                                    },
                                    style: TextStyle(color: textColor, fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: l10n.buscarAlumnos,
                                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                                      prefixIcon: const Icon(Icons.search_rounded,
                                          color: AppColors.textSecondary, size: 24),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 24),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: cursosAsync.maybeWhen(
                                  data: (cursos) =>
                                      GaulaSearchableDropdown<CursoModel?>(
                                    initialValue: cursos
                                        .where((c) => c.id == cursoFiltro)
                                        .firstOrNull,
                                    items: [null, ...cursos],
                                    label: l10n.alumnoCurso,
                                    hint: l10n.todosCursos,
                                    itemLabel: (c) => c == null
                                        ? l10n.todosCursos
                                        : c.codigoGrupo,
                                    onChanged: (val) {
                                      ref
                                          .read(alumnosCursoFiltroProvider.notifier)
                                          .state = val?.id;
                                      _resetPage();
                                    },
                                  ),
                                  orElse: () => const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),

              // Alumnos List
              Expanded(
                child: listAsync.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => Center(
                      child: Text('Error: $e',
                          style: const TextStyle(color: Colors.red))),
                  data: (paginatedResponse) {
                    final alumnos = paginatedResponse.content;

                    if (alumnos.isEmpty) {
                      return FadeIn(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.no_accounts_rounded,
                                  size: 100,
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey[200]),
                              const SizedBox(height: 24),
                              Text(l10n.sinAlumnosEncontrados,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(isMobile ? 20 : 40),
                            itemCount: alumnos.length,
                            itemBuilder: (context, index) {
                              final alumno = alumnos[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 50 * index),
                                child: _StudentCard(alumno: alumno),
                              );
                            },
                          ),
                        ),
                        // Server-side Pagination
                        GaulaPagination(
                          currentPage: currentPage,
                          totalPages: paginatedResponse.totalPages,
                          onPageChanged: (newPage) {
                            ref.read(alumnosPageProvider.notifier).state =
                                newPage;
                          },
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
}

class _StudentCard extends ConsumerWidget {
  final AlumnoModel alumno;
  const _StudentCard({required this.alumno});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => context.pushNamed('admin-student-detail',
            pathParameters: {'studentId': alumno.id.toString()}),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isDark ? AppColors.border : AppColors.borderLight,
                width: 1.5),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
          ),
          child: Row(
            children: [
              // 1. Info Principal
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    GaulaProfileImage(
                      fotoUrl: alumno.fotoUrl ?? alumno.avatar,
                      nombre: alumno.nombreCompleto,
                      radius: 38,
                      isSquare: true,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alumno.nombreCompleto,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _StatusBadge(
                                  estado: alumno.estado,
                                  esActivo: alumno.esActivo),
                              const SizedBox(width: 12),
                              Icon(Icons.school_rounded,
                                  size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  alumno.codigoGrupo ?? l10n.alumnoSinCurso.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Métricas (Asistencia - Solo Contadores)
              Expanded(
                flex: 3,
                child: ref.watch(_alumnoResumenProvider(alumno.id)).when(
                      loading: () => const Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (resumen) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _AttendanceCounter(
                              label: l10n.fichaFaltas.toUpperCase(),
                              count: resumen['ausentes'] ?? 0,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 32),
                            _AttendanceCounter(
                              label: l10n.fichaRetrasos.toUpperCase(),
                              count: resumen['retrasos'] ?? 0,
                              color: Colors.orangeAccent,
                            ),
                          ],
                        );
                      },
                    ),
              ),

              // 3. Botones de Acción Premium
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CircleActionButton(
                    icon: Icons.analytics_outlined,
                    tooltip: l10n.reporteAsistenciaLabel,
                    color: Colors.blueAccent,
                    onTap: () => context.pushNamed('admin-student-detail',
                        pathParameters: {'studentId': alumno.id.toString()}),
                  ),
                  const SizedBox(width: 16),
                  _CircleActionButton(
                    icon: Icons.edit_rounded,
                    tooltip: l10n.editarExpediente,
                    color: AppColors.primary,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddAlumnoDialog(alumno: alumno),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _CircleActionButton(
                    icon: alumno.esActivo
                        ? Icons.person_off_rounded
                        : Icons.person_add_alt_1_rounded,
                    tooltip: alumno.esActivo ? l10n.darDeBaja : l10n.activarAlumno,
                    color:
                        alumno.esActivo ? Colors.redAccent : Colors.greenAccent,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor:
                              isDark ? AppColors.backgroundDark : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: BorderSide(
                                  color: isDark
                                      ? AppColors.border
                                      : AppColors.borderLight,
                                  width: 2)),
                          title: Text(
                              alumno.esActivo
                                  ? l10n.confirmarBaja
                                  : l10n.activarAlumno,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  letterSpacing: -0.5)),
                          content: Text(
                              alumno.esActivo
                                  ? l10n.adminAlumnosConfirmarDesactivar(alumno.nombre)
                                  : l10n.adminAlumnosConfirmarActivar(alumno.nombre)),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(l10n.cancelar.toUpperCase())),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: alumno.esActivo
                                    ? Colors.redAccent
                                    : Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(l10n.confirmar.toUpperCase()),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        ref.read(alumnosCrudProvider.notifier).cambiarEstado(
                            alumno.id, alumno.esActivo ? 'INACTIVO' : 'ACTIVO');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionButton(
      {required this.icon,
      required this.tooltip,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.1)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String estado;
  final bool esActivo;
  const _StatusBadge({required this.estado, required this.esActivo});

  @override
  Widget build(BuildContext context) {
    final color = esActivo ? Colors.green : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        estado.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5),
      ),
    );
  }
}

class _AttendanceCounter extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _AttendanceCounter({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}






