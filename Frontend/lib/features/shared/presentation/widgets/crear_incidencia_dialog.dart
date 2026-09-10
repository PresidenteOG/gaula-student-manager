import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../providers/incidencia_provider.dart';
import '../../../admin/application/providers/alumnos_provider.dart';


class CrearIncidenciaDialog extends ConsumerStatefulWidget {
  final String userRole;
  final Map<String, dynamic>? preSelectedStudent;

  const CrearIncidenciaDialog({
    super.key,
    required this.userRole,
    this.preSelectedStudent,
  });

  @override
  ConsumerState<CrearIncidenciaDialog> createState() => _CrearIncidenciaDialogState();
}

class _CrearIncidenciaDialogState extends ConsumerState<CrearIncidenciaDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _priority = 'LEVE';
  Map<String, dynamic>? _selectedTarget;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedStudent != null) {
      _selectedTarget = widget.preSelectedStudent;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.crearIncidenciaCompletaCampos), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedTarget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.crearIncidenciaSeleccionaAlumno), backgroundColor: Colors.red),
      );
      return;
    }

    final usuario = ref.read(usuarioActualProvider);
    if (usuario == null) return;

    setState(() => _isLoading = true);

    final isProfesor = usuario.esDocente || usuario.esAdmin;

    final success = await ref.read(incidenciaCrudProvider.notifier).crear({
      'titulo': _titleCtrl.text.trim(),
      'descripcion': _descCtrl.text.trim(),
      'alumnoId': int.parse(_selectedTarget!['id'].toString()),
      'profesorId': isProfesor ? usuario.id : null,
      'gravedad': _priority,
    });

    if (mounted) {
      setState(() => _isLoading = false);
      final l10nMounted = AppLocalizations.of(context);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10nMounted.crearIncidenciaExito), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10nMounted.crearIncidenciaError), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final subColor = isDark ? AppColors.textSecondary : AppColors.textMuted;
    final borderColor = isDark ? AppColors.border : AppColors.borderLight;
    final surfaceColor = isDark
        ? AppColors.backgroundDarkSurface.withValues(alpha: 0.3)
        : Colors.grey.shade100;
    final isStudentRole = widget.userRole == 'alumno' || widget.userRole == 'student';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.incidenciaNueva,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isStudentRole
                                ? l10n.crearIncidenciaSubtituloAlumno
                                : l10n.crearIncidenciaSubtituloProfesor,
                            style: TextStyle(color: subColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: subColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Alumno / Target Section
                Text(
                  l10n.crearIncidenciaAlumnoLabel,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                if (_selectedTarget == null)
                  _SearchField(
                    isDark: isDark,
                    textColor: textColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    onSelect: (val) => setState(() => _selectedTarget = val),
                  )
                else
                  _SelectedTargetCard(
                    name: _selectedTarget!['name'],
                    course: _selectedTarget!['course'],
                    isDark: isDark,
                    textColor: textColor,
                    subColor: subColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    onRemove: widget.preSelectedStudent == null
                        ? () => setState(() => _selectedTarget = null)
                        : null,
                  ),
                const SizedBox(height: 24),

                // Title
                Text(
                  l10n.crearIncidenciaTituloLabel,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _CustomTextField(
                  controller: _titleCtrl,
                  hint: l10n.crearIncidenciaTituloHint,
                  isDark: isDark,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  l10n.crearIncidenciaDescripcionLabel,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _CustomTextField(
                  controller: _descCtrl,
                  hint: l10n.crearIncidenciaDescripcionHint,
                  maxLines: 4,
                  isDark: isDark,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                ),
                const SizedBox(height: 24),

                // Priority
                Text(
                  l10n.crearIncidenciaGravedadLabel,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['LEVE', 'GRAVE', 'MUY_GRAVE'].map((p) {
                    final isSel = _priority == p;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _priority = p),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSel ? AppColors.primary : borderColor,
                                  width: 2),
                            ),
                            child: Center(
                              child: Text(
                                p,
                                style: TextStyle(
                                  color: isSel ? AppColors.primary : subColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: isDark
                              ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5)
                              : Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          l10n.cancelar,
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(
                                l10n.crearIncidenciaBoton,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
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
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool isDark;
  final Color textColor;
  final Color surfaceColor;
  final Color borderColor;

  const _CustomTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    required this.isDark,
    required this.textColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class _SelectedTargetCard extends StatelessWidget {
  final String name;
  final String course;
  final VoidCallback? onRemove;
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final Color borderColor;

  const _SelectedTargetCard({
    required this.name,
    required this.course,
    this.onRemove,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold)),
                Text(course,
                    style: TextStyle(color: subColor, fontSize: 12)),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                onPressed: onRemove),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  final Function(Map<String, dynamic>) onSelect;
  final bool isDark;
  final Color textColor;
  final Color surfaceColor;
  final Color borderColor;

  const _SearchField({
    required this.onSelect,
    required this.isDark,
    required this.textColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alumnosAsync = ref.watch(alumnosListProvider);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          TextField(
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: l10n.crearIncidenciaBuscarAlumno,
              hintStyle: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.textMuted),
              prefixIcon: Icon(Icons.search,
                  color: isDark ? AppColors.textSecondary : AppColors.textMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onChanged: (val) {
              // Local filter logic can be added here
            },
          ),
          alumnosAsync.when(
            data: (resp) => Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resp.content.length,
                itemBuilder: (context, i) {
                  final a = resp.content[i];
                  return ListTile(
                    title: Text('${a.nombre} ${a.apellidos}',
                        style: TextStyle(color: textColor, fontSize: 13)),
                    subtitle: Text(a.codigoGrupo ?? l10n.crearIncidenciaSinGrupo,
                        style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.textMuted,
                            fontSize: 11)),
                    onTap: () => onSelect({
                      'id': a.id.toString(),
                      'name': '${a.nombre} ${a.apellidos}',
                      'course': a.codigoGrupo ?? '',
                    }),
                  );
                },
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Text(l10n.crearIncidenciaErrorAlumnos,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}



