import 'package:flutter/material.dart';
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/gaula_profile_image.dart';
import '../../../../shared/widgets/gaula_searchable_dropdown.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/profesores_provider.dart';
import '../../application/providers/cursos_provider.dart';
import '../../domain/entities/profesor_model.dart';
import '../widgets/add_profesor_dialog.dart';
import '../widgets/gaula_pagination.dart';
import '../../../shared/providers/horario_provider.dart';
import '../../../shared/models/horario_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminProfesoresScreen extends ConsumerStatefulWidget {
  const AdminProfesoresScreen({super.key});

  @override
  ConsumerState<AdminProfesoresScreen> createState() =>
      _AdminProfesoresScreenState();
}

class _AdminProfesoresScreenState extends ConsumerState<AdminProfesoresScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _resetPage() {
    ref.read(profesoresPageProvider.notifier).state = 0;
  }

  void _openAddEdit(BuildContext context, WidgetRef ref,
      [ProfesorModel? profesor]) {
    showDialog(
      context: context,
      builder: (context) => AddProfesorDialog(profesor: profesor),
    );
  }

  void _showTeacherSchedule(
      BuildContext context, WidgetRef ref, ProfesorModel profesor) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context).horarioTitulo,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return _TeacherScheduleDialog(profesor: profesor, isDark: isDark);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(profesoresListProvider);
    final cursosAsync = ref.watch(cursosListProvider);
    final usuario = ref.watch(usuarioActualProvider);
    final esAdmin = usuario?.esAdmin ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final currentPage = ref.watch(profesoresPageProvider);
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
                              Text(l10n.profesoresTitulo,
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1)),
                              const SizedBox(height: 16),
                              if (esAdmin)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openAddEdit(context, ref),
                                    icon: const Icon(Icons.person_add_rounded,
                                        size: 20),
                                    label: Text(l10n.registrarNuevoProfesor),
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
                                  Text(l10n.profesoresTitulo,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -1.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                      l10n.profesoresTituloDesc,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              )),
                              const SizedBox(width: 16),
                              if (esAdmin)
                                ElevatedButton.icon(
                                  onPressed: () => _openAddEdit(context, ref),
                                  icon: const Icon(Icons.person_add_rounded,
                                      size: 20),
                                  label: Text(l10n.registrarNuevoProfesor),
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
                    // Filters Bar
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
                                      ref.read(profesoresBusquedaProvider.notifier).state = val;
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
                              Row(
                                children: [
                                  Expanded(
                                    child: cursosAsync.maybeWhen(
                                      data: (cursos) =>
                                          GaulaSearchableDropdown<int?>(
                                        initialValue: ref.watch(profesoresCursoFiltroProvider),
                                        items: [null, ...cursos.map((c) => c.id)],
                                        label: l10n.alumnoCurso,
                                        hint: l10n.filtrarPorCurso,
                                        itemLabel: (id) => id == null
                                            ? l10n.todosCursos
                                            : cursos
                                                .firstWhere((c) => c.id == id)
                                                .codigoGrupo,
                                        onChanged: (val) {
                                          ref
                                              .read(
                                                  profesoresCursoFiltroProvider.notifier)
                                              .state = val;
                                          _resetPage();
                                        },
                                      ),
                                      orElse: () => const SizedBox.shrink(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GaulaSearchableDropdown<String?>(
                                      initialValue: ref.watch(profesoresRolFiltroProvider),
                                      items: const [null, 'TEACHER'],
                                      label: l10n.adminProfesoresRolLabel,
                                      hint: l10n.filtrarPorRol,
                                      itemLabel: (r) => r == null
                                          ? l10n.todosRoles
                                          : l10n.docenteLabel,
                                      onChanged: (val) {
                                        ref
                                            .read(profesoresRolFiltroProvider.notifier)
                                            .state = val;
                                        _resetPage();
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
                                        ref.read(profesoresBusquedaProvider.notifier).state = val;
                                        _resetPage();
                                      });
                                    },
                                    style: TextStyle(color: textColor, fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: l10n.buscarProfesoresDetalle,
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
                              // Filtro de Curso
                              Expanded(
                                flex: 1,
                                child: cursosAsync.maybeWhen(
                                  data: (cursos) => GaulaSearchableDropdown<int?>(
                                    initialValue: ref.watch(profesoresCursoFiltroProvider),
                                    items: [null, ...cursos.map((c) => c.id)],
                                    label: l10n.alumnoCurso,
                                    hint: l10n.filtrarPorCurso,
                                    itemLabel: (id) => id == null
                                        ? l10n.todosCursos
                                        : cursos
                                            .firstWhere((c) => c.id == id)
                                            .codigoGrupo,
                                    onChanged: (val) {
                                      ref
                                          .read(
                                              profesoresCursoFiltroProvider.notifier)
                                          .state = val;
                                      _resetPage();
                                    },
                                  ),
                                  orElse: () => const SizedBox.shrink(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Filtro de Rol
                              Expanded(
                                flex: 1,
                                child: GaulaSearchableDropdown<String?>(
                                  initialValue: ref.watch(profesoresRolFiltroProvider),
                                  items: const [null, 'TEACHER'],
                                  label: l10n.adminProfesoresRolLabel,
                                  hint: l10n.filtrarPorRol,
                                  itemLabel: (r) => r == null
                                      ? l10n.todosRoles
                                      : l10n.docenteLabel,
                                  onChanged: (val) {
                                    ref
                                        .read(profesoresRolFiltroProvider.notifier)
                                        .state = val;
                                    _resetPage();
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),

              // Profesores List
              Expanded(
                child: listAsync.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, st) => Center(
                      child: Text('Error: $e',
                          style: const TextStyle(color: Colors.red))),
                  data: (paginatedResponse) {
                    final profesores = paginatedResponse.content;

                    if (profesores.isEmpty) {
                      return FadeIn(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_search_rounded,
                                  size: 100,
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey[200]),
                              const SizedBox(height: 24),
                              Text(
                                  l10n.sinProfesoresEncontrados,
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
                          child: GridView.builder(
                            padding: EdgeInsets.all(isMobile ? 20 : 40),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 1 : 2,
                              crossAxisSpacing: isMobile ? 16 : 32,
                              mainAxisSpacing: isMobile ? 16 : 32,
                              childAspectRatio: isMobile ? 1.2 : 2.2,
                            ),
                            itemCount: profesores.length,
                            itemBuilder: (context, index) {
                              final profesor = profesores[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 50 * index),
                                child: _TeacherCard(
                                  profesor: profesor,
                                  onEdit: () =>
                                      _openAddEdit(context, ref, profesor),
                                  onShowSchedule: () => _showTeacherSchedule(
                                      context, ref, profesor),
                                ),
                              );
                            },
                          ),
                        ),
                        GaulaPagination(
                          currentPage: currentPage,
                          totalPages: paginatedResponse.totalPages,
                          onPageChanged: (newPage) {
                            ref.read(profesoresPageProvider.notifier).state =
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

class _TeacherCard extends ConsumerWidget {
  final ProfesorModel profesor;
  final VoidCallback onEdit;
  final VoidCallback onShowSchedule;

  const _TeacherCard(
      {required this.profesor,
      required this.onEdit,
      required this.onShowSchedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 8,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.6)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GaulaProfileImage(
                    fotoUrl: profesor.fotoUrl ?? profesor.avatar,
                    nombre: profesor.nombreCompleto,
                    radius: 42,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                profesor.nombreCompleto,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _StatusBadge(estado: profesor.estado),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          (profesor.rol.toUpperCase() == 'ADMIN' || profesor.rol.toUpperCase() == 'ROLE_ADMIN')
                              ? l10n.directivaAdminLabel
                              : l10n.cuerpoDocenteLabel,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.email_outlined,
                                size: 16,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.7)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                profesor.email,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _SmallActionButton(
                              icon: Icons.calendar_month_rounded,
                              label: l10n.horarioTitulo,
                              onTap: onShowSchedule,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            _SmallActionButton(
                              icon: Icons.edit_note_rounded,
                              label: l10n.gestionar,
                              onTap: onEdit,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String estado;
  const _StatusBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final isActive = estado == 'ACTIVO';
    final color = isActive ? Colors.green : Colors.redAccent;
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

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SmallActionButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: color, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherScheduleDialog extends ConsumerStatefulWidget {
  final ProfesorModel profesor;
  final bool isDark;
  const _TeacherScheduleDialog({required this.profesor, required this.isDark});

  @override
  ConsumerState<_TeacherScheduleDialog> createState() =>
      _TeacherScheduleDialogState();
}

class _TeacherScheduleDialogState
    extends ConsumerState<_TeacherScheduleDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slotsAsync = ref.watch(sesionesDeProfesorProvider(widget.profesor.id));
    final textColor = widget.isDark ? Colors.white : AppColors.textDark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1300,
            maxHeight: 950,
            minWidth: 320,
          ),
          child: Container(
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
                color: widget.isDark ? AppColors.border : AppColors.borderLight,
                width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 80,
                  offset: const Offset(0, 40)),
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20)),
            ],
          ),
          child: Column(
            children: [
              // Premium Header
              Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isDark
                        ? [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent
                          ]
                        : [
                            AppColors.primary.withValues(alpha: 0.05),
                            Colors.transparent
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(widget.profesor.nombre[0],
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.horarioSemanalReal,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                          const SizedBox(height: 8),
                          Text(widget.profesor.nombreCompleto,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Search Bar
                    Flexible(
                      child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? Colors.white10
                              : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: widget.isDark
                                  ? Colors.white10
                                  : Colors.black12),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _query = val),
                          style: TextStyle(color: textColor, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: l10n.filtrarCursoMateria,
                            hintStyle: const TextStyle(color: AppColors.textSecondary),
                            icon: const Icon(Icons.search_rounded,
                                color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: widget.isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              // Grid Content
              Expanded(
                child: slotsAsync.when(
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (slots) {
                    final filtered = slots
                        .where((s) =>
                            (s.materiaNombre != null && s.materiaNombre!
                                .toLowerCase()
                                .contains(_query.toLowerCase())) ||
                            s.cursoId.toString().contains(_query))
                        .toList();

                    if (slots.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 80,
                                color:
                                    AppColors.textMuted.withValues(alpha: 0.2)),
                            const SizedBox(height: 24),
                            Text(
                                l10n.sinClasesHorarioProfesor,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 18)),
                          ],
                        ),
                      );
                    }

                    return _TeacherScheduleGrid(
                        slots: slots, filteredSlots: filtered);
                  },
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

class _TeacherScheduleGrid extends StatelessWidget {
  final List<HorarioSesionModel> slots;
  final List<HorarioSesionModel> filteredSlots;
  const _TeacherScheduleGrid(
      {required this.slots, required this.filteredSlots});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final List<String> dias = [
      'LUNES',
      'MARTES',
      'MIERCOLES',
      'JUEVES',
      'VIERNES'
    ];
    final List<String> diasLabel = [
      l10n.diaLunes.toUpperCase(),
      l10n.diaMartes.toUpperCase(),
      l10n.diaMiercoles.toUpperCase(),
      l10n.diaJueves.toUpperCase(),
      l10n.diaViernes.toUpperCase(),
    ];
    final List<String> horas = slots.map((s) => s.horaInicio).toSet().toList();
    horas.sort();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Column(
      children: [
        // Days Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color:
                isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
            border: Border(
                bottom: BorderSide(
                    color: isDark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.05))),
          ),
          child: Row(
            children: [
              const SizedBox(width: 120),
              ...diasLabel.map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 2.5))),
                  )),
            ],
          ),
        ),
        // Time Slots
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(32),
            itemCount: horas.length,
            itemBuilder: (context, idx) {
              final h = horas[idx];
              return IntrinsicHeight(
                child: Row(
                  children: [
                    // Hour Column
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(h,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(l10n.sesionLabel,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ),
                    VerticalDivider(width: 1, color: isDark ? Colors.white10 : Colors.black12),
                    // Days Columns
                    ...dias.map((d) {
                      final slot = _findSlot(d, h);
                      final isFiltered =
                          slot != null && filteredSlots.contains(slot);
                      final hasSlot = slot != null;

                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: hasSlot
                                ? (isFiltered
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.primary.withValues(alpha: 0.03))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: hasSlot
                                  ? (isFiltered
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : AppColors.primary
                                          .withValues(alpha: 0.1))
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.03)
                                      : Colors.black.withValues(alpha: 0.03)),
                              width: isFiltered ? 2 : 1,
                            ),
                          ),
                          child: hasSlot
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(slot.materiaNombre?.toUpperCase() ?? l10n.adminProfesoresDesconocido,
                                        style: TextStyle(
                                            color: isFiltered
                                                ? AppColors.primary
                                                : textColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                            letterSpacing: 0.5),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.groups_rounded,
                                            size: 14,
                                            color: isFiltered
                                                ? AppColors.primary
                                                    .withValues(alpha: 0.6)
                                                : AppColors.textSecondary),
                                        const SizedBox(width: 8),
                                        Text(l10n.adminProfesoresCursoLabel(slot.cursoId.toString()),
                                            style: TextStyle(
                                                color: isFiltered
                                                    ? AppColors.primary
                                                        .withValues(alpha: 0.8)
                                                    : AppColors.textSecondary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static const _kDiaEnMap = {
    'LUNES':     'MONDAY',
    'MARTES':    'TUESDAY',
    'MIERCOLES': 'WEDNESDAY',
    'JUEVES':    'THURSDAY',
    'VIERNES':   'FRIDAY',
  };

  HorarioSesionModel? _findSlot(String dia, String hora) {
    final diaEn = _kDiaEnMap[dia] ?? dia;
    try {
      return slots
          .firstWhere((s) => s.diaSemana == diaEn && s.horaInicio == hora);
    } catch (_) {
      return null;
    }
  }
}







