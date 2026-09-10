import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/alumnos_provider.dart';
import '../../application/providers/profesores_provider.dart';
import '../../../shared/providers/incidencia_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddIncidenciaDialog extends ConsumerStatefulWidget {
  const AddIncidenciaDialog({super.key});

  @override
  ConsumerState<AddIncidenciaDialog> createState() =>
      _AddIncidenciaDialogState();
}

class _AddIncidenciaDialogState extends ConsumerState<AddIncidenciaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  int? _selectedAlumnoId;
  int? _selectedProfesorId;
  String _selectedGravedad = 'LEVE';

  bool _isLoading = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_selectedAlumnoId == null || _selectedProfesorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addIncidenciaValidacionSeleccion)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref.read(incidenciaCrudProvider.notifier).crear({
      'titulo': _tituloController.text.trim(),
      'descripcion': _descripcionController.text.trim(),
      'alumnoId': _selectedAlumnoId,
      'profesorId': _selectedProfesorId,
      'gravedad': _selectedGravedad,
    });

    if (mounted) {
      setState(() => _isLoading = false);
      final l10nMounted = AppLocalizations.of(context);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10nMounted.addIncidenciaSuccessCreada)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10nMounted.addIncidenciaErrorCrear)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alumnosAsync = ref.watch(alumnosTodosProvider);
    final profesoresAsync = ref.watch(profesoresListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Dialog(
      backgroundColor: bg,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isDark ? AppColors.border : AppColors.borderLight)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 560,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.addIncidenciaTitulo,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  _label(l10n.addIncidenciaFieldTitulo, textColor),
                  TextFormField(
                    controller: _tituloController,
                    style: TextStyle(color: textColor),
                    decoration: _inputDec(l10n.addIncidenciaHintTitulo,
                        isDark: isDark),
                    validator: (v) =>
                        v?.isEmpty ?? true ? l10n.addIncidenciaCampoObligatorio : null,
                  ),
                  const SizedBox(height: 16),

                  _label(l10n.addIncidenciaFieldAlumno, textColor),
                  alumnosAsync.when(
                    data: (alumnos) => _SearchableDropdown<int>(
                      isDark: isDark,
                      textColor: textColor,
                      value: _selectedAlumnoId,
                      hint: l10n.addIncidenciaSelectAlumno,
                      items: alumnos
                          .map((a) => _SearchItem<int>(
                              id: a.id, label: a.nombreCompleto))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedAlumnoId = v),
                      searchHint: l10n.addIncidenciaBuscar,
                      noResultsText: l10n.addIncidenciaNoResultados,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(l10n.addIncidenciaErrorAlumnos,
                        style: const TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(height: 16),

                  _label(l10n.addIncidenciaFieldProfesor, textColor),
                  profesoresAsync.when(
                    data: (profesores) => _SearchableDropdown<int>(
                      isDark: isDark,
                      textColor: textColor,
                      value: _selectedProfesorId,
                      hint: l10n.addIncidenciaSelectProfesor,
                      items: profesores.content
                          .map((p) => _SearchItem<int>(
                              id: p.id, label: p.nombreCompleto))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedProfesorId = v),
                      searchHint: l10n.addIncidenciaBuscar,
                      noResultsText: l10n.addIncidenciaNoResultados,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(l10n.addIncidenciaErrorProfesores,
                        style: const TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(height: 16),

                  _label(l10n.addIncidenciaFieldGravedad, textColor),
                  DropdownButtonFormField<String>(
                    dropdownColor:
                        isDark ? AppColors.backgroundDarkSurface : Colors.white,
                    initialValue: _selectedGravedad,
                    items: [
                      DropdownMenuItem(
                          value: 'LEVE',
                          child: Text(l10n.incidenciaSeveridadLeve, style: TextStyle(color: textColor))),
                      DropdownMenuItem(
                          value: 'GRAVE',
                          child: Text(l10n.incidenciaSeveridadGrave, style: TextStyle(color: textColor))),
                      DropdownMenuItem(
                          value: 'MUY_GRAVE',
                          child: Text(l10n.incidenciaSeveridadMuyGrave, style: TextStyle(color: textColor))),
                    ],
                    onChanged: (v) => setState(() => _selectedGravedad = v!),
                    decoration: _inputDec(l10n.addIncidenciaHintGravedad, isDark: isDark),
                  ),
                  const SizedBox(height: 16),

                  _label(l10n.addIncidenciaFieldDescripcion, textColor),
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 4,
                    style: TextStyle(color: textColor),
                    decoration:
                        _inputDec(l10n.addIncidenciaHintDescripcion, isDark: isDark),
                    validator: (v) =>
                        v?.isEmpty ?? true ? l10n.addIncidenciaCampoObligatorio : null,
                  ),
                  const SizedBox(height: 32),

                  isMobile
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : Text(l10n.addIncidenciaButtonCrear),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.addIncidenciaButtonCancelar,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary)),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.addIncidenciaButtonCancelar,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : Text(l10n.addIncidenciaButtonCrear),
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

  Widget _label(String text, Color textColor) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold)));

  InputDecoration _inputDec(String hint, {required bool isDark}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: (isDark ? Colors.white : AppColors.textDark)
                .withValues(alpha: 0.3)),
        filled: true,
        fillColor: isDark
            ? AppColors.backgroundDarkSurface
            : AppColors.backgroundLightSurface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? AppColors.border : AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary)),
        contentPadding: const EdgeInsets.all(16),
      );
}

class _SearchItem<T> {
  final T id;
  final String label;
  _SearchItem({required this.id, required this.label});
}

class _SearchableDropdown<T> extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final T? value;
  final String hint;
  final List<_SearchItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String searchHint;
  final String noResultsText;

  const _SearchableDropdown({
    required this.isDark,
    required this.textColor,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.searchHint,
    required this.noResultsText,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((i) => i.id == value).firstOrNull;

    return InkWell(
      onTap: () => _showSearchDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.backgroundDarkSurface
              : AppColors.backgroundLightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? AppColors.border : AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedItem?.label ?? hint,
                style: TextStyle(
                    color: selectedItem == null
                        ? textColor.withValues(alpha: 0.3)
                        : textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down,
                color: textColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filter = searchController.text.toLowerCase();
            final filtered = items
                .where((i) => i.label.toLowerCase().contains(filter))
                .toList();

            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.backgroundDarkCard : Colors.white,
              title: TextField(
                controller: searchController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: searchHint,
                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.backgroundDarkSurface
                      : AppColors.backgroundLightSurface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isDark
                              ? AppColors.border
                              : AppColors.borderLight)),
                ),
                onChanged: (_) => setDialogState(() {}),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: filtered.isEmpty
                    ? Center(
                        child: Text(noResultsText,
                            style: TextStyle(
                                color: textColor.withValues(alpha: 0.5))))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title: Text(item.label,
                                style: TextStyle(color: textColor)),
                            onTap: () {
                              onChanged(item.id);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            );
          },
        );
      },
    );
  }
}



