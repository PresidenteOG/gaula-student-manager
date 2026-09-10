import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../shared/models/horario_model.dart';
import '../../../shared/models/curso_model.dart';
import '../../application/providers/profesores_provider.dart';
import '../../application/providers/cursos_provider.dart';
import '../../../shared/providers/horario_provider.dart';
import '../../../../shared/widgets/gaula_toast.dart';

const Map<String, String> _kDiaEnMap = {
  'LUNES': 'MONDAY',
  'MARTES': 'TUESDAY',
  'MIERCOLES': 'WEDNESDAY',
  'JUEVES': 'THURSDAY',
  'VIERNES': 'FRIDAY',
};

class AdminCursoHorarioView extends ConsumerStatefulWidget {
  final CursoModel curso;
  const AdminCursoHorarioView({super.key, required this.curso});

  @override
  ConsumerState<AdminCursoHorarioView> createState() => _AdminCursoHorarioViewState();
}

class _AdminCursoHorarioViewState extends ConsumerState<AdminCursoHorarioView> {
  final List<String> _dias = ['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES'];

  List<String> get _horas {
    if (widget.curso.turno == 'TARDE') {
      return [
        '15:30 - 16:30',
        '16:30 - 17:30',
        '17:30 - 18:30',
        '18:30 - 19:00',
        '19:00 - 20:00',
        '20:00 - 21:00',
        '21:00 - 22:00',
      ];
    } else {
      return [
        '08:00 - 09:00',
        '09:00 - 10:00',
        '10:00 - 11:00',
        '11:00 - 11:30',
        '11:30 - 12:30',
        '12:30 - 13:30',
        '13:30 - 14:30',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slotsAsync = ref.watch(cursoHorarioProvider(widget.curso.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isAdmin = ref.watch(usuarioActualProvider)?.esAdmin ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.adminCursoHorarioTitulo(widget.curso.codigoGrupo),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            if (isAdmin) ...[
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  final success = await ref.read(cursosCrudProvider.notifier).generarHorario(widget.curso.id);
                  if (context.mounted) {
                    if (success) {
                      GaulaToast.show(context,
                          title: l10n.adminCursoHorarioGeneradoTitle,
                          message: l10n.adminCursoHorarioGeneradoMsg,
                          type: GaulaToastType.success);
                    } else {
                      final error = ref.read(cursosCrudProvider).error;
                      GaulaToast.show(context,
                          title: l10n.adminCursoHorarioErrorTitle,
                          message: error != null ? _extractError(error) : l10n.adminCursoHorarioErrorTitle,
                          type: GaulaToastType.error);
                    }
                  }
                },
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text(l10n.adminCursoHorarioButtonGenerar),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddSlotDialog(),
                icon: const Icon(Icons.more_time, size: 18),
                label: Text(l10n.adminCursoHorarioButtonAsignar),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 32),

        if (widget.curso.materias.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Wrap(
              spacing: 12, runSpacing: 12,
              children: widget.curso.materias.map((m) {
                final mColor = _parseHexColor(m.color) ?? AppColors.primary;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _showColorPicker(m),
                        child: Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(color: mColor, shape: BoxShape.circle),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(m.nombre, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        Row(
          children: [
            const SizedBox(width: 100),
            ..._dias.map((dia) => Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  dia,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: 12),

        Expanded(
          child: slotsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text(l10n.adminCursoHorarioErrorCargar(e.toString()), style: const TextStyle(color: Colors.red))),
            data: (slots) => ListView.builder(
              itemCount: _horas.length,
              itemBuilder: (context, hourIdx) {
                final horaRange = _horas[hourIdx];
                final isRecreo = horaRange.contains('11:00 - 11:30') || horaRange.contains('18:30 - 19:00');

                return Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          horaRange,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ),
                    ),
                    ..._dias.map((dia) {
                      if (isRecreo) {
                        return Expanded(
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                l10n.adminCursoHorarioRecreo,
                                style: const TextStyle(color: AppColors.textSecondary, letterSpacing: 4, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }

                      final horaInicio = horaRange.split(' - ')[0];
                      final slot = _findSlot(slots, dia, horaInicio);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => slot == null && isAdmin
                              ? _showAddSlotDialog(dia: dia, hora: horaInicio)
                              : null,
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: slot != null
                                  ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                                  : (isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5) : Colors.white),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: slot != null ? AppColors.primary : (isDark ? AppColors.border : AppColors.borderLight),
                                width: slot != null ? 2 : 1,
                              ),
                            ),
                            child: slot != null
                                ? Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            slot.materiaNombre ?? l10n.adminCursoHorarioDesconocido,
                                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 2, overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            slot.aula ?? l10n.attendanceScheduleAulaFallback,
                                            style: TextStyle(color: textColor, fontWeight: FontWeight.w300, fontSize: 12),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              const Icon(Icons.person, size: 12, color: AppColors.textSecondary),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  slot.profesorNombre ?? l10n.adminCursoHorarioDesconocido,
                                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (isAdmin)
                                        Positioned(
                                          top: -8, right: -8,
                                          child: IconButton(
                                            icon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                                            onPressed: () async {
                                              final success = await ref.read(horarioCrudProvider.notifier).desactivarSesion(slot.id, widget.curso.id);
                                              if (context.mounted) {
                                                if (success) {
                                                  GaulaToast.show(context,
                                                      title: l10n.adminCursoHorarioEliminadoTitle,
                                                      message: l10n.adminCursoHorarioEliminadoMsg,
                                                      type: GaulaToastType.success);
                                                } else {
                                                  final error = ref.read(horarioCrudProvider).error;
                                                  GaulaToast.show(context,
                                                      title: l10n.adminCursoHorarioErrorTitle,
                                                      message: error != null ? _extractError(error) : l10n.adminCursoHorarioErrorTitle,
                                                      type: GaulaToastType.error);
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                    ],
                                  )
                                : Center(
                                    child: Icon(Icons.add, color: isDark ? Colors.white10 : Colors.grey.shade200),
                                  ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  HorarioSesionModel? _findSlot(List<HorarioSesionModel> slots, String dia, String hora) {
    final diaEn = _kDiaEnMap[dia] ?? dia;
    try {
      return slots.firstWhere((s) => s.diaSemana == diaEn && s.horaInicio == hora);
    } catch (_) {
      return null;
    }
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || !hex.startsWith('#')) return null;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return null;
    }
  }

  String _extractError(Object e) {
    try {
      final dynamic err = e;
      final data = err.response?.data;
      if (data is Map && data['message'] != null) return data['message'].toString();
      if (data is String && data.isNotEmpty) return data;
    } catch (_) {}
    return e.toString();
  }

  void _showColorPicker(dynamic materia) {
    const palette = [
      '#60A5FA', '#34D399', '#FBBF24', '#F472B6', '#A78BFA',
      '#F87171', '#FB923C', '#2DD4BF', '#818CF8', '#C084FC'
    ];

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
        final titleColor = isDark ? Colors.white : AppColors.textDark;
        return AlertDialog(
          backgroundColor: bg,
          title: Text(l10n.adminCursoHorarioElegirColor(materia.nombre as String),
              style: TextStyle(color: titleColor)),
          content: Wrap(
            spacing: 10, runSpacing: 10,
            children: palette.map((hex) => InkWell(
              onTap: () async {
                final success = await ref.read(cursosCrudProvider.notifier).updateMateriaColor(materia.id as int, hex, widget.curso.id);
                if (context.mounted) {
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    final error = ref.read(cursosCrudProvider).error;
                    GaulaToast.show(context,
                        title: l10n.adminCursoHorarioErrorTitle,
                        message: error != null ? _extractError(error) : l10n.adminCursoHorarioErrorTitle,
                        type: GaulaToastType.error);
                  }
                }
              },
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(hex.replaceFirst('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
              ),
            )).toList(),
          ),
        );
      },
    );
  }

  void _showAddSlotDialog({String? dia, String? hora}) {
    showDialog(
      context: context,
      builder: (context) => _AddSlotDialog(
        curso: widget.curso,
        initialDia: dia,
        initialHora: hora,
        onSave: (materiaId, profesorId, diaSemana, horaInicio, horaFin, aula) async {
          final l10n = AppLocalizations.of(context);
          final success = await ref.read(horarioCrudProvider.notifier).crearSesion({
            'diaSemana': diaSemana,
            'horaInicio': horaInicio,
            'horaFin': horaFin,
            'aula': aula,
            'materiaId': materiaId,
            'profesorId': profesorId,
          }, widget.curso.id);
          if (context.mounted) {
            if (success) {
              GaulaToast.show(context,
                  title: l10n.adminCursoHorarioAsignadoTitle,
                  message: l10n.adminCursoHorarioAsignadoMsg,
                  type: GaulaToastType.success);
            } else {
              final error = ref.read(horarioCrudProvider).error;
              GaulaToast.show(context,
                  title: l10n.adminCursoHorarioErrorAsignar,
                  message: error != null ? _extractError(error) : l10n.adminCursoHorarioErrorAsignar,
                  type: GaulaToastType.error);
            }
          }
        },
      ),
    );
  }
}

class _AddSlotDialog extends ConsumerStatefulWidget {
  final CursoModel curso;
  final String? initialDia;
  final String? initialHora;
  final Function(int materiaId, int profesorId, String diaSemana, String horaInicio, String horaFin, String aula) onSave;

  const _AddSlotDialog({
    required this.curso,
    required this.onSave,
    this.initialDia,
    this.initialHora,
  });

  @override
  ConsumerState<_AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends ConsumerState<_AddSlotDialog> {
  late String _selectedDia;
  late String _selectedHora;
  late String _aula;
  int? _selectedMateriaId;
  int? _selectedProfesorId;

  final TextEditingController _aulaCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  bool _soloLibres = true;

  final List<String> _dias = ['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES'];
  late List<String> _horas;

  @override
  void initState() {
    super.initState();
    if (widget.curso.turno == 'TARDE') {
      _horas = ['15:30', '16:30', '17:30', '19:00', '20:00', '21:00'];
    } else {
      _horas = ['08:00', '09:00', '10:00', '11:30', '12:30', '13:30'];
    }

    _selectedDia = widget.initialDia ?? _dias[0];

    if (widget.initialHora != null && _horas.contains(widget.initialHora)) {
      _selectedHora = widget.initialHora!;
    } else {
      _selectedHora = _horas[0];
    }

    if (widget.curso.materias.isNotEmpty) {
      _selectedMateriaId = widget.curso.materias[0].id;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _aulaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profesoresAsync = ref.watch(profesoresListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: bg,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 560,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.adminCursoHorarioButtonAsignar,
                  style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(l10n.adminCursoHorarioDia, DropdownButton<String>(
                        value: _selectedDia,
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                        style: TextStyle(color: textColor),
                        underline: const SizedBox(),
                        items: _dias.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => setState(() {
                          _selectedDia = v!;
                          _selectedProfesorId = null;
                        }),
                      )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildField(l10n.adminCursoHorarioHoraInicio, DropdownButton<String>(
                        value: _selectedHora,
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                        style: TextStyle(color: textColor),
                        underline: const SizedBox(),
                        items: _horas.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                        onChanged: (v) => setState(() {
                          _selectedHora = v!;
                          _selectedProfesorId = null;
                        }),
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildField(l10n.adminCursoHorarioModuloMateria, DropdownButton<int>(
                  value: _selectedMateriaId,
                  isExpanded: true,
                  hint: Text(l10n.adminCursoHorarioSeleccionarModulo,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                  style: TextStyle(color: textColor),
                  underline: const SizedBox(),
                  items: widget.curso.materias.isEmpty
                      ? [DropdownMenuItem(value: null, child: Text(l10n.adminCursoHorarioNoMaterias))]
                      : widget.curso.materias.map((m) => DropdownMenuItem(value: m.id, child: Text('${m.codigo} - ${m.nombre}'))).toList(),
                  onChanged: widget.curso.materias.isEmpty ? null : (v) => setState(() => _selectedMateriaId = v),
                )),
                const SizedBox(height: 20),

                Text(
                  l10n.attendanceScheduleAulaFallback,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _aulaCtrl,
                  onChanged: (val) => setState(() { _aula = val; }),
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.horarioAulaDefault,
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  l10n.adminCursoHorarioProfesorAsignado,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.adminCursoHorarioBuscarProfesor,
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Switch.adaptive(
                      value: _soloLibres,
                      onChanged: (v) => setState(() {
                        _soloLibres = v;
                        _selectedProfesorId = null;
                      }),
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.adminCursoHorarioSoloLibres(_selectedHora),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                profesoresAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: LinearProgressIndicator(),
                  ),
                  error: (_, __) => Text(
                    l10n.adminCursoHorarioErrorProfesores,
                    style: const TextStyle(color: Colors.red),
                  ),
                  data: (profesores) {
                    final diaEn = _kDiaEnMap[_selectedDia] ?? _selectedDia;

                    final Map<int, bool> libreMap = {};
                    for (final p in profesores.content) {
                      final sesionesAsync = ref.watch(sesionesDeProfesorProvider(p.id));
                      libreMap[p.id] = sesionesAsync.maybeWhen(
                        data: (lista) => !lista.any(
                          (s) => s.diaSemana == diaEn && s.horaInicio == _selectedHora,
                        ),
                        orElse: () => true,
                      );
                    }

                    final query = _searchCtrl.text.toLowerCase();
                    final filtrados = profesores.content.where((p) {
                      if (query.isNotEmpty && !p.nombreCompleto.toLowerCase().contains(query)) {
                        return false;
                      }
                      if (_soloLibres && !(libreMap[p.id] ?? true)) return false;
                      return true;
                    }).toList();

                    if (filtrados.isEmpty) {
                      return Container(
                        height: 72,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            l10n.adminCursoHorarioNoProfesores,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      );
                    }

                    return Container(
                      constraints: const BoxConstraints(maxHeight: 210),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: filtrados.length,
                        itemBuilder: (ctx, i) {
                          final p = filtrados[i];
                          final isSelected = _selectedProfesorId == p.id;
                          final isLibre = libreMap[p.id] ?? true;

                          return InkWell(
                            onTap: () => setState(() => _selectedProfesorId = p.id),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.nombreCompleto,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : (isDark ? Colors.white : AppColors.textDark),
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  if (!_soloLibres)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isLibre
                                            ? Colors.green.withValues(alpha: 0.15)
                                            : Colors.red.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isLibre ? l10n.adminCursoHorarioLibre : l10n.adminCursoHorarioOcupado,
                                        style: TextStyle(
                                          color: isLibre ? Colors.green : Colors.redAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (isSelected)
                                    const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.adminCursoHorarioCancelar,
                          style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: (_selectedMateriaId != null && _selectedProfesorId != null)
                          ? () {
                              final hFin = _horas.indexOf(_selectedHora) < _horas.length - 1
                                  ? _horas[_horas.indexOf(_selectedHora) + 1]
                                  : (widget.curso.turno == 'TARDE' ? '22:00' : '14:30');

                              final diaEnum = _kDiaEnMap[_selectedDia.toUpperCase()
                                  .replaceAll('Á', 'A')
                                  .replaceAll('É', 'E')
                                  .replaceAll('Í', 'I')
                                  .replaceAll('Ó', 'O')
                                  .replaceAll('Ú', 'U')] ?? 'MONDAY';

                              widget.onSave(_selectedMateriaId!, _selectedProfesorId!, diaEnum, _selectedHora, hFin, _aula);
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.adminCursoHorarioAsignarButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: child,
        ),
      ],
    );
  }
}
