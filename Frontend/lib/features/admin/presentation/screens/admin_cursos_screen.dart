import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaula_frontend/features/admin/domain/entities/curso_plantilla_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/gaula_searchable_dropdown.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/cursos_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../../application/providers/anio_escolar_provider.dart';
import '../../domain/entities/anio_escolar_model.dart';
import '../../application/providers/profesores_provider.dart';
import '../../application/providers/alumnos_provider.dart';
import '../../../shared/models/curso_model.dart';
import '../../../shared/presentation/horario_screen.dart';
import '../../../../shared/widgets/gaula_profile_image.dart';
import 'admin_horario_screen.dart';
import '../widgets/admin_curso_horario_view.dart';
import '../widgets/admin_cursos_widgets.dart';
import '../../application/providers/curso_plantilla_provider.dart';

enum CursosViewMode {
  grid,
  create,
  calendar,
  templateDetail,
  planning,
  schedule,
  courseDetail,
  createPlantilla
}

class AdminCursosScreen extends ConsumerStatefulWidget {
  const AdminCursosScreen({super.key});

  @override
  ConsumerState<AdminCursosScreen> createState() => _AdminCursosScreenState();
}

class _AdminCursosScreenState extends ConsumerState<AdminCursosScreen> {
  CursosViewMode _currentView = CursosViewMode.grid;
  String _selectedCycleCode = 'DAM';
  String activeYearName = 'Cursos';

  // Create Form State
  String? _selectedTemplate = 'DAM';
  Color? _selectedColor = AppColors.primary;
  String? _selectedTurno;
  final _codigoGrupoCtrl = TextEditingController();
  final _desdoblamientoCtrl = TextEditingController();
  final _etapaCtrl = TextEditingController(text: '0');
  int? _selectedAnioId;
  int? _selectedTutorId;
  String? _selectedTutorNombre;
  List<int> _selectedAlumnoIds = [];
  List<int> _selectedMateriaIds = [];
  final _createFormKey = GlobalKey<FormState>();
  CursoModel? _selectedCursoForSchedule;
  CursoModel? _selectedCursoForDetail;

  final _teacherSearchCtrl = TextEditingController();
  final _studentSearchCtrl = TextEditingController();
  String _teacherSearchQuery = '';
  String _studentSearchQuery = '';
  bool _showTeacherResults = false;
  bool _showStudentResults = false;
  List<Map<String, String>> _buildTurnos(AppLocalizations l10n) => [
    {'id': 'PARTIDO', 'text': l10n.adminCursosTurnoPartido},
    {'id': 'MANANA',  'text': l10n.adminCursosTurnoManana},
    {'id': 'TARDE',   'text': l10n.adminCursosTurnoTarde},
    {'id': 'NOCTURNO','text': l10n.adminCursosTurnoNocturno},
  ];

  @override
  void dispose() {
    _teacherSearchCtrl.dispose();
    _studentSearchCtrl.dispose();
    _codigoGrupoCtrl.dispose();
    _desdoblamientoCtrl.dispose();
    _etapaCtrl.dispose();
    super.dispose();
  }

  void _updateCodigoGrupo() {
    if (_selectedTemplate == null) return;
    String code = _selectedTemplate!;
    final etapa = _etapaCtrl.text.trim();
    if (etapa.isNotEmpty && etapa != '0') {
      code += etapa;
    }
    final desdoblamiento = _desdoblamientoCtrl.text.trim().toUpperCase();
    if (desdoblamiento.isNotEmpty) {
      code += desdoblamiento;
    }
    if (_selectedTurno != null && _selectedTurno!.isNotEmpty) {
      code += _selectedTurno![0].toUpperCase();
    }
    _codigoGrupoCtrl.text = code.replaceAll(' ', '');
  }

  void _deleteCurso(CursoModel curso) {
    if (curso.totalAlumnos != null && curso.totalAlumnos! > 0) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminCursosNoEliminarConAlumnos),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
        title: Text(l10n.eliminar, style: TextStyle(color: textColor, fontWeight: FontWeight.w900)),
        content: Text(
            l10n.cursoConfirmarEliminar(curso.codigoGrupo),
            style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar,
                style: TextStyle(color: textColor.withValues(alpha: 0.7))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(cursosCrudProvider.notifier)
                  .eliminar(curso.id);
              if (!mounted) return;
              final l10nSnack = AppLocalizations.of(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10nSnack.adminCursoEliminadoOk),
                      backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10nSnack.adminCursoEliminadoError),
                      backgroundColor: Colors.red),
                );
              }
            },
            child: Text(l10n.eliminar,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String getDisplayCursoLetters(final int? etapa, String? desdoblamiento, String? turno) {
    String letters = '';
    if (etapa != null && etapa > 0) {
      letters = '$etapa';
    }
    if (desdoblamiento != null && desdoblamiento.trim().isNotEmpty) {
      letters = '$letters${desdoblamiento.trim().toUpperCase()}';
    }
    if (turno != null && turno.trim().isNotEmpty) {
      if (letters.isNotEmpty) {
        letters = '$letters-';
      }
      letters = '$letters${turno.trim().toUpperCase()[0]}';
    }
    return letters;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CursosViewMode.create:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : AppColors.textDark;
        return Form(
          key: _createFormKey,
          child: _buildCreateView(
              context: context, textColor: textColor, isDark: isDark),
        );
      case CursosViewMode.calendar:
        return _buildCalendarView(key: const ValueKey('calendar'));
      case CursosViewMode.templateDetail:
        return _buildTemplateDetailView(key: const ValueKey('templateDetail'));
      case CursosViewMode.planning:
        return _buildPlanningView(key: const ValueKey('planning'));
      case CursosViewMode.schedule:
        return _selectedCursoForSchedule != null
            ? _buildScheduleView(key: const ValueKey('schedule'))
            : _buildGridView(key: const ValueKey('grid'));
      case CursosViewMode.courseDetail:
        return _selectedCursoForDetail != null
            ? _buildCourseDetailView(key: const ValueKey('courseDetail'))
            : _buildGridView(key: const ValueKey('grid'));
      case CursosViewMode.grid:
        return _buildGridView(key: const ValueKey('grid'));
      case CursosViewMode.createPlantilla:
        return const Center(child: Text("Vista no implementada"));
    }
  }

  Widget _buildGridView({Key? key}) {
    final cursosAsync = ref.watch(cursosListProvider);
    final aniosAsync = ref.watch(anioEscolarListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);

    final currentFilter = ref.watch(selectedAnioEscolarFilterProvider);
    String activeYearName = l10n.navCursos;
    aniosAsync.whenData((anios) {
      if (currentFilter != null) {
        final filteredYear = anios.firstWhere((a) => a.id == currentFilter,
            orElse: () => anios.isNotEmpty
                ? anios.first
                : const AnioEscolarModel(
                    id: 0,
                    nombre: '',
                    fechaInicio: '',
                    fechaFin: '',
                    activo: false));
        if (filteredYear.nombre.isNotEmpty) {
          activeYearName = '${l10n.navCursos} ${filteredYear.nombre}';
        }
      } else {
        final activeYear = anios.firstWhere((a) => a.activo,
            orElse: () => anios.isNotEmpty
                ? anios.first
                : const AnioEscolarModel(
                    id: 0,
                    nombre: '',
                    fechaInicio: '',
                    fechaFin: '',
                    activo: false));
        if (activeYear.nombre.isNotEmpty) {
          activeYearName = '${l10n.navCursos} ${activeYear.nombre}';
        }
      }
    });

    return Scaffold(
      key: key,
      backgroundColor: Colors.transparent,
      body: cursosAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (cursos) {
          final anios = ref.watch(anioEscolarListProvider).value ?? [];
          final currentFilter = ref.watch(selectedAnioEscolarFilterProvider);
          final bool esAdmin = ref.watch(usuarioActualProvider)?.esAdmin ?? false;

          AnioEscolarModel selectedYear = AnioEscolarModel(
              id: -1, nombre: '', fechaInicio: '', fechaFin: '', activo: false);
          if (currentFilter != null) {
            final filteredYear = anios.firstWhere((a) => a.id == currentFilter,
                orElse: () => anios.isNotEmpty ? anios.first : selectedYear);
            selectedYear = filteredYear;
          } else {
            final activeYear = anios.firstWhere((a) => a.activo,
                orElse: () => anios.isNotEmpty ? anios.first : selectedYear);
            selectedYear = activeYear;
          }

          Map<String, List<CursoModel>> groupedCursos = {};

          for (final c in cursos) {
            String cycleCode = c.codigoCiclo;

            if (c.anioEscolarId == selectedYear.id) {
              if (!groupedCursos.containsKey(cycleCode)) {
                groupedCursos[cycleCode] = [];
              }

              groupedCursos[cycleCode]!.add(c);
            }
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activeYearName,
                            style: TextStyle(
                                color: textColor,
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1.5)),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              HeaderButton(
                                icon: Icons.calendar_today,
                                label: isMobile ? '' : l10n.adminCursosCalendario,
                                color: AppColors.backgroundDarkSurface,
                                onTap: () => setState(
                                    () => _currentView = CursosViewMode.calendar),
                              ),
                              if (esAdmin) ...[
                                const SizedBox(width: 12),
                                HeaderButton(
                                  icon: Icons.history,
                                  label: isMobile ? '' : l10n.adminCursosVerOtrosAnios,
                                  color: AppColors.backgroundDarkSurface,
                                  onTap: () =>
                                      context.go(AppRoutes.adminSchoolYear),
                                ),
                                const SizedBox(width: 12),
                                HeaderButton(
                                  icon: Icons.add,
                                  label: isMobile ? '' : l10n.adminCursosAniadirCurso,
                                  color: AppColors.primary,
                                  isPrimary: true,
                                  onTap: () => setState(() {
                                    _selectedTemplate = null;
                                    _currentView = CursosViewMode.create;
                                  }),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filtro de Año Escolar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: aniosAsync.when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (anios) {
                          final Map<String, AnioEscolarModel> uniqueYearsMap =
                              {};
                          for (final a in anios) {
                            if (!uniqueYearsMap.containsKey(a.nombre) ||
                                a.activo) {
                              uniqueYearsMap[a.nombre] = a;
                            }
                          }
                          final uniqueAnios = uniqueYearsMap.values.toList()
                            ..sort((a, b) {
                              if (a.activo != b.activo) {
                                return a.activo ? -1 : 1;
                              }
                              return b.nombre.compareTo(a.nombre);
                            });

                          final currentFilter =
                              ref.watch(selectedAnioEscolarFilterProvider);
                          int? dropdownValue = currentFilter;

                          return GaulaSearchableDropdown<AnioEscolarModel>(
                            initialValue: uniqueAnios.any((a) => a.id == dropdownValue)
                                ? uniqueAnios
                                    .firstWhere((a) => a.id == dropdownValue)
                                : null,
                            items: [...uniqueAnios],
                            label: l10n.adminCursosAnioAcademico,
                            itemLabel: (a) =>
                                a.nombre + (a.activo ? ' (Activo)' : ''),
                            hint: l10n.adminCursosBuscarAnio,
                            onChanged: (v) {
                              ref
                                  .read(selectedAnioEscolarFilterProvider
                                      .notifier)
                                  .state = v?.id;
                            },
                          );
                        }),
                  ),
                  const SizedBox(height: 32),

                  CourseGrid(
                    groupedCursos: groupedCursos,
                    esAdmin: esAdmin,
                    onTap: (cycleCode) => setState(() {
                      _selectedCycleCode = cycleCode;
                      _currentView = CursosViewMode.templateDetail;
                    }),
                    onAddGroup: esAdmin ? (cycleCode) => setState(() {
                      _selectedTemplate = cycleCode;
                      _currentView = CursosViewMode.create;
                    }) : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarView({Key? key}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? Colors.white70 : AppColors.textMuted;
    final l10n = AppLocalizations.of(context);
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
          child: TextButton.icon(
            onPressed: () => setState(() => _currentView = CursosViewMode.grid),
            icon: Icon(Icons.arrow_back, color: navColor),
            label: Text(l10n.adminCursosVolverCursos,
                style: TextStyle(color: navColor, fontWeight: FontWeight.bold)),
          ),
        ),
        const Expanded(child: AdminHorarioScreen()),
      ],
    );
  }

  Widget _buildCreateView(
      {Key? key,
      required BuildContext context,
      required Color textColor,
      required bool isDark}) {
    final aniosAsync = ref.watch(anioEscolarListProvider);
    final profesoresAsync = ref.watch(profesoresListProvider);
    final alumnosAsync = ref.watch(alumnosSinMatricularProvider);
    final plantillasAsync = ref.watch(cursoPlantillasListProvider);
    final cursosAsync = ref.watch(cursosListProvider);

    final l10n = AppLocalizations.of(context);
    return StatefulBuilder(
      builder: (context, setInnerState) {
        void safeSetState(VoidCallback fn) {
          setState(fn);
          setInnerState(fn);
        }

        return SingleChildScrollView(
          key: key,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        safeSetState(() => _currentView = CursosViewMode.grid),
                    icon: Icon(Icons.arrow_back,
                        color: textColor.withValues(alpha: 0.7)),
                    label: Text(l10n.adminCursosVolverCursos,
                        style: TextStyle(
                            color: textColor.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.cursoNuevo,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(l10n.adminCursosCompletaInfo,
                      style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                          fontSize: 16)),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDarkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: isDark
                                ? AppColors.border
                                : AppColors.borderLight)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.adminCursosPlantillaCurso,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        plantillasAsync.when(
                          loading: () => Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                  color: AppColors.primary)),
                          error: (e, _) => Text('Error: $e',
                              style: const TextStyle(color: Colors.red)),
                          data: (plantillas) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.backgroundDarkSurface
                                      : AppColors.backgroundLightSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: isDark
                                          ? AppColors.border
                                          : AppColors.borderLight)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<
                                    CursoPlantillaModel?>(
                                  initialValue: plantillas
                                      .where(
                                          (p) => p.codigo == _selectedTemplate)
                                      .firstOrNull,
                                  dropdownColor: isDark
                                      ? AppColors.backgroundDarkCard
                                      : Colors.white,
                                  hint: Text(l10n.adminCursosSeleccionaPlantilla,
                                      style: TextStyle(
                                          color:
                                              textColor.withValues(alpha: 0.3),
                                          fontSize: 14)),
                                  isExpanded: true,
                                  validator: (v) => v == null
                                      ? l10n.adminCursosValidarPlantilla
                                      : null,
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  items: plantillas
                                      .map((p) => DropdownMenuItem(
                                            value: p,
                                            child: Text(
                                                '${p.codigo} - ${p.nombre}',
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      safeSetState(() {
                                        _selectedTemplate = v.codigo;
                                        _updateCodigoGrupo();
                                        _selectedMateriaIds = v.materias
                                            .map((m) => m.id)
                                            .toList();

                                        Color cardColor = AppColors.primary;
                                        if (v.color.startsWith('#')) {
                                          final hex =
                                              v.color.replaceFirst('#', '');
                                          if (hex.length == 6) {
                                            cardColor = Color(
                                                int.parse('FF$hex', radix: 16));
                                          }
                                        }
                                        _selectedColor = cardColor;
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.adminCursosTurnoOpcional,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Row(children: [
                                    _buildShiftSelectWidget(_buildTurnos(l10n)[0], isDark,
                                        textColor, safeSetState),
                                    const SizedBox(width: 8),
                                    _buildShiftSelectWidget(_buildTurnos(l10n)[1], isDark,
                                        textColor, safeSetState),
                                  ]),
                                  const SizedBox(height: 8),
                                  Row(children: [
                                    _buildShiftSelectWidget(_buildTurnos(l10n)[2], isDark,
                                        textColor, safeSetState),
                                    const SizedBox(width: 8),
                                    _buildShiftSelectWidget(_buildTurnos(l10n)[3], isDark,
                                        textColor, safeSetState),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.adminCursosEtapa,
                                      style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _etapaCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    onChanged: (_) => safeSetState(
                                        () => _updateCodigoGrupo()),
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: isDark
                                          ? AppColors.backgroundDarkSurface
                                          : AppColors.backgroundLightSurface,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.border
                                                  : AppColors.borderLight)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.border
                                                  : AppColors.borderLight)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.adminCursosDesdoblamiento,
                                      style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _desdoblamientoCtrl,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z]')),
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    onChanged: (_) => safeSetState(
                                        () => _updateCodigoGrupo()),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      hintText: l10n.adminCursosOrdenHint,
                                      hintStyle: const TextStyle(
                                          color: AppColors.textMuted),
                                      filled: true,
                                      fillColor: isDark
                                          ? AppColors.backgroundDarkSurface
                                          : AppColors.backgroundLightSurface,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.border
                                                  : AppColors.borderLight)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.border
                                                  : AppColors.borderLight)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(l10n.adminCursosCodigoGrupo,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _codigoGrupoCtrl,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          validator: (val) {
                            final code = val?.trim() ?? '';
                            if (code.isEmpty) return l10n.adminCursosValidarCodigoGrupoVacio;
                            final cursos = cursosAsync.value ?? [];
                            final isDuplicate = cursos.any((c) =>
                              c.codigoGrupo.toLowerCase() == code.toLowerCase() &&
                              c.anioEscolarId == _selectedAnioId);
                            if (isDuplicate) return l10n.adminCursosValidarCodigoGrupoVacio;
                            return null;
                          },
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: l10n.adminCursosCodigoHint,
                            hintStyle:
                                const TextStyle(color: AppColors.textMuted),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.backgroundDarkSurface
                                : AppColors.backgroundLightSurface,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.border
                                        : AppColors.borderLight)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.border
                                        : AppColors.borderLight)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(l10n.adminCursosAnioAcademico,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        aniosAsync.when(
                          loading: () => const LinearProgressIndicator(
                              color: AppColors.primary),
                          error: (err, _) => Text('Error al cargar años: $err',
                              style: const TextStyle(color: Colors.red)),
                          data: (anios) {
                            if (anios.isEmpty) {
                              return Text(l10n.adminCursosSinAnios,
                                  style: TextStyle(
                                      color: textColor.withValues(alpha: 0.7)));
                            }
                            if (anios.isNotEmpty) {
                              final hasId =
                                  anios.any((a) => a.id == _selectedAnioId);
                              if (!hasId) {
                                _selectedAnioId = anios.first.id;
                              }
                            }
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.backgroundDarkSurface
                                      : AppColors.backgroundLightSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: isDark
                                          ? AppColors.border
                                          : AppColors.borderLight)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<int>(
                                  initialValue: _selectedAnioId,
                                  dropdownColor: isDark
                                      ? AppColors.backgroundDarkCard
                                      : Colors.white,
                                  isExpanded: true,
                                  validator: (v) => v == null
                                      ? l10n.adminCursosValidarAnio
                                      : null,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                  items: anios
                                      .map((a) => DropdownMenuItem<int>(
                                          value: a.id, child: Text(a.nombre)))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      safeSetState(() => _selectedAnioId = v);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(l10n.adminCursosProfesorTutor,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        FormField<int?>(
                          validator: (_) => _selectedTutorId == null
                              ? l10n.adminCursosValidarTutor
                              : null,
                          builder: (state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_selectedTutorId != null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.backgroundDarkSurface
                                          : AppColors.backgroundLightSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isDark
                                              ? AppColors.border
                                              : AppColors.borderLight)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_selectedTutorNombre ?? l10n.adminCursosTutorAsignado,
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () {
                                          safeSetState(() {
                                            _selectedTutorId = null;
                                            _selectedTutorNombre = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    TextField(
                                      controller: _teacherSearchCtrl,
                                      style: TextStyle(color: textColor),
                                      decoration: InputDecoration(
                                        hintText: l10n.adminCursosBuscarProfesor,
                                        hintStyle: const TextStyle(
                                            color: AppColors.textMuted),
                                        prefixIcon: const Icon(Icons.search,
                                            color: AppColors.textMuted),
                                        filled: true,
                                        fillColor: isDark
                                            ? AppColors.backgroundDarkSurface
                                            : AppColors.backgroundLightSurface,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: isDark
                                                    ? AppColors.border
                                                    : AppColors.borderLight)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: isDark
                                                    ? AppColors.border
                                                    : AppColors.borderLight)),
                                      ),
                                      onChanged: (val) {
                                        safeSetState(() {
                                          _teacherSearchQuery = val;
                                          _showTeacherResults = val.isNotEmpty;
                                        });
                                      },
                                    ),
                                    if (_showTeacherResults)
                                      profesoresAsync.when(
                                        loading: () => const LinearProgressIndicator(
                                            color: AppColors.primary),
                                        error: (e, _) => Text('Error: $e'),
                                        data: (profesores) {
                                          final filtered = profesores.content
                                              .where((p) => p.nombreCompleto
                                                  .toLowerCase()
                                                  .contains(_teacherSearchQuery
                                                      .toLowerCase()))
                                              .toList();
                                          if (filtered.isEmpty) {
                                            return const SizedBox.shrink();
                                          }

                                          return Container(
                                            constraints:
                                                const BoxConstraints(maxHeight: 200),
                                            margin: const EdgeInsets.only(top: 8),
                                            decoration: BoxDecoration(
                                                color: isDark
                                                    ? AppColors.backgroundDarkCard
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: isDark
                                                        ? AppColors.border
                                                        : AppColors.borderLight)),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: filtered.length,
                                              itemBuilder: (context, index) {
                                                final p = filtered[index];
                                                return ListTile(
                                                  title: Text(p.nombreCompleto,
                                                      style: TextStyle(
                                                          color: textColor)),
                                                  trailing: const Icon(Icons.add,
                                                      color: AppColors.primary),
                                                  onTap: () {
                                                    safeSetState(() {
                                                      _selectedTutorId = p.id;
                                                      _selectedTutorNombre =
                                                          p.nombreCompleto;
                                                      _showTeacherResults = false;
                                                      _teacherSearchCtrl.clear();
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 12),
                                  child: Text(
                                    state.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                            l10n.adminCursosMatriculacion(_selectedAlumnoIds.length),
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _studentSearchCtrl,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: l10n.buscarAlumnos,
                            hintStyle:
                                const TextStyle(color: AppColors.textMuted),
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.textMuted),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.backgroundDarkSurface
                                : AppColors.backgroundLightSurface,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.border
                                        : AppColors.borderLight)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.border
                                        : AppColors.borderLight)),
                          ),
                          onChanged: (val) {
                            safeSetState(() {
                              _studentSearchQuery = val;
                              _showStudentResults = val.isNotEmpty;
                            });
                          },
                        ),
                        if (_showStudentResults)
                          alumnosAsync.when(
                            loading: () => const LinearProgressIndicator(
                                color: AppColors.primary),
                            error: (e, _) => Text('Error: $e'),
                            data: (alumnos) {
                              final filtered = alumnos
                                  .where((a) =>
                                      !_selectedAlumnoIds.contains(a.id) &&
                                      a.nombreCompleto.toLowerCase().contains(
                                          _studentSearchQuery.toLowerCase()))
                                  .toList();
                              if (filtered.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.backgroundDarkCard
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: isDark
                                            ? AppColors.border
                                            : AppColors.borderLight)),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final a = filtered[index];
                                    return ListTile(
                                      title: Text(a.nombreCompleto,
                                          style: TextStyle(color: textColor)),
                                      trailing: const Icon(Icons.add,
                                          color: AppColors.primary),
                                      onTap: () {
                                        if (!_selectedAlumnoIds
                                            .contains(a.id)) {
                                          safeSetState(() {
                                            _selectedAlumnoIds = {
                                              ..._selectedAlumnoIds,
                                              a.id
                                            }.toList().cast<int>();
                                            _showStudentResults = false;
                                            _studentSearchCtrl.clear();
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 16),
                        if (_selectedAlumnoIds.isNotEmpty)
                          alumnosAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (e, _) => const SizedBox.shrink(),
                            data: (alumnos) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _selectedAlumnoIds.length,
                                itemBuilder: (context, idx) {
                                  final id = _selectedAlumnoIds[idx];
                                  final a = alumnos
                                      .firstWhere((al) => al.id == id);
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.backgroundDarkSurface
                                          : AppColors.backgroundLightSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isDark
                                              ? AppColors.border
                                              : AppColors.borderLight),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(a.nombreCompleto,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            if (a.email.isNotEmpty)
                                              Text(a.email,
                                                  style: TextStyle(
                                                      color: isDark
                                                          ? AppColors
                                                              .textSecondary
                                                          : AppColors.textMuted,
                                                      fontSize: 13)),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20),
                                          onPressed: () {
                                            safeSetState(() {
                                              _selectedAlumnoIds.remove(id);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        const SizedBox(height: 32),
                        Text(l10n.adminCursosMaterias,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        FormField<List<int>>(
                          validator: (_) => _selectedMateriaIds.isEmpty
                              ? l10n.adminCursosValidarMateria
                              : null,
                          builder: (state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              plantillasAsync.when(
                                loading: () => const LinearProgressIndicator(
                                    color: AppColors.primary),
                                error: (e, _) => const SizedBox.shrink(),
                                data: (plantillas) {
                                  final currentPlantilla = plantillas.firstWhere(
                                      (p) => p.codigo == _selectedTemplate,
                                      orElse: () => plantillas.first);
                                  if (_selectedTemplate == null ||
                                      currentPlantilla.materias.isEmpty) {
                                    return Text(
                                        l10n.adminCursosSinMaterias,
                                        style: TextStyle(
                                            color: textColor.withValues(alpha: 0.7)));
                                  }
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.backgroundDarkSurface
                                          : AppColors.backgroundLightSurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isDark
                                              ? AppColors.border
                                              : AppColors.borderLight),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                l10n.adminCursosSeleccionaAsignaturas,
                                                style: TextStyle(
                                                    color: textColor.withValues(
                                                        alpha: 0.7),
                                                    fontSize: 13)),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children:
                                              currentPlantilla.materias.map((m) {
                                            final isSelected =
                                                _selectedMateriaIds.contains(m.id);
                                            return InkWell(
                                              onTap: () {
                                                safeSetState(() {
                                                  if (isSelected) {
                                                    _selectedMateriaIds =
                                                        _selectedMateriaIds
                                                            .where((id) => id != m.id)
                                                            .toList();
                                                  } else if (!_selectedMateriaIds
                                                      .contains(m.id)) {
                                                    _selectedMateriaIds = [
                                                      ..._selectedMateriaIds,
                                                      m.id
                                                    ];
                                                  }
                                                });
                                              },
                                              borderRadius: BorderRadius.circular(20),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColors.primary
                                                          .withValues(alpha: 0.1)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: isSelected
                                                          ? AppColors.primary
                                                          : (isDark
                                                              ? AppColors.border
                                                              : AppColors
                                                                  .borderLight)),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        isSelected
                                                            ? Icons.check_circle
                                                            : Icons.circle_outlined,
                                                        color: isSelected
                                                            ? AppColors.primary
                                                            : textColor.withValues(
                                                                alpha: 0.3),
                                                        size: 18),
                                                    const SizedBox(width: 8),
                                                    Text(m.codigo,
                                                        style: TextStyle(
                                                            color: isSelected
                                                                ? AppColors.primary
                                                                : textColor,
                                                            fontWeight: isSelected
                                                                ? FontWeight.bold
                                                                : FontWeight.normal)),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 12),
                                  child: Text(
                                    state.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Divider(
                            color: isDark
                                ? AppColors.border
                                : AppColors.borderLight),
                        const SizedBox(height: 24),
                        Text(l10n.adminCursosVistaPrevia,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.backgroundDarkSurface
                                : AppColors.backgroundLightSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.25),
                                width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: _selectedColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                    child: Text(
                                      getDisplayCursoLetters(int.tryParse(_etapaCtrl.text.trim()), _desdoblamientoCtrl.text, _selectedTurno),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold))),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _codigoGrupoCtrl.text.isNotEmpty
                                          ? _codigoGrupoCtrl.text
                                          : '${(_selectedTemplate == null ? '' : '$_selectedTemplate ')}${_selectedTurno != null && _selectedTurno!.isNotEmpty ? _selectedTurno![0] : ''}',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_selectedAlumnoIds.length} alumnos matriculados',
                                      style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: isDark
                                          ? AppColors.border
                                          : AppColors.borderLight),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  safeSetState(() {
                                    _selectedTurno = null;
                                    _selectedTutorId = null;
                                    _selectedTutorNombre = null;
                                    _selectedAlumnoIds = [];
                                    _selectedMateriaIds = [];
                                    _codigoGrupoCtrl.clear();
                                    _desdoblamientoCtrl.clear();
                                    _etapaCtrl.text = '0';
                                    _currentView = CursosViewMode.grid;
                                  });
                                },
                                child: Text(l10n.cancelar,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () async {
                                  if (_createFormKey.currentState?.validate() ??
                                      false) {
                                    if (_codigoGrupoCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  '⚠️ El código de grupo es obligatorio.'),
                                              backgroundColor: Colors.orange));
                                      return;
                                    }
                                    String groupCode =
                                        _codigoGrupoCtrl.text.trim();

                                    final crud =
                                        ref.read(cursosCrudProvider.notifier);
                                    final plantillas = ref
                                            .read(cursoPlantillasListProvider)
                                            .value ??
                                        [];
                                    final plantilla = plantillas.firstWhere(
                                        (p) => p.codigo == _selectedTemplate,
                                        orElse: () => plantillas.first);

                                    final exitoso = await crud.crear({
                                      'codigoGrupo': groupCode,
                                      'anioEscolarId': _selectedAnioId,
                                      'cursoPlantillaId': plantilla.id,
                                      'turno': _selectedTurno,
                                      'desdoblamiento': _desdoblamientoCtrl.text
                                              .trim()
                                              .isEmpty
                                          ? null
                                          : _desdoblamientoCtrl.text
                                              .trim()
                                              .toUpperCase(),
                                      'etapaCurso': int.tryParse(
                                                  _etapaCtrl.text.trim()) ==
                                              0
                                          ? null
                                          : int.tryParse(
                                              _etapaCtrl.text.trim()),
                                      if (_selectedTutorId != null)
                                        'tutorId': _selectedTutorId,
                                        'studentIds': _selectedAlumnoIds,
                                        'materiaPlantillaIds': _selectedMateriaIds,
                                    });

                                    if (!context.mounted) return;

                                    if (exitoso) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '✅ Curso creado correctamente'),
                                            backgroundColor: Colors.green),
                                      );
                                      safeSetState(() {
                                        _selectedTurno = null;
                                        _selectedTutorId = null;
                                        _selectedTutorNombre = null;
                                        _selectedAlumnoIds = [];
                                        _selectedMateriaIds = [];
                                        _codigoGrupoCtrl.clear();
                                        _desdoblamientoCtrl.clear();
                                        _etapaCtrl.text = '0';
                                        _currentView = CursosViewMode.grid;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '❌ Error al crear el curso'),
                                            backgroundColor: Colors.red),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              '⚠️ Por favor, rellena todos los campos requeridos.'),
                                          backgroundColor: Colors.orange),
                                    );
                                  }
                                },
                                child: Text(l10n.crear,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
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
          ),
        );
      },
    );
  }

  Widget _buildShiftSelectWidget(dynamic shift, bool isDark, Color textColor,
      Function(Function()) onPressed) {
    bool preventDoubleTap = false;
    return Expanded(
        child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedTurno == shift['id']
            ? AppColors.primary
            : (isDark
                ? AppColors.backgroundDarkSurface
                : AppColors.backgroundLightSurface),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isDark ? AppColors.border : AppColors.borderLight)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => onPressed(() {
        if (preventDoubleTap) {
          preventDoubleTap = false;
        } else {
          (_selectedTurno != shift['id'])
              ? (_selectedTurno = shift['id'])
              : (_selectedTurno = null);
          _updateCodigoGrupo();
          preventDoubleTap = true;
        }
      }),
      child: Text(shift['text'],
          style: TextStyle(
              color: _selectedTurno == shift['id']
                  ? Colors.white
                  : textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold)),
    ));
  }

  Widget _buildTemplateDetailView({Key? key}) {
    final cursosAsync = ref.watch(cursosListProvider);
    final plantillasAsync = ref.watch(cursoPlantillasListProvider);
    final aniosAsync = ref.watch(anioEscolarListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final bool esAdmin = ref.watch(usuarioActualProvider)?.esAdmin ?? false;
    final l10n = AppLocalizations.of(context);

    String activeYearName = '';
    aniosAsync.whenData((anios) {
      final activeYear = anios.firstWhere((a) => a.activo,
          orElse: () => anios.isNotEmpty
              ? anios.first
              : const AnioEscolarModel(
                  id: 0,
                  nombre: '',
                  fechaInicio: '',
                  fechaFin: '',
                  activo: false));
      if (activeYear.nombre.isNotEmpty) {
        activeYearName = activeYear.nombre;
      }
    });

    return Scaffold(
      key: key,
      backgroundColor: Colors.transparent,
      body: cursosAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.red))),
        data: (cursos) {
          final relevantCursos = cursos
              .where((c) => c.codigoGrupo.contains(_selectedCycleCode))
              .toList();

          return plantillasAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (plantillas) {
              final template = plantillas.firstWhere(
                (p) => p.codigo.trim().toUpperCase() == _selectedCycleCode.trim().toUpperCase(), 
                orElse: () => plantillas.firstWhere(
                  (p) => _selectedCycleCode.contains(p.codigo),
                  orElse: () => plantillas.isNotEmpty ? plantillas.first : CursoPlantillaModel(id: 0, codigo: _selectedCycleCode, nombre: _selectedCycleCode, descripcion: '', color: '#60A5FA', materias: [])
                )
              );

              Color color = AppColors.primary;
              if (template.color.startsWith('#')) {
                final hex = template.color.replaceFirst('#', '');
                if (hex.length == 6) color = Color(int.parse('FF$hex', radix: 16));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _currentView = CursosViewMode.grid),
                          icon: Icon(Icons.arrow_back,
                              color: textColor.withValues(alpha: 0.7)),
                          label: Text(l10n.adminCursosVolverCursos,
                              style: TextStyle(
                                  color: textColor.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
                              ),
                              child: Center(
                                child: Text(
                                  template.codigo,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template.nombre,
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    (template.descripcion ?? '').isEmpty ? 'Sin descripción disponible para esta plantilla.' : template.descripcion!,
                                    style: TextStyle(
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.textMuted,
                                        fontSize: 16,
                                        height: 1.5),
                                  ),
                                  const SizedBox(height: 16),
                                  _badge(l10n.adminCursosPlantillaOficial, color),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 48),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.adminCursosInstanciados,
                                    style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                                  Text('${l10n.adminCursosVisualizacion}: $activeYearName',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                    overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            if (esAdmin) ...[
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                elevation: 8,
                                shadowColor: color.withValues(alpha: 0.4),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedTemplate = _selectedCycleCode;
                                  _currentView = CursosViewMode.create;
                                });
                              },
                              icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                              label: Text(
                                l10n.adminCursosAniadirNuevo,
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                              ),
                            ),
                          ],
                          ],
                        ),
                        const SizedBox(height: 32),
                        relevantCursos.isEmpty
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.all(64),
                                  child: Column(
                                    children: [
                                      Icon(Icons.layers_clear_outlined, size: 64, color: isDark ? Colors.white10 : Colors.black12),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.adminCursosNoRegistrados,
                                        style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 360,
                              mainAxisExtent: 380,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                            itemCount: relevantCursos.length,
                            itemBuilder: (context, index) {
                              final c = relevantCursos[index];
                              String turnoLetra = '';
                              String turnoNombre = '';

                              if (c.turno != null) {
                                Map<String, String> turno = _buildTurnos(l10n).firstWhere((test) => test['id'].toString() == c.turno, orElse: () => {'id': '', 'text': ''});
                                turnoLetra = turno['id'].toString()[0];
                                turnoNombre = turno['text'].toString().split(' ')[0];
                              }

                              return Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.backgroundDarkCard
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: color.withValues(alpha: 0.15),
                                      width: 2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: color.withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              getDisplayCursoLetters(c.etapaCurso, c.desdoblamiento, turnoLetra),
                                              style: TextStyle(
                                                  color: color,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        if (esAdmin)
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20),
                                          onPressed: () => _deleteCurso(c),
                                          tooltip: l10n.adminCursosEliminarTooltip,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      c.codigoGrupo,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$_selectedCycleCode ${c.etapaCurso != null && c.etapaCurso != 0 ? c.etapaCurso.toString() : ''}${c.desdoblamiento ?? ''} $turnoLetra'
                                          .replaceAll(RegExp(r'\s+'), ' ')
                                          .trim(),
                                      style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted,
                                          fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                _selectedCursoForSchedule = c;
                                                _currentView =
                                                    CursosViewMode.schedule;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.calendar_today,
                                                size: 14),
                                            label: Text(
                                                l10n.adminCursosGestionarHorario,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                _selectedCursoForDetail = c;
                                                _currentView =
                                                    CursosViewMode.courseDetail;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.people_outline,
                                                size: 14),
                                            label: Text(
                                                l10n.adminCursosGestionarAlumnos,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isDark
                                                  ? AppColors
                                                      .backgroundDarkSurface
                                                  : AppColors
                                                      .backgroundLightSurface,
                                              foregroundColor: isDark
                                                  ? Colors.white
                                                  : AppColors.textDark,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  side: BorderSide(
                                                      color: isDark
                                                          ? AppColors.border
                                                          : AppColors
                                                              .borderLight)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Divider(
                                        color: isDark
                                            ? AppColors.border
                                            : AppColors.borderLight,
                                        height: 1),
                                    const SizedBox(height: 12),
                                    if (c.etapaCurso != null &&
                                        c.etapaCurso != 0) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Etapa:',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 13)),
                                          Text('${c.etapaCurso}',
                                              style: TextStyle(
                                                  color: textColor.withValues(
                                                      alpha: 0.7),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    if (c.desdoblamiento != null &&
                                        c.desdoblamiento!.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Desdoblamiento:',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 13)),
                                          Text(c.desdoblamiento!,
                                              style: TextStyle(
                                                  color: textColor.withValues(
                                                      alpha: 0.7),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    if (turnoNombre.isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Turno:',
                                            style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            turnoNombre,
                                            style: TextStyle(
                                                color: textColor.withValues(
                                                    alpha: 0.7),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
    );
  }

  Widget _buildPlanningView({Key? key}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);

    final modules = [
      {
        'name': 'M01 - Sistemas Informáticos',
        'progress': 0.85,
        'start': '2025-09-15',
        'end': '2026-02-10'
      },
      {
        'name': 'M02 - Bases de Datos',
        'progress': 0.60,
        'start': '2025-10-01',
        'end': '2026-03-20'
      },
      {
        'name': 'M03 - Programación',
        'progress': 0.45,
        'start': '2025-11-15',
        'end': '2026-05-30'
      },
      {
        'name': 'M04 - Lenguajes de Marcas',
        'progress': 0.95,
        'start': '2025-09-15',
        'end': '2025-12-20'
      },
    ];

    return FadeIn(
      key: key,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () =>
                          setState(() => _currentView = CursosViewMode.grid),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.adminCursosPlanificacion}: $_selectedCycleCode',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ...modules.map((m) => Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundDarkCard
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? AppColors.border
                                : AppColors.borderLight),
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
                              Text(m['name'] as String,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              _badge('VIGENTE', Colors.greenAccent),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(l10n.adminCursosProgresoModulo,
                                            style: TextStyle(
                                                color: isDark
                                                    ? AppColors.textSecondary
                                                    : AppColors.textMuted,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '${((m['progress'] as double) * 100).toInt()}%',
                                            style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: m['progress'] as double,
                                        backgroundColor: isDark
                                            ? AppColors.backgroundDarkSurface
                                            : AppColors.backgroundLightSurface,
                                        color: AppColors.primary,
                                        minHeight: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 48),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.adminCursosTemporalidad,
                                      style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14,
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColors.textMuted),
                                      const SizedBox(width: 8),
                                      Text('${m['start']} - ${m['end']}',
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? AppColors.backgroundDarkSurface
                                      : AppColors.backgroundLightSurface,
                                  foregroundColor: isDark
                                      ? Colors.white
                                      : AppColors.textDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: isDark
                                              ? AppColors.border
                                              : AppColors.borderLight)),
                                ),
                                child: Text(l10n.adminCursosEditarFechas),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleView({Key? key}) {
    if (_selectedCursoForSchedule == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);

    return Column(
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () => setState(
                    () => _currentView = CursosViewMode.templateDetail),
                icon: Icon(Icons.arrow_back,
                    color: textColor.withValues(alpha: 0.7)),
                label: Text(l10n.adminCursosVolverDetalles,
                    style: TextStyle(
                        color: textColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: AdminCursoHorarioView(curso: _selectedCursoForSchedule!),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDetailView({Key? key}) {
    final c = _selectedCursoForDetail!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);
    final isAdmin = ref.watch(usuarioActualProvider)?.esAdmin ?? false;
    String turnoLetra = '';

    if (c.turno != null) {
      Map<String, String> turno = _buildTurnos(l10n).firstWhere((test) => test['id'].toString() == c.turno, orElse: () => {'id': '', 'text': ''});
      turnoLetra = turno['id'].toString()[0];
    }

    Color color = AppColors.primary;
    if (c.colorCiclo.startsWith('#')) {
      final hex = c.colorCiclo.replaceFirst('#', '');
      if (hex.length == 6) color = Color(int.parse('FF$hex', radix: 16));
    }

    final alumnosAsync = ref.watch(alumnosByCursoProvider(c.id));

    return Scaffold(
      key: key,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => setState(
                      () => _currentView = CursosViewMode.templateDetail),
                  icon: Icon(Icons.arrow_back,
                      color: textColor.withValues(alpha: 0.7)),
                  label: Text(l10n.adminCursosVolverGrupos,
                      style: TextStyle(
                          color: textColor.withValues(alpha: 0.7),
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color:
                            isDark ? AppColors.border : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                            child: Text(
                                getDisplayCursoLetters(c.etapaCurso, c.desdoblamiento, turnoLetra),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.codigoGrupo,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold)),
                            Text(c.tutorNombre ?? l10n.adminCursosSinTutor,
                                style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.textMuted,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.adminCursosAlumnosMatriculados,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    if (isAdmin)
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showAddStudentToCourseDialog(context, c.id),
                        icon: const Icon(Icons.person_add_outlined),
                        label: Text(l10n.adminCursosAniadirAlumno),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                alumnosAsync.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(
                      child: Text('Error: $e',
                          style: const TextStyle(color: Colors.red))),
                  data: (alumnos) {
                    if (alumnos.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.backgroundDarkSurface
                                : AppColors.backgroundLightSurface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: isDark
                                    ? AppColors.border
                                    : AppColors.borderLight,
                                style: BorderStyle.none)),
                        child: Center(
                            child: Text(
                                l10n.adminCursosSinAlumnos,
                                style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.textMuted))),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: alumnos.length,
                      itemBuilder: (context, index) {
                        final a = alumnos[index];
                        final isActive = a.estado.toUpperCase() == 'ACTIVO';

                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                backgroundColor: isDark
                                    ? AppColors.backgroundDark
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: 1200, maxHeight: 800),
                                  child: Scaffold(
                                    backgroundColor: Colors.transparent,
                                    appBar: AppBar(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      title: Text(
                                          'Horario: ${a.nombreCompleto}',
                                          style: TextStyle(color: textColor)),
                                      leading: IconButton(
                                          icon: Icon(Icons.close,
                                              color: textColor),
                                          onPressed: () => Navigator.pop(ctx)),
                                    ),
                                    body: HorarioScreen(
                                        isStudent: true, studentId: a.id),
                                  ),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.backgroundDarkCard
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: isActive
                                      ? (isDark
                                          ? AppColors.border
                                          : AppColors.borderLight)
                                      : Colors.red.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                GaulaProfileImage(
                                  fotoUrl: a.fotoUrl,
                                  nombre: a.nombreCompleto,
                                  radius: 20,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(a.nombreCompleto,
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold)),
                                      Text(a.email,
                                          style: TextStyle(
                                              color: isDark
                                                  ? AppColors.textSecondary
                                                  : AppColors.textMuted,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        (isActive ? Colors.green : Colors.red)
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: (isActive
                                                ? Colors.green
                                                : Colors.red)
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    isActive ? l10n.estadoActivo : l10n.estadoInactivo,
                                    style: TextStyle(
                                        color: isActive
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (isAdmin) ...[
                                  const SizedBox(width: 8),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert,
                                        color: textColor.withValues(alpha: 0.7)),
                                    color: isDark
                                        ? AppColors.backgroundDarkCard
                                        : Colors.white,
                                    onSelected: (val) async {
                                      if (val == 'toggle') {
                                        final nuevoEstado =
                                            isActive ? 'INACTIVO' : 'ACTIVO';
                                        await ref
                                            .read(alumnosCrudProvider.notifier)
                                            .cambiarEstado(a.id, nuevoEstado);
                                        ref.invalidate(
                                            alumnosByCursoProvider(c.id));
                                      } else if (val == 'remove') {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: isDark
                                                ? AppColors.backgroundDarkCard
                                                : Colors.white,
                                            title: Text(l10n.adminCursosQuitarAlumno,
                                                style:
                                                    TextStyle(color: textColor)),
                                            content: Text(
                                                '¿Deseas quitar a ${a.nombreCompleto} de este curso?',
                                                style: TextStyle(
                                                    color: isDark
                                                        ? AppColors.textSecondary
                                                        : AppColors.textMuted)),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: const Text('Cancelar')),
                                              ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red),
                                                  child: const Text('Quitar')),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          final ok = await ref
                                              .read(alumnosCrudProvider.notifier)
                                              .desmatricular(a.id);
                                          if (ok) {
                                            ref.invalidate(
                                                alumnosByCursoProvider(c.id));
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '✅ ${a.nombreCompleto} desmatriculado del curso')));
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      PopupMenuItem(
                                          value: 'toggle',
                                          child: Text(
                                              isActive ? l10n.adminAnioDesactivar : l10n.adminAnioActivar,
                                              style:
                                                  TextStyle(color: textColor))),
                                      const PopupMenuItem(
                                          value: 'remove',
                                          child: Text('Quitar del curso',
                                              style: TextStyle(
                                                  color: Colors.redAccent))),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
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

  void _showAddStudentToCourseDialog(BuildContext context, int cursoId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    
    showDialog(
      context: context,
      builder: (ctx) {
        String dialogSearchQuery = '';
        dynamic selectedAlumno; // AlumnoModel?
        List<int> selectedMateriaIds = [];
        bool initializedMaterias = false;
        bool isSubmitting = false;

        return Consumer(
          builder: (context, ref, _) {
            return Dialog(
              backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: StatefulBuilder(
                    builder: (context, setInnerState) {
                      if (selectedAlumno == null) {
                        // STEP 1: SEARCH AND SELECT STUDENT
                        final alumnosAsync = ref.watch(alumnosSinMatricularProvider);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Añadir Alumno al Curso',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 24),
                            TextField(
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).buscarPorNombre,
                                hintStyle: const TextStyle(color: AppColors.textMuted),
                                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.backgroundDarkSurface
                                    : AppColors.backgroundLightSurface,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: isDark ? AppColors.border : AppColors.borderLight)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: isDark ? AppColors.border : AppColors.borderLight)),
                              ),
                              onChanged: (val) => setInnerState(() => dialogSearchQuery = val),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: alumnosAsync.when(
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => Center(child: Text('Error: $e')),
                                data: (alumnos) {
                                  final filtered = alumnos
                                      .where((a) => a.nombreCompleto
                                          .toLowerCase()
                                          .contains(dialogSearchQuery.toLowerCase()))
                                      .toList();
                                  if (filtered.isEmpty) {
                                    return const Center(
                                      child: Text('No se encontraron alumnos.',
                                          style: TextStyle(color: AppColors.textSecondary)),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final a = filtered[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                          child: Text(
                                            a.avatar.length == 1 || !a.avatar.contains('.')
                                                ? (a.avatar.isNotEmpty ? a.avatar[0].toUpperCase() : '?')
                                                : (a.nombreCompleto.isNotEmpty ? a.nombreCompleto[0].toUpperCase() : '?'),
                                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        title: Text(a.nombreCompleto, style: TextStyle(color: textColor)),
                                        subtitle: Text(a.email,
                                            style: TextStyle(
                                                color: isDark ? AppColors.textSecondary : AppColors.textMuted)),
                                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                                        onTap: () {
                                          setInnerState(() {
                                            selectedAlumno = a;
                                            initializedMaterias = false;
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        // STEP 2: MATERIA CHECKLIST
                        final materiasAsync = ref.watch(cursoMateriasProvider(cursoId));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).asignarMaterias,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                              'Matricular a ${selectedAlumno.nombreCompleto} en las materias seleccionadas del curso.',
                              style: TextStyle(
                                  color: isDark ? AppColors.textSecondary : AppColors.textMuted,
                                  fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: materiasAsync.when(
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => Center(child: Text('Error: $e')),
                                data: (materias) {
                                  if (materias.isEmpty) {
                                    return const Center(
                                      child: Text('Este curso no tiene materias asignadas.',
                                          style: TextStyle(color: AppColors.textSecondary)),
                                    );
                                  }

                                  if (!initializedMaterias) {
                                    selectedMateriaIds = materias
                                        .map((m) => m['id'] as int)
                                        .toList();
                                    initializedMaterias = true;
                                  }

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setInnerState(() {
                                                selectedMateriaIds = materias
                                                    .map((m) => m['id'] as int)
                                                    .toList();
                                              });
                                            },
                                            child: Text(AppLocalizations.of(context).marcarTodos),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setInnerState(() {
                                                selectedMateriaIds = [];
                                              });
                                            },
                                            child: Text(AppLocalizations.of(context).desmarcarTodos),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 300,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: materias.length,
                                            itemBuilder: (context, index) {
                                              final m = materias[index];
                                              final mId = m['id'] as int;
                                              final isChecked = selectedMateriaIds.contains(mId);
                                              return CheckboxListTile(
                                                title: Text(m['nombre'] ?? 'Materia',
                                                    style: TextStyle(color: textColor, fontSize: 14)),
                                                subtitle: Text(m['codigo'] ?? '',
                                                    style: const TextStyle(
                                                        color: AppColors.textSecondary, fontSize: 12)),
                                                activeColor: AppColors.primary,
                                                value: isChecked,
                                                onChanged: (val) {
                                                  setInnerState(() {
                                                    if (val == true) {
                                                      selectedMateriaIds.add(mId);
                                                    } else {
                                                      selectedMateriaIds.remove(mId);
                                                    }
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: isSubmitting
                                      ? null
                                      : () {
                                          setInnerState(() {
                                            selectedAlumno = null;
                                          });
                                        },
                                  child: Text(AppLocalizations.of(context).atras,
                                      style: TextStyle(color: isDark ? Colors.white70 : AppColors.textMuted)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: isSubmitting
                                      ? null
                                      : () async {
                                          setInnerState(() {
                                            isSubmitting = true;
                                          });
                                          final ok = await ref
                                              .read(alumnosCrudProvider.notifier)
                                              .matricularEnCurso(selectedAlumno.id, cursoId,
                                                  materiaIds: selectedMateriaIds);
                                          if (!context.mounted || !ctx.mounted) return;
                                          setInnerState(() {
                                            isSubmitting = false;
                                          });
                                          if (ok) {
                                            Navigator.pop(ctx);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '✅ ${selectedAlumno.nombreCompleto} matriculado en el curso')));
                                            ref.invalidate(alumnosByCursoProvider(cursoId));
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text('❌ Error al matricular al alumno.'),
                                                    backgroundColor: Colors.red));
                                          }
                                        },
                                  child: isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : Text(AppLocalizations.of(context).matricular, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _badge(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
  );
}







